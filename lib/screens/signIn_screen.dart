import 'package:chat_app/controllers/login_Bloc/set_otp_field_bloc.dart';
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
      border:
          Border(bottom: BorderSide(color: Theme.of(context).primaryColor)));

  @override
  void dispose() {
    _phone.dispose();
    super.dispose();
  }

  Column textField() {
    return Column(
      children: [
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
        submitButtonRow(context, onPressed: () {
          final isValidForm = formKey.currentState?.validate();
          if (isValidForm != null) {
            if (isValidForm) {
              BlocProvider.of<LoginBloc>(context)
                  .add(GetOtp(phone: _phone.text.trim()));
            }
          }
        }, title: TextResources().sendOtpButton),
      ],
    );
  }

  otpVerify() {
    return Column(
      children: [
        BlocBuilder<SetOtpFieldBloc, SetOtpFieldState>(
          builder: (context, state) {
            return TextFieldPin(
                margin: 5,
                codeLength: 6,
                autoFocus: true,
                defaultBoxSize: 45.0,
                onChange: (code) {
                  BlocProvider.of<SetOtpFieldBloc>(context)
                      .add(ReSetOtpField());
                },
                textController: _otp,
                alignment: MainAxisAlignment.center,
                textStyle: const TextStyle(fontSize: 30),
                defaultDecoration: _pinPutDecoration.copyWith(
                    border: Border(
                        bottom: BorderSide(
                            color: ColorResources()
                                .otpVerifyFieldWhenUnSelected))),
                selectedDecoration: _pinPutDecoration);
          },
        ),
        const SizedBox(height: 20),
        submitButtonRow(context, onPressed: () {
          final isValidForm = formKey.currentState?.validate();
          if (isValidForm != null) {
            if (isValidForm) {
              BlocProvider.of<LoginBloc>(context)
                  .add(SignUp(otp: _otp.text.trim()));
            }
          }
        }, title: TextResources().otpVerifyButton),
      ],
    );
  }

  ListView listView() {
    return ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        children: [
          image(context, link: ImagePath().signUpImagePath),
          Center(child: loginTitle(context, title: TextResources().signInTile)),
          Text(TextResources().signInTextMessage, textAlign: TextAlign.center),
          const SizedBox(height: 20),
          BlocConsumer<LoginBloc, LoginState>(
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
                return textField();
              } else if (state is OtpSuccess || state is LoginLoading) {
                return otpVerify();
              } else if (state is LoginError) {
                return Text(TextResources().loginError);
              } else {
                return Text(TextResources().blocError);
              }
            },
          ),
        ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Form(
          key: formKey,
          child: Center(
            child: listView(),
          ),
        ),
      ),
    );
  }
}
