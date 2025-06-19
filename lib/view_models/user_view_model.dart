
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sosyal_ag/init.dart';
import 'package:sosyal_ag/models/user_model.dart';
import 'package:sosyal_ag/repositories/repository.dart';
import 'package:sosyal_ag/utils/locator.dart';
import 'package:sosyal_ag/views/components/error_handler_widget.dart';


class UserViewModel extends ChangeNotifier {


  final Repository _repository = locator<Repository>();
  final Init _init = locator<Init>();

  




  //METHODS
  Future<void> createUserWithEmailAndPassword(String email, String password, String userName, BuildContext context) async {
    try {
      await _repository.createUserWithEmailAndPassword(email, password, userName);
    } catch (e) {
      print("ERROR on UserViewModel: $e");
     
      
    }
  }


  Future<UserModel?> signInWithEmailAndPassword(String email, String password, BuildContext context) async {
    try {
      //Veri tabanı işlemleri repository içerisinde yapılacak.

      UserModel? user = await _repository.signInWithEmailAndPassword(email, password);

      if (user != null){

       
        return user;

      }
       if (context.mounted) {
          // Burada kullanıcı giriş yaptıktan sonra init işlemi başlatılıyor.
          // Bu sayede uygulama açılırken kullanıcı bilgileri alınıyor.
          // Eğer init işlemi yapılmazsa uygulama açıldığında kullanıcı bilgileri alınamaz.
          context.push('/');
          //await _init.start(context);      
          } 
    } catch (e) {
       if (context.mounted) {
        ErrorHandlerWidget.showError(context, "HATA: $e");
      }
      return null;
    }
    return null;
  }
  

  Future<void> signOut() async {
    try {
      await _repository.signOut();
      
    } catch (e) {
      print("ERROR on UserViewModel: $e");
    }
  }


  Stream<bool> authStateChanges() {

    return _repository.authStateChanges();
  } 



  Future<UserModel?> getCurrentUserAllData(BuildContext context) async {
    try {
     return await _repository.getCurrentUserAllData();
    } catch (e) {
      print("bura mı?");
      ErrorHandlerWidget.showError(context, e.toString());
      return null;
    }
    
  }

  Future<UserModel?> getUserDataById(String userId) async {
    try {
      return await _repository.getUserDataById(userId);
    } catch (e) {
      print("ERROR on UserViewModel: $e");
      return null;
    }

  }

  Stream<List<String>?> getUserFollowingList(String userId) {
    try {
      return _repository.getUsersFollowingStream(userId);
    } catch (e) {
      print("ERROR on UserViewModel: $e");
      return Stream.value([]);
    }
  }


  Future<List<UserModel?>> searchUsers(String query) async {
    try {
      return await _repository.searchUsers(query);
    } catch (e) {
      print("ERROR on UserViewModel: $e");
      return [];
    }
  }

  Stream<Map<String, dynamic>?> getUserByIdStream(String userId){
    return _repository.getUserByIdStream(userId);
  }

  Future<void> followRequest(String targetUserId) async {
    try {
      await _repository.followRequest(targetUserId);
    } catch (e) {
      print("ERROR on UserViewModel.followRequest: $e");
    }
  }

  Future<void> followUser(String targetUserId) async{
    await _repository.followUser(targetUserId);
  }

  Future<void> unFollowUser(String targetUserId) async {
    try {
      await _repository.unFollowUser(targetUserId);
    } catch (e) {
      print("ERROR on UserViewModel.followRequest: $e");
    }
  }


  Future<void> toggleIsMeydan()async {
    try {
      await _repository.toggleIsMeydan();
    } catch (e) {
      print("ERROR on UserViewModel.toggleIsMeydan: $e");
    }
    
  }

  

}


