import '../controllers/login_Bloc/login_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import '../resources/resource.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField(
      {Key? key,
      required this.controller,
      required this.hintName,
      required this.iconData,
      required this.validator,
      required this.keyBoard,
      required this.isLogin,
      required this.textInputAction})
      : super(key: key);

  final TextEditingController controller;
  final String hintName;
  final IconData iconData;
  final TextInputType keyBoard;
  final FormFieldValidator validator;
  final bool isLogin;
  final TextInputAction textInputAction;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: TextFormField(
        validator: widget.validator,
        cursorColor: ColorResources().textFieldSignInSignUpColor,
        textInputAction: widget.textInputAction,
        keyboardType: widget.keyBoard,
        controller: widget.controller,
        decoration: InputDecoration(
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                    color: ColorResources().textFieldSignInSignUpColor)),
            prefixIcon: Icon(widget.iconData,
                color: ColorResources().textFieldSignInSignUpIconColor),
            hintText: widget.hintName,
            suffixIcon: widget.isLogin
                ? IconButton(
                    onPressed: () {
                      final isValidForm = formKey.currentState?.validate();
                      if (isValidForm != null) {
                        if (isValidForm) {
                          BlocProvider.of<LoginBloc>(context).add(
                              GetOtp(phone: widget.controller.text.trim()));
                        }
                      }
                    },
                    icon: Icon(IconResources().sendOtp,
                        color: ColorResources().textFieldSignInSignUpIconColor))
                : null),
      ),
    );
  }
}

Center image(context, {required String link}) {
  return Center(
      child:
          Image.asset(link, height: MediaQuery.of(context).size.height * .4));
}

Text loginTitle(context, {required String title}) {
  return Text(title,
      style: Theme.of(context).textTheme.headline3?.copyWith(
          color: ColorResources().loginScreenTitle,
          fontWeight: FontWeight.bold));
}

Align textButton(
    {required VoidCallback onPressed,
    required String name,
    required String title}) {
  return Align(
    alignment: Alignment.bottomCenter,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(name),
        TextButton(
            onPressed: onPressed,
            child: Text(title,
                style: TextStyle(
                    color: ColorResources().loginScreenTextButton,
                    fontWeight: FontWeight.bold))),
      ],
    ),
  );
}

BlocConsumer submitButtonRow(BuildContext context,
    {required VoidCallback onPressed, required String title}) {
  return BlocConsumer<LoginBloc, LoginState>(
    listener: (context, state) {
      if (state is LoginSuccess) {
        Navigator.pushNamedAndRemoveUntil(
            context, RoutesName().registrationRoute, (route) => false);
      }
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
        {required VoidCallback onPressed, required Widget widget, Color? color}) =>
    SizedBox(
        width: MediaQuery.of(context).size.width,
        child: MaterialButton(
            onPressed: onPressed,
            color: color ?? ColorResources().loginScreenSubmitButton,
            textColor: ColorResources().loginScreenSubmitButtonText,
            child: widget));
