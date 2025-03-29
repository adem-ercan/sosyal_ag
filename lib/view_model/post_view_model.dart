import 'package:flutter/material.dart';
import 'package:sosyal_ag/model/post_model.dart';
import 'package:sosyal_ag/repositories/repository.dart';
import 'package:sosyal_ag/utils/locator.dart';



class PostViewModel extends ChangeNotifier {

  final Repository _repository = locator<Repository>();

  void refresh(){
    notifyListeners();
  }

   Future<List<PostModel?>> getLastFivePosts() async {
    try {
      return await _repository.getLastFivePosts();
    } catch (e) {
      print("hata lan: $e");
      return [];
    }
   }
}