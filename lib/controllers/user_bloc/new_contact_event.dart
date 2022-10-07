part of 'new_contact_bloc.dart';

abstract class NewContactEvent {}

class GetNewContactData extends NewContactEvent{
  String email;

  GetNewContactData({required this.email});
}
