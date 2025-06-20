// Burada dinamik tema değişikliği yapabilmek için bir provider oluşturuldu.
// Bu provider ile uygulama içerisindeki tüm widgetlar dinamik olarak temalarını değiştirebilir.
// Bu sayede uygulama içerisindeki tüm widgetlar aynı anda temalarını değiştirebilir.


import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sosyal_ag/init.dart';
import 'package:sosyal_ag/repositories/repository.dart';
import 'package:sosyal_ag/utils/constants.dart';
import 'package:sosyal_ag/utils/locator.dart';

class ThemeProvider with ChangeNotifier {

  final Repository _repository = locator<Repository>();
  final Init _init = locator<Init>();
  bool _isFirst = true;


// VARIABLES
  final ThemeData _themeDataLight = ThemeData(
    primaryColor: Constants.themeColor7, // En açık renk
    scaffoldBackgroundColor: Constants.themeColor7,
    brightness: Brightness.light,
    colorScheme: ColorScheme.light(
      primary: Constants.themeColor7,
      secondary: Constants.themeColor6,
      surface: Constants.themeColor5,
      onPrimary: Constants.themeColor1,
      onSecondary: Constants.themeColor2,
      onSurface: Constants.themeColor1,
      onTertiary: Constants.themeColor1,
      tertiary: Colors.tealAccent[700]!,
      onError: Colors.redAccent,
      error: Colors.redAccent,
      brightness: Brightness.light,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Constants.themeColor6,
      elevation: 0,
      iconTheme: IconThemeData(color: Constants.themeColor1),
    ),
    cardTheme: CardTheme(
      color: Constants.themeColor6,
      elevation: 4,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Constants.themeColor5,
        foregroundColor: Constants.themeColor7,
      ),
    ),
    textTheme: TextTheme(
      titleLarge: GoogleFonts.aBeeZee(
        color: Constants.themeColor1, 
        fontWeight: FontWeight.bold
      ),
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
  bool get isFirst => _isFirst;

  // SETTERS
   set themeMode(ThemeMode mode) {
    _themeMode = mode;
  }

  set isFirst(bool value) {
    _isFirst = value;
    notifyListeners();
  }


  //METHODS
  Future<void> toggleTheme() async{
    if (_themeMode == ThemeMode.light) {
      await setUserTheme(_init.user!.uid!, true);
      _themeMode = ThemeMode.dark;

    } else {
      await setUserTheme(_init.user!.uid!, false);
      _themeMode = ThemeMode.light;
    }
    notifyListeners();
  }

  Future<void> setUserTheme(String userId, bool isDarkMode) async {
    await _repository.updateUserTheme(userId, isDarkMode);
    notifyListeners();
  }


  Future<bool> getUserTheme(String userId) async {
      return await _repository.getUserTheme(userId);

  }


  Stream<bool> getUserThemeStream(String userId) {
    return _repository.getUserThemeStream(userId);
  }




}