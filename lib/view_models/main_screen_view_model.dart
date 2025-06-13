
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';





class MainScreenViewModel extends ChangeNotifier {

final PersistentTabController controller = PersistentTabController(
    initialIndex: 0,
  );  
  
  
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


  //METHODS
  void isAppBarVisible(int index){
    if(index==0 || index == 2){
      isVisibleAppBar = true;
    }else{
      isVisibleAppBar = false;
    }

    // UI'da değil burada çalıştıralım zaten aynı UI aynı zamanda çalışması gerekiyor
    isFloatingButtonVisible(index);
  }

  void isFloatingButtonVisible(int index){
    if(index == 0 || index == 4){
      isVisibleFloatingButton = true;
    }else{
      isVisibleFloatingButton = false;
    }
  }

  
  
}