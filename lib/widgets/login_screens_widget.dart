import '../controllers/login_Bloc/login_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import '../resources/resource.dart';

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
  bool _isVisible = true;

  void _showPassword() => setState(() {
        _isVisible = !_isVisible;
      });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: widget.validator,
      cursorColor: ColorResources().textFieldSignInSignUpColor,
      textInputAction: widget.textInputAction,
      obscureText: widget.isPassword
          ? _isVisible
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
                  onPressed: () => _showPassword(),
                  icon: Icon(
                      _isVisible
                          ? IconResources().passSuffixShow
                          : IconResources().passSuffixUnShow,
                      color: ColorResources().textFieldSignInSignUpIconColor))
              : null),
    );
  }
}

Center image(context, {required String link}) {
  return Center(
    child: Image.asset(link, height: MediaQuery.of(context).size.height * .4),
  );
}

Text loginTitle(context, {required String title}) {
  return Text(TextResources().signInTile,
      style: Theme.of(context).textTheme.headline3?.copyWith(
          color: ColorResources().loginScreenTitle,
          fontWeight: FontWeight.bold));
}

Align textButton({required VoidCallback onPressed, required String title}) {
  return Align(
    alignment: Alignment.bottomCenter,
    child: TextButton(
        onPressed: onPressed,
        child: Text(title,
            style: TextStyle(
                color:  const Color.fromARGB(255, 0, 101, 255),
                fontWeight: FontWeight.bold))),
  );
}

BlocConsumer submitButtonRow(BuildContext context,
    {required VoidCallback onPressed, required String title}) {
  return BlocConsumer<LoginBloc, LoginState>(
    listener: (context, state) {
      if (state is LoginError) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(state.error)));
      }
    },
    builder: (context, state) {
      if (state is LoginInitial) {
        return floatingActionButton(context,
            onPressed: onPressed, widget: Text(title));
      } else if (state is LoginLoading) {
        return floatingActionButton(context,
            onPressed: () {},
            widget: CircularProgressIndicator.adaptive(
                valueColor: AlwaysStoppedAnimation<Color>(
                    ColorResources().loginScreenCircularIndicator)));
      } else {
        return floatingActionButton(context,
            onPressed: onPressed, widget: Text(title));
      }
    },
  );
}

SizedBox floatingActionButton(context,
        {required VoidCallback onPressed, required Widget widget}) =>
    SizedBox(
        width: MediaQuery.of(context).size.width,
        child: MaterialButton(
            onPressed: onPressed,
            color: const Color.fromARGB(255, 0, 101, 255),
            textColor: Colors.white,
            child: widget));
