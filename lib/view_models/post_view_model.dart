import 'package:flutter/material.dart';
import 'package:sosyal_ag/models/post_model.dart';
import 'package:sosyal_ag/repositories/repository.dart';
import 'package:sosyal_ag/utils/locator.dart';



class PostViewModel extends ChangeNotifier {
  //VARIABLES
  final Repository _repository = locator<Repository>();
  

  //GETTERS
  

  //SETTERS
 

  //METHODS
  void refresh() {
    notifyListeners();
  }

  Future<List<PostModel?>> getLastFivePosts() async {
    try {
      return await _repository.getLastFivePosts();
    } catch (e) {
      return [];
    }
  }

  Future<List<PostModel?>> getMoreUserPosts(
    
    String userId,
    String lastPostId,
    int limit,

  ) async {
    try {
      return await _repository.getMoreUserPosts(userId, lastPostId, limit);
    } catch (e) {
      return [];
    }
  }
}
