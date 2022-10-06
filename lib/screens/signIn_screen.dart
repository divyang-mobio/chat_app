import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../controllers/login_Bloc/login_bloc.dart';
import '../resources/resource.dart';
import '../widgets/sign_up_sign_in_widget.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    Text(TextResources().signInTile,
                        style: Theme.of(context).textTheme.headline3?.copyWith(
                            color: ColorResources().loginScreenTitle)),
                    const SizedBox(height: 50),
                    CustomTextField(
                        controller: _emailController,
                        hintName: TextResources().emailHintText,
                        isPassword: false,
                        iconData: IconResources().emailPrefixInLogin,
                        textInputAction: TextInputAction.next,
                        validator: (value) {
                          if (value == '') {
                            return TextResources().emailEmptyValidation;
                          } else if (value != null &&
                              !EmailValidator.validate(value)) {
                            return TextResources().emailInValidValidation;
                          } else {
                            return null;
                          }
                        }),
                    const SizedBox(height: 20),
                    CustomTextField(
                        controller: _passwordController,
                        hintName: TextResources().passHintText,
                        isPassword: true,
                        iconData: IconResources().passPrefixInLogin,
                        textInputAction: TextInputAction.go,
                        validator: (value) {
                          if (value == '') {
                            return TextResources().passEmptyValidation;
                          } else if (value != null && value.length < 8) {
                            return TextResources().passInValidValidation;
                          } else {
                            return null;
                          }
                        }),
                    const SizedBox(height: 40),
                    commonSubmitButton(context, onPressed: () {
                      final isValidForm = formKey.currentState!.validate();
                      if (isValidForm) {
                        BlocProvider.of<LoginBloc>(context).add(SignIn(
                            email: _emailController.text,
                            password: _passwordController.text));
                      }
                    }, title: TextResources().signInString),
                    const SizedBox(height: 30),
                    textButton(
                        onPressed: () => Navigator.pushNamed(
                            context, RoutesName().registrationRoute),
                        title: TextResources().signUpTextButton),
                  ]),
            ),
          ),
        ),
      ),
    );
  }
}
