import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider with ChangeNotifier {
  SharedPreferences prefs;
  bool _isLeftHanded = false;
  bool _isDarkTheme = false;

  bool get isDarkTheme => _isDarkTheme;
  bool get isLeftHanded => _isLeftHanded;

  void isLefHanded(value) async {
    _isLeftHanded = value;
    prefs = await SharedPreferences.getInstance();
    prefs.setBool('isLeftHanded', value);
    prefs.commit();
    notifyListeners();
  }

  void isDarkThemed(value) async {
    _isDarkTheme = value;
    prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDarkThemed', value);
    prefs.commit();
    notifyListeners();
  }

  SettingsProvider() {
    _initSettings();
  }

  //initialise all user settings
  void _initSettings() async {
    prefs = await SharedPreferences.getInstance();
    _isLeftHanded = prefs.getBool("isLeftHanded") ?? false;
    _isDarkTheme = prefs.getBool('isDarkThemed') ?? false;
    notifyListeners();
  }
}
