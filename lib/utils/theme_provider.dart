// Burada dinamik tema değişikliği yapabilmek için bir provider oluşturuldu.
// Bu provider ile uygulama içerisindeki tüm widgetlar dinamik olarak temalarını değiştirebilir.
// Bu sayede uygulama içerisindeki tüm widgetlar aynı anda temalarını değiştirebilir.



import 'package:flutter/material.dart';

class ThemeProvider with ChangeNotifier {
// VARIABLES
  final ThemeData _themeDataLight = ThemeData(
    primaryColor: Colors.white60,
    primarySwatch: Colors.blue,
    brightness: Brightness.light,
  );

  final ThemeData _themeDataDark = ThemeData(
    primaryColor: Colors.black87,
    primarySwatch: Colors.blue,
    brightness: Brightness.dark,

  );

  ThemeMode _themeMode = ThemeMode.dark;

  // GETTERS
  ThemeData get themeDataLight => _themeDataLight;
  ThemeData get themeDataDark => _themeDataDark;
  ThemeMode get themeMode => _themeMode;

  // SETTERS
  void toggleTheme() {
    if (_themeMode == ThemeMode.light) {
      _themeMode = ThemeMode.dark;
    } else {
      _themeMode = ThemeMode.light;
    }
    notifyListeners();
  }

  





}