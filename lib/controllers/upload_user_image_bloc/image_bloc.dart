import 'package:bloc/bloc.dart';
import 'package:chat_app/resources/resource.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import '../../widgets/upload_image.dart';

part 'image_event.dart';

part 'image_state.dart';

class ImageBloc extends Bloc<ImageEvent, ImageState> {
  ImageBloc() : super(ImageInitial()) {
    on<UploadImage>((event, emit) async {
      emit(ImageLoading());
      try {
        final image = await getImage(
            imagePicker: ImagePicker(), imageSource: ImageSource.gallery);
        if (image != null) {
          String url = await uploadImageToFirebase(
              firebaseStorage: FirebaseStorage.instance,
              file: image,
              path: TextResources().profileInStoragePath);
          emit(ImageLoaded(url: url));
        }
      } catch (e) {
        emit(ImageError());
        emit(ImageInitial());
      }
    });
    on<DeleteImage>((event, emit) async {
      emit(ImageLoading());
      try {
        await FirebaseStorage.instance.refFromURL(event.url).delete();
        emit(ImageInitial());
      } catch (e) {
        emit(ImageError());
        emit(ImageLoaded(url: event.url));
      }
    });
  }
}
