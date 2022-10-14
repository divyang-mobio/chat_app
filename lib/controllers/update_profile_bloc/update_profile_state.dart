part of 'update_profile_bloc.dart';

abstract class UpdateProfileState {}

class UpdateProfileInitial extends UpdateProfileState {}

class UpdateProfileLoading extends UpdateProfileState {}

class UpdateProfileLoaded extends UpdateProfileState {}

class UpdateProfileError extends UpdateProfileState {}
