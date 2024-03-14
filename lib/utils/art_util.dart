import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Util {
  static const FIRSTPIC = "Caravaggio";
  static const SECONDPIC = "Monet";
  static const THIRDPIC = "Van Gogh";
  static const IMG_1STPIC = "https://bit.ly/fl_caravaggio";
  static const IMG_2NDPIC = "https://bit.ly/fl_monet";
  static const IMG_3RDPIC = "https://bit.ly/fl_vangogh";

  static const List<String> menuItems = [FIRSTPIC, SECONDPIC, THIRDPIC];
  static const List<String> paths = [IMG_1STPIC, IMG_2NDPIC, IMG_3RDPIC];

  static const Padding paddingTop = Padding(
    padding: EdgeInsets.only(top: 30),
  );

  static void saveSettings(int value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('unit', value);
  }

  static Future<int> getSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int result = prefs.getInt('unit') ?? 0;
    return result;
  }
}
