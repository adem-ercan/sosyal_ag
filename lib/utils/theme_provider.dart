// Burada dinamik tema değişikliği yapabilmek için bir provider oluşturuldu.
// Bu provider ile uygulama içerisindeki tüm widgetlar dinamik olarak temalarını değiştirebilir.
// Bu sayede uygulama içerisindeki tüm widgetlar aynı anda temalarını değiştirebilir.


import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sosyal_ag/utils/constants.dart';

class ThemeProvider with ChangeNotifier {
// VARIABLES
  final ThemeData _themeDataLight = ThemeData(
    primaryColor: Colors.white,
    scaffoldBackgroundColor: Colors.white,
    brightness: Brightness.light,
    colorScheme: ColorScheme.light(
      primary: Constants.themeColor6,
      secondary: Colors.grey[100]!,
      surface: Colors.grey[200]!,
      onPrimary: Colors.black87,
      onSecondary: Colors.black54,
      onSurface: Colors.black,
      tertiary: Colors.tealAccent[700]!,
      onError: Colors.redAccent,
      error: Colors.redAccent,
      brightness: Brightness.light,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.grey[100],
      elevation: 0,
      iconTheme: const IconThemeData(color: Colors.black87),
    ),
    cardTheme: CardTheme(
      color: Colors.grey[100],
      elevation: 4,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Constants.themeColor4,
        foregroundColor: Constants.themeColor1,
      ),
    ),
    textTheme:  TextTheme(
      titleLarge: GoogleFonts.aBeeZee(color: Constants.themeColor1, fontWeight: FontWeight.bold),
      bodyLarge: GoogleFonts.aBeeZee(color: Constants.themeColor2),
      bodyMedium: GoogleFonts.aBeeZee(color: Constants.themeColor2),
    ),
  );

  final ThemeData _themeDataDark = ThemeData(
    primaryColor: Constants.themeColor1,
    scaffoldBackgroundColor: Constants.themeColor1,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.dark(
      primary: Constants.themeColor1,
      secondary: Constants.themeColor2,
      surface: Constants.themeColor3,
      onPrimary: Constants.themeColor4,
      onSecondary: Constants.themeColor5,
      onSurface: Constants.themeColor6,
      onTertiary: Constants.themeColor7,
      tertiary: Colors.tealAccent,
      onError: Colors.pinkAccent,
      error: Colors.pinkAccent,
      brightness: Brightness.dark,
    ),
    
    appBarTheme: AppBarTheme(
      backgroundColor: Constants.themeColor2,
      elevation: 0,
    ),
    cardTheme: CardTheme(
      color: Constants.themeColor2,
      elevation: 4,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Constants.themeColor3,
        foregroundColor: Constants.themeColor6,
      ),
    ),
    textTheme: TextTheme(
      titleLarge: GoogleFonts.aBeeZee(color: Constants.themeColor6, fontWeight: FontWeight.bold),
      bodyLarge: GoogleFonts.aBeeZee(color: Constants.themeColor5),
      bodyMedium: GoogleFonts.aBeeZee(color: Constants.themeColor5),
    ),
    
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