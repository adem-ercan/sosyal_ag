import 'package:flutter/material.dart';
import 'package:sosyal_ag/init.dart';
import 'package:sosyal_ag/models/user_model.dart';
import 'package:sosyal_ag/repositories/repository.dart';
import 'package:sosyal_ag/utils/locator.dart';
import 'package:sosyal_ag/views/components/error_handler_widget.dart';


class UserViewModel extends ChangeNotifier {


  final Repository _repository = locator<Repository>();
  final Init _init = locator<Init>();

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
         if (context.mounted) {
          // Burada kullanıcı giriş yaptıktan sonra init işlemi başlatılıyor.
          // Bu sayede uygulama açılırken kullanıcı bilgileri alınıyor.
          // Eğer init işlemi yapılmazsa uygulama açıldığında kullanıcı bilgileri alınamaz.
          await _init.start(context);        
          } 
       
        return user;
      }
    } catch (e) {
       if (context.mounted) {
        ErrorHandlerWidget.showError(context, "HATA: $e");
      }
      return null;
    }
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

  }




