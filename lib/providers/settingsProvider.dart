import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider with ChangeNotifier {
  SharedPreferences prefs;
  bool _isLeft;
  bool get isLeft => _isLeft;

  void init() async {
    prefs = await SharedPreferences.getInstance();
    _isLeft = prefs.getBool("isLeft");
  }
}
