import 'package:flutter/material.dart';


class UserViewModel extends ChangeNotifier {
  String _userName = '';
  String _userEmail = '';
  String _userPhotoUrl = '';

  String get userName => _userName;
  String get userEmail => _userEmail;
  String get userPhotoUrl => _userPhotoUrl;

  void setUserName(String userName) {
    _userName = userName;
    notifyListeners();
  }

  void setUserEmail(String userEmail) {
    _userEmail = userEmail;
    notifyListeners();
  }

  void setUserPhotoUrl(String userPhotoUrl) {
    _userPhotoUrl = userPhotoUrl;
    notifyListeners();
  }
}