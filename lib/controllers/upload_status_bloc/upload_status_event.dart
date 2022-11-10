part of 'upload_status_bloc.dart';

abstract class UploadStatusEvent {}

class UploadStatus extends UploadStatusEvent {
  SendDataType sendDataType;
  ImageSource imageSource;

  UploadStatus({required this.imageSource, required this.sendDataType});
}
