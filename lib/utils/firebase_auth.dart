import 'package:firebase_auth/firebase_auth.dart';
import 'firestore_service.dart';

class FirebaseAuthService {
  final FirebaseAuth firebaseAuth;
  String verificationIDString = '';

  FirebaseAuthService({required this.firebaseAuth});

  Future enterOtp({required String otp}) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationIDString, smsCode: otp);
      await firebaseAuth.signInWithCredential(credential).then((value) async {
        await DatabaseService(uid: value.user?.uid)
            .addUserData(phone: (value.user?.phoneNumber).toString());
      });
      return true;
    } catch (e) {
      throw e.toString();
    }
  }

  Future enterPhone({required String phone}) async {
    try {
      await firebaseAuth.verifyPhoneNumber(
          phoneNumber: '+91 $phone',
          codeSent: (verificationID, token) {
            verificationIDString = verificationID;
          },
          codeAutoRetrievalTimeout: (verificationID) {},
          verificationCompleted: (credential) async => await firebaseAuth
              .signInWithCredential(credential)
              .then((value) => print('complete')),
          verificationFailed: (exception) {
            throw exception.toString();
          });
      return true;
    } catch (e) {
      throw e.toString();
    }
  }

  Future logOut() async {
    try {
      await firebaseAuth.signOut();
      return true;
    } catch (e) {
      throw e.toString();
    }
  }
}
