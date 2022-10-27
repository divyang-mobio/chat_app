import 'package:chat_app/controllers/bottom_nav_bloc/bottom_navigation_bloc.dart';
import 'package:chat_app/controllers/group_bloc/send_group_data_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../controllers/upload_user_image_bloc/image_bloc.dart';
import '../models/user_model.dart';
import '../widgets/login_screens_widget.dart';
import 'package:flutter/material.dart';
import '../resources/resource.dart';
import '../widgets/network_image.dart';

class RegistrationGroupScreen extends StatefulWidget {
  const RegistrationGroupScreen({Key? key, required this.member})
      : super(key: key);

  final List<UserModel> member;

  @override
  State<RegistrationGroupScreen> createState() =>
      _RegistrationGroupScreenState();
}

class _RegistrationGroupScreenState extends State<RegistrationGroupScreen> {
  final TextEditingController _nameController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  String url = '';

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  GestureDetector showProfilePic(
      {required GestureTapCallback onTap, required Widget child}) {
    return GestureDetector(
        onTap: onTap,
        child: CircleAvatar(
            backgroundColor: ColorResources().registrationImageBg,
            radius: 60,
            child: child));
  }

  void navigator() {
    BlocProvider.of<BottomNavigationBloc>(context).add(OnChangeBar(index: 1));
    Navigator.pushNamedAndRemoveUntil(
        context, RoutesName().bottomBar, (router) => false);
  }

  void showError() {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(TextResources().error)));
  }

  CustomTextField textField() {
    return CustomTextField(
        controller: _nameController,
        hintName: TextResources().textFieldHint,
        iconData: IconResources().namePrefixInLogin,
        textInputAction: TextInputAction.next,
        validator: (value) {
          return null;
        },
        keyBoard: TextInputType.text,
        isLogin: false);
  }

  BlocConsumer uploadDataButton() {
    return BlocConsumer<SendGroupDataBloc, SendGroupDataState>(
      listener: (context, state) {
        if (state is SendGroupDataSuccess) {
          navigator();
        }
      },
      builder: (context, state) {
        if (state is SendGroupDataInitial) {
          return floatingActionButton(context, onPressed: () {
            BlocProvider.of<SendGroupDataBloc>(context).add(GiveGroupData(
                url: url,
                groupName: _nameController.text.trim(),
                data: widget.member));
          }, widget: Text(TextResources().createGroupButton));
        } else if (state is SendGroupDataLoading) {
          return floatingActionButton(context,
              onPressed: () {},
              widget: CircularProgressIndicator.adaptive(
                  valueColor: AlwaysStoppedAnimation<Color>(
                      ColorResources().loginScreenCircularIndicator)));
        } else if (state is SendGroupDataSuccess) {
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
                ])
              ],
            ),
          ),
        ),
      ),
    );
  }
}
