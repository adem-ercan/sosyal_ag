import 'package:flutter/material.dart';
import 'package:sosyal_ag/model/post_model.dart';
import 'package:sosyal_ag/model/user_model.dart';
import 'package:sosyal_ag/repositories/repository.dart';
import 'package:sosyal_ag/utils/locator.dart';
import 'package:sosyal_ag/view/widgets/error_handler_widget.dart';


class MainScreenViewModel extends ChangeNotifier {

  final Repository _repository = locator<Repository>();
  
  
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

  Future<void> createNewPost(BuildContext context, String content) async{
    try {

      UserModel? userModel = await _repository.getCurrentUserAllData();
      if (userModel != null) {
        PostModel postModel = PostModel(
          authorId: userModel.uid ?? "", 
          content: content);
          print("$postModel");
        await _repository.createNewPost(postModel);
      }else{
        print("userModel is null!");
      }
    } catch (e) {
      if (context.mounted) {
        ErrorHandlerWidget.showError(context, e.toString());
      }
      
    }
    
    
  }
  
}