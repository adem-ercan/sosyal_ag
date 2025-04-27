import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sosyal_ag/models/post_model.dart';
import 'package:sosyal_ag/models/user_model.dart';
import 'package:sosyal_ag/repositories/repository.dart';
import 'package:sosyal_ag/utils/locator.dart';
import 'package:sosyal_ag/views/components/error_handler_widget.dart';

enum Loading {
  loading,
  loaded,
}
class MainScreenViewModel extends ChangeNotifier {

  final Repository _repository = locator<Repository>();
  final ImagePicker _picker = ImagePicker();
  
  //VARIABLES
  bool _isVisibleAppBar = true;
  bool _isVisibleFloatingButton = true;
  Loading _loading = Loading.loaded;



  //GETTERS
  bool get isVisibleAppBar => _isVisibleAppBar;
  bool get isVisibleFloatingButton => _isVisibleFloatingButton;
  Loading get loading => _loading;


  //SETTERS
   set loading(Loading value) {
    _loading = value;
    notifyListeners();
  }

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
      loading = Loading.loading;
      UserModel? userModel = await _repository.getCurrentUserAllData();
      if (userModel != null) {
        PostModel postModel = PostModel(
          authorId: userModel.uid ?? "boş", 
          content: content);
        await _repository.createNewPost(postModel);
        loading = Loading.loaded;
      }else{
        print("userModel is null!");
        loading = Loading.loaded;
      }
    } catch (e) {
      if (context.mounted) {
        ErrorHandlerWidget.showError(context, e.toString());
      }
      
    }
    
    
  }


  Future mediaPick() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
  if (image != null) {
    print('Seçilen dosya yolu: ${image.path}');
  }
  }
  
}