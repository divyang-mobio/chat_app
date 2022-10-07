import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String? uid;

  DatabaseService({this.uid});

  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');
  final CollectionReference groupCollection =
      FirebaseFirestore.instance.collection('groups');
  final CollectionReference personCollection =
      FirebaseFirestore.instance.collection('persons');

  Future addUserData({required String name, required String email}) async {
    return userCollection.doc(uid).set({
      'name': name,
      'email': email,
      'groups': [],
      'persons': [],
      'uid': uid,
      'profilePic':
          'https://firebasestorage.googleapis.com/v0/b/chat-app-78ff6.appspot.com/o/profile_image%2Fblank-profile-picture-g9792c8f6e_640.png?alt=media&token=80a52613-84da-4181-8bf3-33c302de5071'
    });
  }
}
