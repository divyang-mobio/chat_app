import 'dart:async';
import '../models/chat_room_model.dart';
import '../models/message_model.dart';
import '../models/status_model.dart';
import '../models/user_model.dart';
import 'shared_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/group_model.dart';
import '../resources/resource.dart';
import '../widgets/json_model_stream_converter.dart';

class DatabaseService {
  final String? uid;

  DatabaseService({this.uid});

  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');
  final CollectionReference chatsCollection =
      FirebaseFirestore.instance.collection('chats');
  final CollectionReference groupCollection =
      FirebaseFirestore.instance.collection('groups');
  final CollectionReference statusCollection =
      FirebaseFirestore.instance.collection('status');

  Future addUserData({required String phone}) async {
    PreferenceServices().setNo(number: phone, uid: uid.toString());
    return userCollection.doc(uid).set({
      'name': '',
      'phone': phone,
      'status': false,
      'uid': uid,
      'profilePic': ''
    });
  }

  Future<bool> updateProfile({String name = '', String pic = ''}) async {
    await userCollection.doc(uid).update({'name': name, 'profilePic': pic});
    return true;
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
    await chatsCollection.doc("${yourName}_$otherName").set({
      'persons': {yourName: true, otherName: true},
      'id': "${yourName}_$otherName"
    });

    return '${yourName}_$otherName';
  }

  Stream<List<UserModel>> getAllUserData() {
    try {
      return userCollection
          .where('uid', isNotEqualTo: uid)
          .snapshots()
          .transform(Utils.transformer(UserModel.fromJson));
    } catch (e) {
      throw 'error';
    }
  }

  Stream<List<UserModel>> getAllUserDataForGroup() {
    try {
      return userCollection
          .orderBy('name')
          .snapshots()
          .transform(Utils.transformer(UserModel.fromJson));
    } catch (e) {
      throw 'error';
    }
  }

  makeAdmin(String groupId, String id) {
    groupCollection.doc(groupId).set({
      'admin': FieldValue.arrayUnion([id]),
    }, SetOptions(merge: true));
  }

  removeExitGroup(String groupId, String id) {
    groupCollection.doc(groupId).set({
      'persons': FieldValue.arrayRemove([id]),
      'admin': FieldValue.arrayRemove([id]),
    }, SetOptions(merge: true));
  }

  Stream<List<GroupModel>> getAllGroup() {
    try {
      return groupCollection
          .where('persons', arrayContains: uid)
          .snapshots()
          .transform(Utils.transformer(GroupModel.fromJson));
    } catch (e) {
      throw 'error';
    }
  }

  Stream<List<MessageDetailModel>> getUserChatList({required String yourId}) {
    try {
      return chatsCollection
          .where('persons.$yourId', isEqualTo: true)
          .snapshots()
          .transform(Utils.transformer(MessageDetailModel.fromJson));
    } catch (e) {
      throw 'error';
    }
  }

  Future<bool> createGroup(
      {required List<String> uid,
      required String groupName,
      required String adminUid,
      required String url}) async {
    try {
      final getId = await groupCollection.add({
        'admin': [adminUid],
        'persons': uid,
        'image': url,
        'id': '',
        'groupName': groupName,
      });

      await getId.update({'id': getId.id});

      return true;
    } catch (e) {
      throw e.toString();
    }
  }

  sendMessage(
      {required String yourId,
      required String yourName,
      required String otherId,
      required SendDataType type,
      MessageModel? messageModel,
      String? ids,
      required String message}) async {
    if (ids == null) {
      final data = await chatsCollection
          .where('persons.$yourId', isEqualTo: true)
          .where('persons.$otherId', isEqualTo: true)
          .get();
      if (data.docs.isEmpty) {
        final id = await createChatRoom(yourName: yourId, otherName: otherId);
        setMassage(
            id: id,
            name: yourName,
            message: message,
            type: type,
            uid: yourId,
            messageModel: messageModel);
      } else {
        List<ChatRoom> id = data.docs
            .map((e) => ChatRoom.fromJson(e.data() as Map<String, dynamic>))
            .toList();
        setMassage(
            id: id[0].id,
            name: yourName,
            message: message,
            type: type,
            messageModel: messageModel,
            uid: yourId);
      }
    } else {
      setMassage(
          id: ids,
          name: yourName,
          messageModel: messageModel,
          message: message,
          type: type,
          uid: yourId);
    }
  }

  Stream<List<UserModel>> getUserModelFromIdList(List<String> ids) {
    return userCollection
        .where('uid', whereIn: ids)
        .snapshots()
        .transform(Utils.transformer(UserModel.fromJson));
  }

  editMessage(
      {required String id,
      required String otherId,
      required bool isGroup,
      required String editMessage}) {
    if (isGroup) {
      groupCollection
          .doc(id)
          .collection('message')
          .doc(otherId)
          .update({'message': editMessage});
    } else {
      chatsCollection
          .doc(id)
          .collection('message')
          .doc(otherId)
          .update({'message': editMessage});
    }
  }

  deleteMessage(
      {required String id, required String otherId, required bool isGroup}) {
    if (isGroup) {
      groupCollection
          .doc(id)
          .collection('message')
          .doc(otherId)
          .update({'message': "This Message is Deleted"});
    } else {
      chatsCollection
          .doc(id)
          .collection('message')
          .doc(otherId)
          .update({'message': "This Message is Deleted"});
    }
  }

  sendMessageGroup(
      {required String id,
      required String name,
      required String message,
      required String uid,
      MessageModel? messageModel,
      required SendDataType type}) async {
    final ids = await groupCollection.doc(id).collection('message').add({
      'name': name,
      'message': message,
      'uid': uid,
      'id': '',
      'reply': (messageModel == null) ? null : messageModel.toJson(),
      'type': (type == SendDataType.text)
          ? 'text'
          : (type == SendDataType.image)
              ? 'image'
              : 'video',
      'time': DateTime.now(),
    });
    await ids.update({'id': ids.id});
  }

  setMassage(
      {required String id,
      required String name,
      required String message,
      required String uid,
      MessageModel? messageModel,
      required SendDataType type}) async {
    final ids = await chatsCollection.doc(id).collection('message').add({
      'name': name,
      'message': message,
      'uid': uid,
      'id': '',
      'reply': (messageModel == null) ? null : messageModel.toJson(),
      'type': (type == SendDataType.text)
          ? 'text'
          : (type == SendDataType.image)
              ? 'image'
              : 'video',
      'time': DateTime.now(),
    });

    await ids.update({'id': ids.id});
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

  Stream<List<MessageModel>> getMessages(
      {required String id, required bool isGroup}) {
    return (isGroup)
        ? groupCollection
            .doc(id)
            .collection('message')
            .orderBy('time', descending: true)
            .snapshots()
            .transform(Utils.transformer(MessageModel.fromJson))
        : chatsCollection
            .doc(id)
            .collection('message')
            .orderBy('time', descending: true)
            .snapshots()
            .transform(Utils.transformer(MessageModel.fromJson));
  }

  uploadStatus(
      {required String name,
      required String url,
      required SendDataType type}) async {
    try {
      final data = await statusCollection.where('id', isEqualTo: uid).get();
      if (data.docs.isNotEmpty) {
        await statusCollection.doc(uid).set({
          'image': FieldValue.arrayUnion([
            {
              'url': url,
              'date': DateTime.now(),
              'type': (type == SendDataType.text)
                  ? 'text'
                  : (type == SendDataType.image)
                      ? 'image'
                      : 'video'
            }
          ]),
          'date': DateTime.now()
        }, SetOptions(merge: true));
      } else {
        await statusCollection.doc(uid).set({
          'person': name,
          'image': [
            {
              'url': url,
              'date': DateTime.now(),
              'type': (type == SendDataType.text)
                  ? 'text'
                  : (type == SendDataType.image)
                      ? 'image'
                      : 'video'
            }
          ],
          'date': DateTime.now(),
          'id': uid,
        });
      }
      return true;
    } catch (e) {
      throw TextResources().error;
    }
  }

  Stream<List<StatusModel>> getStatus() {
    try {
      return statusCollection
          .where('date',
              isGreaterThanOrEqualTo: (DateTime.utc(DateTime.now().year,
                  DateTime.now().month, DateTime.now().day - 1)))
          .snapshots()
          .transform(Utils.transformer(StatusModel.fromJson));
    } catch (e) {
      throw TextResources().error;
    }
  }
}
