import 'dart:async';
import 'package:chat_app/models/chat_room_model.dart';
import 'package:chat_app/models/message_model.dart';
import 'package:chat_app/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../resources/resource.dart';
import '../widgets/json_model_stream_converter.dart';

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
      'status': false,
      'uid': uid,
      'profilePic': ''
    });
  }

  changeStatus({required bool status}) {
    userCollection.doc(uid).update({'status': status});
  }

  checkIndividualStatus() {
    return userCollection
        .where('uid', isEqualTo: uid)
        .snapshots()
        .transform(Utils.transformer(UserModel.fromJson));
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

  Stream<List<UserModel>> getAllUserData({required String email}) {
    try {
      return userCollection
          .where('email', isNotEqualTo: email)
          .snapshots()
          .transform(Utils.transformer(UserModel.fromJson));
    } catch (e) {
      throw 'error';
    }
  }

  sendMessage(
      {required String yourId,
      required String yourName,
      required String otherId,
      required SendDataType type,
      String? ids,
      required String message}) async {
    if (ids == null) {
      final data = await chatsCollection
          .where('persons.$yourId', isEqualTo: true)
          .where('persons.$otherId', isEqualTo: true)
          .get();
      if (data.docs.isEmpty) {
        final id = await createChatRoom(yourName: yourId, otherName: otherId);
        setMassage(id: id, name: yourName, message: message, type: type);
      } else {
        List<ChatRoom> id = data.docs
            .map((e) => ChatRoom.fromJson(e.data() as Map<String, dynamic>))
            .toList();
        setMassage(id: id[0].id, name: yourName, message: message, type: type);
      }
    } else {
      setMassage(id: ids, name: yourName, message: message, type: type);
    }
  }

  setMassage(
      {required String id,
      required String name,
      required String message,
      required SendDataType type}) {
    chatsCollection.doc(id).collection('message').doc().set({
      'name': name,
      'message': message,
      'type': (type == SendDataType.text)
          ? 'text'
          : (type == SendDataType.image)
              ? 'image'
              : 'video',
      'time': DateTime.now(),
    });
  }

  Stream<QuerySnapshot> getAllChatData({required String name}) {
    try {
      return chatsCollection.where('persons', arrayContains: name).snapshots();
    } catch (e) {
      throw 'error';
    }
  }

  getId({required String yourName, required String otherName}) async {
    final data = await chatsCollection
        .where('persons.$yourName', isEqualTo: true)
        .where('persons.$otherName', isEqualTo: true)
        .get();
    if (data.docs.isEmpty) {
      final id = await createChatRoom(yourName: yourName, otherName: otherName);
      return id;
    } else {
      List<ChatRoom> ids = data.docs
          .map((e) => ChatRoom.fromJson(e.data() as Map<String, dynamic>))
          .toList();

      return ids[0].id;
    }
  }

  Stream<List<MessageModel>> getMessages({required String id}) {
    return chatsCollection
        .doc(id)
        .collection('message')
        .orderBy('time', descending: true)
        .snapshots()
        .transform(Utils.transformer(MessageModel.fromJson));
  }
}
