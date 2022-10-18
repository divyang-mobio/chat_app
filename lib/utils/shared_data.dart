import 'package:shared_preferences/shared_preferences.dart';

class PreferenceServices {
  void setNo({required String number, required String uid}) async {
    final preference = await SharedPreferences.getInstance();
    await preference.setString("phone", number);
    await preference.setString("uid", uid);
  }

  void setName({required String name}) async {
    final preference = await SharedPreferences.getInstance();
    await preference.setString("name", name);
  }

  void setPic({required String profilePic}) async {
    final preference = await SharedPreferences.getInstance();
    await preference.setString("pic", profilePic);
  }

  Future<String> getUid() async {
    final preference = await SharedPreferences.getInstance();
    final uid = preference.getString("uid");
    return uid ?? '';
  }

  Future<String> getPhone(SharedPreferences preferences) async {
    final screen = preferences.getString("phone");
    return screen ?? '';
  }

  Future<String> getPic(SharedPreferences preferences) async {
    final urlList = preferences.getString("pic");
    return urlList ?? '';
  }

  Future<String> getAdmin() async {
    final preference = await SharedPreferences.getInstance();
    final value = preference.getString("name");
    return value ?? '';
  }

  Future<bool> reset() async {
    final preference = await SharedPreferences.getInstance();
    await preference.setString("phone", '');
    await preference.setString("uid", '');
    await preference.setString("pic", '');
    await preference.setString("name", '');
    return true;
  }
}
