import '../resources/resource.dart';
import '../controllers/get_status_bloc/get_status_bloc.dart';
import '../models/status_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../controllers/upload_status_bloc/upload_status_bloc.dart';
import '../widgets/common_widgets_of_chat_screen.dart';
import '../widgets/network_image.dart';

class StatusScreen extends StatefulWidget {
  const StatusScreen({Key? key}) : super(key: key);

  @override
  State<StatusScreen> createState() => _StatusScreenState();
}

class _StatusScreenState extends State<StatusScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<UploadStatusBloc, UploadStatusState>(
      listener: (context, state) {
        if (state is UploadStatusSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("upload Successfully")));
        }
        if (state is UploadStatusError) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("error at the time of uploading status")));
        }
      },
      child: SingleChildScrollView(
        child: Column(children: [
          TextButton(
            onPressed: () {
              BlocProvider.of<UploadStatusBloc>(context).add(UploadStatus());
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                leading: CircleAvatar(
                    backgroundColor: ColorResources().uploadStatusButtonBg,
                    radius: 30,
                    child: Icon(IconResources().uploadStatusButton,
                        color: Colors.white)),
                title: Text(TextResources().uploadStatusButton,
                    style: const TextStyle(
                        fontWeight: FontWeight.w700, fontSize: 20)),
              ),
            ),
          ),
          BlocBuilder<GetStatusBloc, GetStatusState>(
            builder: (context, state) {
              if (state is GetStatusInitial) {
                return MediaQuery.removePadding(
                    removeTop: true, context: context, child: shimmerLoading());
              } else if (state is GetStatusLoaded) {
                return MediaQuery.removePadding(
                  removeTop: true,
                  context: context,
                  child: StreamBuilder<List<StatusModel>>(
                      stream: state.data,
                      builder: (context, snapshot) {
                        if (snapshot.data != null && snapshot.data != []) {
                          return ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: snapshot.data?.length,
                            itemBuilder: (context, index) => GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(
                                    context, RoutesName().statusViewScreen,
                                    arguments: snapshot.data?[index]);
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor: Colors.transparent,
                                    radius: 30,
                                    child: ClipOval(
                                      child: SizedBox.fromSize(
                                          size: const Size.fromRadius(40),
                                          child: networkImages(
                                              link: (snapshot.data?[index]
                                                      .image[0].url)
                                                  .toString())),
                                    ),
                                  ),
                                  title: Text(
                                      snapshot.data?[index].person ?? '',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 20)),
                                ),
                              ),
                            ),
                          );
                        } else {
                          return shimmerLoading();
                        }
                      }),
                );
              } else {
                return MediaQuery.removePadding(
                    removeTop: true, context: context, child: shimmerLoading());
              }
            },
          )
        ]),
      ),
    );
  }
}
