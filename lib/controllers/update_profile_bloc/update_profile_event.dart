part of 'update_profile_bloc.dart';

abstract class UpdateProfileEvent {}

class UpdateProfile extends UpdateProfileEvent {
  String url, name;

  UpdateProfile({required this.url, required this.name});
}
