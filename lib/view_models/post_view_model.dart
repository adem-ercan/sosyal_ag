import 'package:flutter/material.dart';
import 'package:sosyal_ag/init.dart';
import 'package:sosyal_ag/models/post_comments.dart';
import 'package:sosyal_ag/models/post_model.dart';
import 'package:sosyal_ag/models/user_model.dart';
import 'package:sosyal_ag/repositories/repository.dart';
import 'package:sosyal_ag/utils/locator.dart';
import 'package:sosyal_ag/views/main_screen/main_page/post_screen/comment_bottom_sheet.dart';

class PostViewModel extends ChangeNotifier {


  //VARIABLES
  final Repository _repository = locator<Repository>();
  final Init _init = locator<Init>();


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


  Future<void> addCommentToPost(String postId, String comment) async {

    //Burada user!.uid kısmında null kontrolü yapılacak!!!

    UserModel? user = _init.user;

    

    PostCommentModel commentModel = PostCommentModel(
      postId: postId,
      content: comment,
      userId: user!.uid ?? "",
      username: user.userName,
    );

    print(" commentModel: $commentModel");

    try {
      await _repository.addCommentToPost(postId, commentModel);
    } catch (e) {
      print("Error adding comment: $e ");
    }
  }


  Future<void> showCommentSheet(BuildContext context, String postId) async {
    try {
      await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.5,
      ),
      builder: (context) => CommentBottomSheet(
        postId: postId,
      ),
    );
    } catch (e) {
      print("Error showing comment sheet: $e");
    }
  }
}
