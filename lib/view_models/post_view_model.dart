import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sosyal_ag/init.dart';
import 'package:sosyal_ag/models/post_comments.dart';
import 'package:sosyal_ag/models/post_model.dart';
import 'package:sosyal_ag/models/user_model.dart';
import 'package:sosyal_ag/repositories/repository.dart';
import 'package:sosyal_ag/utils/locator.dart';
import 'package:sosyal_ag/views/components/error_handler_widget.dart';
import 'package:sosyal_ag/views/post_screen/comment_area/comment_bottom_sheet.dart';

enum Loading { loading, loaded }

class PostViewModel extends ChangeNotifier {
  //VARIABLES
  final Repository _repository = locator<Repository>();
  final Init _init = locator<Init>();
  Loading _loading = Loading.loaded;
  final ImagePicker _picker = ImagePicker();
  File? _image;
  

  //GETTERS
  Loading get loading => _loading;
  File? get image => _image;

  //SETTERS
  set image(File? value) {
    _image = value;
    notifyListeners();
  }

  set loading(Loading value) {
    _loading = value;
    notifyListeners();
  }

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

  Future<void> createNewPost(BuildContext context, String content) async {
    try {
      loading = Loading.loading;
      UserModel? userModel = await _repository.getCurrentUserAllData();
      if (userModel != null) {
        PostModel postModel = PostModel(
          authorId: userModel.uid ?? "boş",
          content: content,
        );
        await _repository.createNewPost(postModel, imageFile: _image);
        loading = Loading.loaded;
      } else {
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
    try {
      final XFile? xFile = await _picker.pickImage(source: ImageSource.gallery);

      if (xFile != null) {
        image = File(xFile.path);
      }
    } catch (e) {
      print('Resim seçme hatası: $e');
    }
  }

  Future<void> addCommentToPost(
    String postId,
    String comment,
    BuildContext context,
  ) async {
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
            content: Text(
              "Yorumunuz eklendi!",
              style: GoogleFonts.aBeeZee(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
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
        builder: (context) => CommentBottomSheet(postId: postId),
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

  Future<void> deletePost(BuildContext context, String postId, String userId, String? mediaUrl) async {
    try {
      await _repository.deletePost(postId, userId, mediaUrl);
    } catch (e) {
      print("Error deleting post: $e");
      if (context.mounted) {
        ErrorHandlerWidget.showError(context, "Silme işlemi gerçekleştirilemedi!");
      }
      
    }
  }

  Future<void> likeComment(
    String postId,
    Map<String, dynamic> commentData,
    String userId,
  ) async {
    try {
      await _repository.likeComment(postId, commentData, userId, true);
    } catch (e) {
      print("Error liking post: $e");
    }
  }

  // Bu kısım View Model'e taşınacak.
  String formatDate1(DateTime? date) {
    if (date == null) return '';
    const aylar = [
      'Ocak',
      'Şubat',
      'Mart',
      'Nisan',
      'Mayıs',
      'Haziran',
      'Temmuz',
      'Ağustos',
      'Eylül',
      'Ekim',
      'Kasım',
      'Aralık',
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

  Future<PostModel?> getPostById(String postId) async {
    try {
      return await _repository.getPostById(postId);
    } catch (e) {
      print("Error fetching post by ID: $e");
      return null;
    }
  }
  Future<List<PostModel?>> searchPosts(String query) async {
    try {
      return await _repository.searchPosts(query);
    } catch (e) {
      print("ERROR on UserViewModel: $e");
      return [];
    }
  }
}
