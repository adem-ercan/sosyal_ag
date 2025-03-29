import 'package:flutter/material.dart';
import 'package:sosyal_ag/model/user_model.dart';
import 'package:sosyal_ag/repositories/repository.dart';
import 'package:sosyal_ag/utils/locator.dart';
import 'package:sosyal_ag/view/widgets/error_handler_widget.dart';


class UserViewModel extends ChangeNotifier {


  final Repository _repository = locator<Repository>();

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
      return await _repository.signInWithEmailAndPassword(email, password);
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




