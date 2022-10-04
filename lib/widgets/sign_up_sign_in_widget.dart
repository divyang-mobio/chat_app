import 'package:chat_app/resources/resource.dart';
import 'package:chat_app/screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../controllers/login_Bloc/login_bloc.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField(
      {Key? key,
      required this.controller,
      required this.hintName,
      required this.isPassword,
      required this.iconData,
      required this.validator,
      required this.textInputAction})
      : super(key: key);

  final TextEditingController controller;
  final String hintName;
  final bool isPassword;
  final IconData iconData;
  final FormFieldValidator validator;
  final TextInputAction textInputAction;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool isVisible = true;

  void showPassword() {
    isVisible = !isVisible;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: widget.validator,
      cursorColor: ColorResources().textFieldSignInSignUpColor,
      textInputAction: widget.textInputAction,
      obscureText: widget.isPassword
          ? isVisible
              ? true
              : false
          : false,
      controller: widget.controller,
      decoration: InputDecoration(
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                  color: ColorResources().textFieldSignInSignUpColor)),
          prefixIcon: Icon(widget.iconData,
              color: ColorResources().textFieldSignInSignUpIconColor),
          hintText: widget.hintName,
          suffixIcon: widget.isPassword
              ? IconButton(
                  onPressed: () => showPassword(),
                  icon: Icon(isVisible
                      ? IconResources().passSuffixShow
                      : IconResources().passSuffixUnShow))
              : null),
    );
  }
}

TextButton textButton(
    {required VoidCallback onPressed, required String title}) {
  return TextButton(
      onPressed: onPressed,
      child: Text(title,
          style: TextStyle(
              color: ColorResources().loginScreenTextButton,
              decoration: TextDecoration.underline,
              fontWeight: FontWeight.bold)));
}

Row commonSubmitButton(context,
    {required VoidCallback onPressed, required String title}) {
  return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
    Text(title, style: Theme.of(context).textTheme.headline6),
    FloatingActionButton(
      backgroundColor: ColorResources().loginScreenSubmitButton,
      foregroundColor: ColorResources().loginScreenSubmitButtonIcon,
      onPressed: onPressed,
      child: BlocConsumer<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state is LoginSuccess) {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const MainScreen()));
          } else if (state is LoginError) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.error)));
          }
        },
        builder: (context, state) {
          if (state is LoginInitial) {
            return Icon(IconResources().signUpSignInSubmitIcon);
          } else if (state is LoginLoading) {
            return CircularProgressIndicator.adaptive(
                backgroundColor: ColorResources().loginScreenCircularIndicator);
          } else {
            return Icon(IconResources().signUpSignInSubmitIcon);
          }
        },
      ),
    )
  ]);
}
