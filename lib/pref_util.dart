import 'package:shared_preferences/shared_preferences.dart';

class PrefUtil {

  static Future<bool> isFirstLaunch() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    bool value = prefs.getBool('first_launch') ?? true;

    if (value) {
      await prefs.setBool('first_launch', false);
    }

    return value;
  }
}