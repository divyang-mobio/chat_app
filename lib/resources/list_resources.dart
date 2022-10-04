part of 'resource.dart';

class ListResources {
  List<PopupMenuItemModel> getPopUpData(context) {
    List<PopupMenuItemModel> data = [
      PopupMenuItemModel(
          title: 'Logout',
          iconData: Icons.logout,
          onPressed: () {
            BlocProvider.of<LoginBloc>(context).add(LogOut());
          })
    ];

    return data;
  }
}
