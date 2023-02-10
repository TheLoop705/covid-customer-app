import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

final primary = Color(0xff5a47d3);
final ascent = Color(0xfff9f9f9);
final cardColor =Color(0xff224869) ;
final iconColor = Color(0xff263238);
final buttonsColor = Color(0xFFEB1555);

ThemeData light = ThemeData(
    brightness: Brightness.light,
    primaryColor: primary,
    accentColor: Colors.white,
    scaffoldBackgroundColor: Color(0xfff1f1f1)
);

ThemeData dark = ThemeData(
  brightness: Brightness.dark,
  primaryColor: primary,
  accentColor: Colors.white,
);

class ThemeNotifier extends ChangeNotifier {
  final String key = "theme";
  SharedPreferences _prefs;
  bool _darkTheme;

  bool get darkTheme => _darkTheme;

  ThemeNotifier() {
    _darkTheme = false;
    _loadFromPrefs();
  }

  toggleTheme() {
    _darkTheme = !_darkTheme;
    _saveToPrefs();
    notifyListeners();
  }

  _initPrefs() async {
    if(_prefs == null)
      _prefs = await SharedPreferences.getInstance();
  }

  _loadFromPrefs() async {
    await _initPrefs();
    _darkTheme = _prefs.getBool(key) ?? false;
    notifyListeners();
  }

  _saveToPrefs()async {
    await _initPrefs();
    _prefs.setBool(key, _darkTheme);
  }

}