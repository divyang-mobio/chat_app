import 'dart:convert';

import 'package:chat_app/models/user_model.dart';
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
      'profilePic': ''
    });
  }

  Future getUserData({required String email}) async {
    QuerySnapshot data =
        await userCollection.where('email', isEqualTo: email).get();
    return data.docs
        .map((e) => UserModel.fromJson(e.data() as Map<String, dynamic>))
        .toList();
  }

  Future getAllUserData({required String email}) async {
    try {
      QuerySnapshot data =
          await userCollection.where('email', isNotEqualTo: email).get();
      return data.docs
          .map((e) => UserModel.fromJson(e.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw 'error';
    }
  }
}
