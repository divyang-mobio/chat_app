import '../controllers/user_bloc/new_contact_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import '../resources/resource.dart';
import '../widgets/common_widgets_of_chat_screen.dart';

class SelectContactScreen extends StatefulWidget {
  const SelectContactScreen({Key? key}) : super(key: key);

  @override
  State<SelectContactScreen> createState() => _SelectContactScreenState();
}

class _SelectContactScreenState extends State<SelectContactScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NewContactBloc, NewContactState>(
      builder: (context, state) {
        if (state is NewContactInitial) {
          return shimmerLoading();
        } else if (state is NewContactLoaded) {
          return userModelStream(context,
              data: state.newContactData, isChatScreen: false);
        } else if (state is NewContactError) {
          return Center(child: Text(TextResources().error));
        } else {
          return Center(child: Text(TextResources().blocError));
        }
      },
    );
  }
}
