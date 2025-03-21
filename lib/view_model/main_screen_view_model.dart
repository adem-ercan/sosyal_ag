import 'package:flutter/material.dart';


class MainScreenViewModel extends ChangeNotifier {
  
  
  //VARIABLES
  bool _isVisibleAppBar = true;



  //GETTERS
  bool get isVisibleAppBar => _isVisibleAppBar;



  //SETTERS
  void set isVisibleAppBar(bool v){
    _isVisibleAppBar = v;
    notifyListeners();
  }


  //METHOD

}