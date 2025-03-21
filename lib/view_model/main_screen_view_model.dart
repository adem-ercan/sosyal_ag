import 'package:flutter/material.dart';


class MainScreenViewModel extends ChangeNotifier {
  
  
  //VARIABLES
  bool _isVisibleAppBar = true;



  //GETTERS
  bool get isVisibleAppBar => _isVisibleAppBar;



  //SETTERS
  set isVisibleAppBar(bool v){
    _isVisibleAppBar = v;
    notifyListeners();
  }


  //METHOD
  void isAppBarVisible(int index){
    if(index==0){
      isVisibleAppBar = true;
    }else{
      isVisibleAppBar = false;
    }
  }
}