import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sms_otp_auto_verify/sms_otp_auto_verify.dart';
import '../controllers/login_Bloc/login_bloc.dart';
import '../widgets/login_screens_widget.dart';
import 'package:flutter/material.dart';
import '../resources/resource.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _phone = TextEditingController();
  final TextEditingController _otp = TextEditingController();
  final formKey = GlobalKey<FormState>();
  FirebaseAuth auth = FirebaseAuth.instance;

  BoxDecoration get _pinPutDecoration => BoxDecoration(
      border: Border.all(color: Theme.of(context).primaryColor),
      borderRadius: BorderRadius.circular(15.0));

  @override
  void dispose() {
    _phone.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: SingleChildScrollView(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    image(context, link: ImagePath().signUpImagePath),
                    loginTitle(context, title: TextResources().signInTile),
                    const SizedBox(height: 50),
                    CustomTextField(
                        controller: _phone,
                        hintName: TextResources().phoneHintText,
                        iconData: IconResources().phonePrefixInLogin,
                        textInputAction: TextInputAction.done,
                        validator: (value) {
                          if (value == '') {
                            return TextResources().phoneEmptyValidation;
                          } else if (value != null && value.length != 10) {
                            return TextResources().phoneInValidValidation;
                          } else {
                            return null;
                          }
                        },
                        keyBoard: TextInputType.phone,
                        isLogin: true),
                    const SizedBox(height: 20),
                    TextFieldPin(
                        margin: 5,
                        codeLength: 6,
                        autoFocus: true,
                        defaultBoxSize: 45.0,
                        onChange: (code) => setState(() {}),
                        textController: _otp,
                        alignment: MainAxisAlignment.center,
                        textStyle: const TextStyle(fontSize: 30),
                        defaultDecoration: _pinPutDecoration.copyWith(
                            border: Border.all(color: Colors.black)),
                        selectedDecoration: _pinPutDecoration),
                    const SizedBox(height: 40),
                    submitButtonRow(context, onPressed: () {
                      final isValidForm = formKey.currentState?.validate();
                      if (isValidForm != null) {
                        if (isValidForm) {
                          BlocProvider.of<LoginBloc>(context)
                              .add(SignUp(otp: _otp.text.trim()));
                        }
                      }
                    }, title: TextResources().signInString),
                  ]),
            ),
          ),
        ),
      ),
    );
  }
}
