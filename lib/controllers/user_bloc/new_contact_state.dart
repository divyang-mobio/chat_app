part of 'new_contact_bloc.dart';

abstract class NewContactState {}

class NewContactInitial extends NewContactState {}

class NewContactLoaded extends NewContactState {
  List<UserModel> newContactData;

  NewContactLoaded({required this.newContactData});
}

class NewContactError extends NewContactState {}
