import 'package:bloc/bloc.dart';
import '../../resources/resource.dart';
import '../../utils/firestore_service.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import '../../utils/shared_data.dart';
import '../../widgets/upload_image.dart';

part 'upload_status_event.dart';

part 'upload_status_state.dart';

class UploadStatusBloc extends Bloc<UploadStatusEvent, UploadStatusState> {
  UploadStatusBloc() : super(UploadStatusInitial()) {
    on<UploadStatus>((event, emit) async {
      try {
        final file = event.sendDataType == SendDataType.image
            ? await getImage(
                imagePicker: ImagePicker(), imageSource: event.imageSource)
            : await getVideo(
                imagePicker: ImagePicker(), imageSource: event.imageSource);
        if (file != null) {
          final url = await uploadImageToFirebase(
              firebaseStorage: FirebaseStorage.instance,
              file: file,
              path: TextResources().statusStoreInStoragePath);
          final phone = await PreferenceServices().getPhone();
          final name = await PreferenceServices().getAdmin();
          final data =
              await DatabaseService(uid: await PreferenceServices().getUid())
                  .uploadStatus(
                      name: name == '' ? phone : name,
                      url: url,
                      type: event.sendDataType);
          if (data) {
            emit(UploadStatusSuccess());
            emit(UploadStatusInitial());
          }
        }
      } catch (e) {
        emit(UploadStatusError());
        emit(UploadStatusInitial());
      }
    });
  }
}
