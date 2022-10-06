part of 'resource.dart';

class ListResources {
  List<PopupMenuItemModel> getPopUpData(context) {
    List<PopupMenuItemModel> data = [
      PopupMenuItemModel(
          title: TextResources().logout,
          iconData: IconResources().logout,
          onPressed: () => BlocProvider.of<LoginBloc>(context).add(LogOut()))
    ];

    return data;
  }
}
