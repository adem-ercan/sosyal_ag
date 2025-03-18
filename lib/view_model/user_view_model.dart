import 'package:flutter/material.dart';
import 'package:sosyal_ag/model/user_model.dart';
import 'package:sosyal_ag/repositories/repository.dart';
import 'package:sosyal_ag/utils/locator.dart';


class UserViewModel extends ChangeNotifier {


  final Repository _repository = locator<Repository>();

  Future<void> createUserWithEmailAndPassword() async {
    try {
      await _repository.createUserWithEmailAndPassword("email", "password");
    } catch (e) {
      
    }
  }


  Future<UserModel?> signInWithEmailAndPassword(String email, String password) async {
    try {
      //Veri tabanı işlemleri repository içerisinde yapılacak.
      await _repository.signInWithEmailAndPassword(email, password);
    } catch (e) {
      print("ERROR on UserViewModel: $e");
    }
  }





}