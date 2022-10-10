import 'dart:async';
import 'package:chat_app/models/chat_room_model.dart';
import 'package:chat_app/models/message_model.dart';
import 'package:chat_app/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String? uid;

  DatabaseService({this.uid});

  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');
  final CollectionReference chatsCollection =
      FirebaseFirestore.instance.collection('chats');

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

  Future createChatRoom(
      {required String yourName, required String otherName}) async {
    final getId = await chatsCollection.add({
      'persons': {yourName: true, otherName: true},
      'id': ''
    });
    await getId.update({'id': getId.id});

    return getId.id;
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

  sendMessage(
      {required String yourName,
      required String otherName,
      required String message}) async {
    final data = await chatsCollection
        .where('persons.$yourName', isEqualTo: true)
        .where('persons.$otherName', isEqualTo: true)
        .get();
    if (data.docs.isEmpty) {
      final id = await createChatRoom(yourName: yourName, otherName: otherName);
      chatsCollection.doc(id).collection('message').doc().set({
        'name': yourName,
        'message': message,
        'time': DateTime.now(),
      });
    } else {
      List<ChatRoom> id = data.docs
          .map((e) => ChatRoom.fromJson(e.data() as Map<String, dynamic>))
          .toList();
      chatsCollection.doc(id[0].id).collection('message').doc().set({
        'name': yourName,
        'message': message,
        'time': DateTime.now(),
      });
    }
  }

  Stream<QuerySnapshot> getAllChatData({required String name}) {
    try {
      return chatsCollection.where('persons', arrayContains: name).snapshots();
    } catch (e) {
      throw 'error';
    }
  }

  getId({required String yourName,
    required String otherName}) async {
    final data = await chatsCollection
        .where('persons.$yourName', isEqualTo: true)
        .where('persons.$otherName', isEqualTo: true)
        .get();
    List<ChatRoom> id = data.docs
        .map((e) => ChatRoom.fromJson(e.data() as Map<String, dynamic>))
        .toList();
    return id[0].id;
  }

  Stream<List<MessageModel>> getMessages(
      {required String id})  {
    return chatsCollection
        .doc(id)
        .collection('message').orderBy('time', descending: true)
        .snapshots()
        .transform(Utils.transformer(MessageModel.fromJson));
  }
}

class Utils {
  static StreamTransformer<QuerySnapshot<Map<String, dynamic>>, List<T>>
      transformer<T>(T Function(Map<String, dynamic> json) fromJson) =>
          StreamTransformer<QuerySnapshot<Map<String, dynamic>>,
              List<T>>.fromHandlers(
            handleData: (QuerySnapshot<Map<String, dynamic>> data,
                EventSink<List<T>> sink) {
              final snaps = data.docs.map((doc) => doc.data()).toList();
              final users = snaps.map((json) => fromJson(json)).toList();

              sink.add(users);
            },
          );
}
