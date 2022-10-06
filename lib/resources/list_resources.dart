part of 'resource.dart';

class ListResources {
  List<PopupMenuItemModel> getPopUpData(BuildContext context) {
    List<PopupMenuItemModel> popupMenuList = [
      PopupMenuItemModel(
          title: TextResources().logout,
          iconData: IconResources().logout,
          onPressed: () => BlocProvider.of<LoginBloc>(context).add(LogOut()))
    ];
    return popupMenuList;
  }
}
