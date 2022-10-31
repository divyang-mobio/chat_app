import 'package:chat_app/controllers/update_profile_bloc/update_profile_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../controllers/upload_user_image_bloc/image_bloc.dart';
import '../widgets/login_screens_widget.dart';
import 'package:flutter/material.dart';
import '../resources/resource.dart';
import '../widgets/network_image.dart';
import '../widgets/registration_screen_widgets.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final TextEditingController _nameController = TextEditingController();
  String url = '';

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void navigator() {
    Navigator.pushNamedAndRemoveUntil(
        context, RoutesName().bottomBar, (route) => false);
  }

  void showError() {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(TextResources().error)));
  }

  Positioned skipButton() {
    return Positioned.fill(
        child: Align(
      alignment: Alignment.topRight,
      child: TextButton(
        child: Text(TextResources().registrationScreenSkip),
        onPressed: () {
          navigator();
        },
      ),
    ));
  }

  BlocConsumer uploadDataButton() {
    return BlocConsumer<UpdateProfileBloc, UpdateProfileState>(
      listener: (context, state) {
        if (state is UpdateProfileLoaded) {
          navigator();
        } else if (state is UpdateProfileError) {
          showError();
        }
      },
      builder: (context, state) {
        if (state is UpdateProfileInitial) {
          return floatingActionButton(context, onPressed: () {
            BlocProvider.of<UpdateProfileBloc>(context).add(
                UpdateProfile(url: url, name: _nameController.text.trim()));
          }, widget: Text(TextResources().updateProfileString));
        } else if (state is UpdateProfileLoading) {
          return floatingActionButton(context,
              onPressed: () {},
              widget: CircularProgressIndicator.adaptive(
                  valueColor: AlwaysStoppedAnimation<Color>(
                      ColorResources().loginScreenCircularIndicator)));
        } else if (state is UpdateProfileLoaded) {
          return floatingActionButton(context,
              onPressed: () {},
              color: ColorResources().uploadImageSuccessButton,
              widget: Text(TextResources().registrationScreenUploadSuccess));
        } else {
          return floatingActionButton(context,
              onPressed: () {}, widget: Text(TextResources().error));
        }
      },
    );
  }

  CustomTextField textField() {
    return CustomTextField(
        controller: _nameController,
        hintName: TextResources().nameHintText,
        iconData: IconResources().namePrefixInLogin,
        textInputAction: TextInputAction.next,
        validator: (value) {
          return null;
        },
        keyBoard: TextInputType.text,
        isLogin: false);
  }

  BlocConsumer uploadImage() {
    return BlocConsumer<ImageBloc, ImageState>(
      listener: (context, state) {
        if (state is ImageError) {
          showError();
        }
      },
      builder: (context, state) {
        if (state is ImageInitial) {
          url = '';
          return showProfilePic(
              onTap: () {
                BlocProvider.of<ImageBloc>(context).add(UploadImage());
              },
              child:
                  ClipOval(child: Image.asset(ImagePath().noImageImagePath)));
        } else if (state is ImageLoading) {
          return showProfilePic(
              onTap: () {},
              child: const Center(child: CircularProgressIndicator.adaptive()));
        } else if (state is ImageLoaded) {
          url = state.url;
          return Stack(children: [
            showProfilePic(
              onTap: () {},
              child: ClipOval(
                child: SizedBox.fromSize(
                  size: const Size.fromRadius(60),
                  child: networkImages(link: state.url),
                ),
              ),
            ),
            Positioned.fill(
                child: Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                        onPressed: () {
                          BlocProvider.of<ImageBloc>(context)
                              .add(DeleteImage(url: state.url));
                        },
                        icon: Icon(
                            IconResources().removeImageOnRegistrationScreen,
                            color:
                                ColorResources().registrationImageRemoveIcon))))
          ]);
        } else {
          return Text(TextResources().error);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorResources().bgOfAllScreen,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: SingleChildScrollView(
            child: Stack(
              children: [
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Center(child: uploadImage()),
                  const SizedBox(height: 20),
                  textField(),
                  const SizedBox(height: 20),
                  uploadDataButton()
                ]),
                skipButton()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
