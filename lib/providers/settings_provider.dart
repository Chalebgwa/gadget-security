import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider with ChangeNotifier {
  SharedPreferences prefs;
  bool _isLeftHanded = false;
  bool get isLeftHanded => _isLeftHanded;

  void isLefHanded(value) {
    _isLeftHanded = value;
    notifyListeners();
  }

  SettingsProvider() {
    _initSettings();
  }

  //initialise all user settings
  void _initSettings() async {
    prefs = await SharedPreferences.getInstance();
    _isLeftHanded = prefs.getBool("isLeftHanded") ?? false;
    prefs.clear();
  }
}
