import 'package:flutter/foundation.dart';
import 'package:gsec/providers/base_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider extends BaseProvider {
  
  bool _isLeftHanded = false;
  bool _isDarkTheme = false;

  bool get isDarkTheme => _isDarkTheme;
  bool get isLeftHanded => _isLeftHanded;

  void isLefHanded(value) async {
    _isLeftHanded = value;
    preferences = await SharedPreferences.getInstance();
    preferences.setBool('isLeftHanded', value);
    preferences.commit();
    notifyListeners();
  }

  void isDarkThemed(value) async {
    _isDarkTheme = value;
  
    preferences.setBool('isDarkThemed', value);
   
    notifyListeners();
  }

  SettingsProvider() {
    _initSettings();
  }

  //initialise all user settings
  void _initSettings() async {
    
    _isLeftHanded = preferences.getBool("isLeftHanded") ?? false;
    _isDarkTheme = preferences.getBool('isDarkThemed') ?? false;
    notifyListeners();
  }
  
  @override
  void initializePreferences() {
    SharedPreferences.getInstance().then((prefs) {
      preferences = prefs;
    });
  }
}
