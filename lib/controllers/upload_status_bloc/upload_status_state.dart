part of 'upload_status_bloc.dart';

abstract class UploadStatusState {}

class UploadStatusInitial extends UploadStatusState {}

class UploadStatusSuccess extends UploadStatusState {}

class UploadStatusError extends UploadStatusState {}
