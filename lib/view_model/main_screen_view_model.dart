import 'package:flutter/material.dart';


class MainScreenViewModel extends ChangeNotifier {
  
  
  //VARIABLES
  bool _isVisibleAppBar = true;
  bool _isVisibleFloatingButton = true;



  //GETTERS
  bool get isVisibleAppBar => _isVisibleAppBar;
  bool get isVisibleFloatingButton => _isVisibleFloatingButton;



  //SETTERS
  set isVisibleFloatingButton(bool v){
    _isVisibleFloatingButton = v;
    notifyListeners();
  }

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

    // UI'da değil burada çalıştıralım zaten aynı UI aynı zamanda çalışması gerekiyor
    isFloatingButtonVisible(index);
  }


  void isFloatingButtonVisible(int index){
    if(index == 0 || index == 3){
      isVisibleFloatingButton = true;
    }else{
      isVisibleFloatingButton = false;
    }
  }
}