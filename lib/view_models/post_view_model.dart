import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sosyal_ag/init.dart';
import 'package:sosyal_ag/models/post_comments.dart';
import 'package:sosyal_ag/models/post_model.dart';
import 'package:sosyal_ag/models/user_model.dart';
import 'package:sosyal_ag/repositories/repository.dart';
import 'package:sosyal_ag/utils/locator.dart';
import 'package:sosyal_ag/views/main_screen/main_page/post_screen/comment_area/comment_bottom_sheet.dart';

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


  Future<void> addCommentToPost(String postId, String comment, BuildContext context) async {

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
      if (context.mounted) {
        context.pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Theme.of(context).colorScheme.tertiary,
            content: Text("Yorumunuz eklendi!", style: GoogleFonts.aBeeZee(color: Theme.of(context).colorScheme.primary, fontSize: 20, fontWeight: FontWeight.bold)),
            duration: const Duration(seconds: 1),
          ),
        );
      }
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

  Future<void> removeCommentFromPost(Map<String, dynamic> commentData) async {
    try {
      await _repository.removeCommentFromPost(commentData);
    } catch (e) {
      print("Error removing comment: $e");
    }
  }

  Future<void> deletePost(String postId, String userId) async {
    try {
      await _repository.deletePost(postId, userId); 
    } catch (e) {
      print("Error deleting post: $e");
    }
  }

  Future<void> likeComment(String postId, Map<String, dynamic> commentData, String userId) async {
    try {
      await _repository.likeComment(postId, commentData, userId, true);
    } catch (e) {
      print("Error liking post: $e");
    }
  }



  // Bu kısım View Model'e taşınacak.
  String formatDate(DateTime? date) {
    if (date == null) return '';
    const aylar = [
      'Ocak', 'Şubat', 'Mart', 'Nisan', 'Mayıs', 'Haziran',
      'Temmuz', 'Ağustos', 'Eylül', 'Ekim', 'Kasım', 'Aralık'
    ];
    return "${date.day} ${aylar[date.month - 1]} ${date.year} - ${date.hour}:${date.minute.toString().padLeft(2, '0')}";
  }




  Future<void> likePost(String postID) async {
    try {
      await _repository.likePost(postID);
    } catch (e) {
      print("Error liking post: $e");
    }
  }


  Stream<List<String>> getLikedPostsStream() {
    return _repository.getLikedPostsStream();
  }

  Stream<int> getPostLikesCountStream(String postId) {
    return _repository.getPostLikesCountStream(postId);
  }


  Future<void> savePost(String postId) async {
    try {
      await _repository.savePost(postId);
    } catch (e) {
      print("Error saving post: $e");
    }
  }

  Stream<List<String>> getSavedPostsStream() {
    return _repository.getSavedPostsStream();
  }
}
