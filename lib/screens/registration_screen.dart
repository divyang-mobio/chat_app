import 'package:email_validator/email_validator.dart';
import '../controllers/login_Bloc/login_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../widgets/login_screens_widget.dart';
import 'package:flutter/material.dart';
import '../resources/resource.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is LoginSuccess) {
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      image(context, link: 'assets/signup.png'),
                      loginTitle(context, title: TextResources().signUpTile),
                      const SizedBox(height: 20),
                      CustomTextField(
                          controller: _nameController,
                          hintName: TextResources().nameHintText,
                          isPassword: false,
                          iconData: IconResources().namePrefixInLogin,
                          textInputAction: TextInputAction.next,
                          validator: (value) {
                            if (value == '') {
                              return TextResources().nameEmptyValidation;
                            } else if (value != null && value.length < 3) {
                              return TextResources().nameInValidValidation;
                            }
                            return null;
                          }),
                      const SizedBox(height: 20),
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
                      const SizedBox(height: 20),
                      submitButtonRow(context, onPressed: () {
                        final isValidForm = formKey.currentState?.validate();
                        if (isValidForm != null) {
                          if (isValidForm) {
                            BlocProvider.of<LoginBloc>(context).add(SignUp(
                                name: _nameController.text.trim(),
                                email: _emailController.text.trim(),
                                password: _passwordController.text.trim()));
                          }
                        }
                      }, title: TextResources().signUpString),
                      const SizedBox(height: 10),
                      textButton(
                          onPressed: () => Navigator.pop(context),
                          title: TextResources().signInTextButton,
                          name: TextResources().signUpTextButtonPrefix),
                    ]),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
