part of 'new_contact_bloc.dart';

abstract class NewContactEvent {}

class GetNewContactData extends NewContactEvent{
  String uid;

  GetNewContactData({required this.uid});
}
