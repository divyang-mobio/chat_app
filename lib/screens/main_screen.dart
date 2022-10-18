import '../controllers/user_bloc/new_contact_bloc.dart';
import '../models/message_model.dart';
import '../models/user_model.dart';
import '../utils/firestore_service.dart';
import '../utils/shared_data.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import '../resources/resource.dart';
import '../widgets/listview.dart';
import '../widgets/pop_up_menu.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with WidgetsBindingObserver {
  String uid = '';

  void callUserData() async {
    uid = await PreferenceServices().getUid();
    setState(() {});
    // BlocProvider.of<NewContactBloc>(context).add(GetNewContactData(uid: uid));
  }

  Shimmer shimmerLoading() {
    return Shimmer.fromColors(
        baseColor: ColorResources().shimmerBase,
        highlightColor: ColorResources().shimmerHighlight,
        child: listView(userData: [], isLoading: true));
  }

  @override
  void initState() {
    callUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      floatHeaderSlivers: true,
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) => [
        SliverAppBar(
          expandedHeight: 100,
          flexibleSpace: FlexibleSpaceBar(
            titlePadding: const EdgeInsets.only(left: 10.0, bottom: 15),
            title: Text(AppTitle().mainScreen,
                style: TextStyle(color: ColorResources().appBarIconTextColor)),
          ),
          actions: [
            IconButton(onPressed: () {}, icon: Icon(IconResources().search)),
            popupMenuButton()
          ],
          floating: false,
          pinned: true,
        )
      ],
      body:
          // Text("In progress")
          (uid != '')
              ? StreamBuilder<List<List<PersonsModel>>>(
                  stream: DatabaseService().getUserChatList(yourId: uid),
                  builder: (context, snapshot) {
                    if (snapshot.data != null) {
                      print(snapshot.data?.map((e) => e.map((e) => PersonsModel(id: e.id))));
                      return const Text("data");
                      // return listView(
                      //     userData: snapshot.data as List<UserModel>,
                      //     isLoading: false);
                    } else {
                      return shimmerLoading();
                    }
                    // if (snapshot.data != null) {
                    //   Text('hello');
                    // } else {
                    //   return CircularProgressIndicator();
                    // }
                  })
              : Text('data'),
    );
    // body: BlocBuilder<NewContactBloc, NewContactState>(
    //   builder: (context, state) {
    //     if (state is NewContactInitial) {
    //       return shimmerLoading();
    //     } else if (state is NewContactLoaded) {
    //       return MediaQuery.removePadding(
    //         removeTop: true,
    //         context: context,
    //         child: StreamBuilder<List<UserModel>>(
    //             stream: state.newContactData,
    //             builder: (context, snapshot) {
    //               if (snapshot.data != null) {
    //                 return listView(
    //                     userData: snapshot.data as List<UserModel>,
    //                     isLoading: false);
    //               } else {
    //                 return shimmerLoading();
    //               }
    //             }),
    //       );
    //     } else if (state is NewContactError) {
    //       return Center(child: Text(TextResources().error));
    //     } else {
    //       return Center(child: Text(TextResources().blocError));
    //     }
    //   },
    // ),
    // );
  }
}
