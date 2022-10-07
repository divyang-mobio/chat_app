import 'package:firebase_auth/firebase_auth.dart';
import 'firestore_service.dart';

class FirebaseAuthService {
  final FirebaseAuth firebaseAuth;

  FirebaseAuthService({required this.firebaseAuth});

  Future signInUser({required String email, required String password}) async {
    try {
      await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return true;
    } catch (e) {
      throw e.toString();
    }
  }

  Future signUpUser(
      {required String name,
      required String email,
      required String password}) async {
    try {
      UserCredential result = await firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      if (result.user != null) {
        await result.user?.updateDisplayName(name);
        await DatabaseService(uid: result.user?.uid)
            .addUserData(name: name, email: email);
        return true;
      }
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
