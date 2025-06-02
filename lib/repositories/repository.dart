import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:sosyal_ag/models/post_comments.dart';
import 'package:sosyal_ag/models/post_model.dart';
import 'package:sosyal_ag/models/user_model.dart';
import 'package:sosyal_ag/services/firebase/firebase_auth_service.dart';
import 'package:sosyal_ag/services/firebase/firebase_firestore_service.dart';
import 'package:sosyal_ag/utils/extensions/string_extensions.dart';
import 'package:sosyal_ag/utils/locator.dart';

class Repository {

  final FirebaseAuthService _firebaseAuthService =
      locator<FirebaseAuthService>();
  final FirestoreService _firestoreService = locator<FirestoreService>();
  /* final SupabaseStorageService _supabaseStorageService =
      locator<SupabaseStorageService>(); */
  final List<PostModel> _postModelList = [];
  String lastPostId = "";

  Future<void> createUserWithEmailAndPassword(
    String email,
    String password,
    String userName,
  ) async {
    UserCredential? credential = await _firebaseAuthService
        .createUserWithEmailAndPassword(email, password);
    User? user = credential?.user;

    if (user != null) {
      UserModel userModel = UserModel(
        userName: userName,
        email: email,
        uid: user.uid,
      );
      await _firestoreService.createNewUser(userModel.toJson());
    } else {
      print("Oturum açılamadı");
    }
  }

  Future<UserModel?> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    UserCredential? credential = await _firebaseAuthService
        .signInWithEmailAndPassword(email, password);
    User? user = credential?.user;
    if (user != null) {
      return await getCurrentUserAllData();
      // Burada kullanıcı giriş yaptıktan sonra init işlemi başlatılıyor.
      // Bu sayede uygulama açılırken kullanıcı bilgileri alınıyor.
      // Eğer init işlemi yapılmazsa uygulama açıldığında kullanıcı bilgileri alınamaz.
    } else {
      print("Oturum açılamadı");
    }
    return null;
  }

  // Burada iş bitmedi hala, düzeltilecek
  Future<UserModel?> signInWithGoogle(String email, String password) async {
    UserCredential? credential = await _firebaseAuthService
        .signInWithEmailAndPassword(email, password);
    User? user = credential?.user;

    if (user != null) {
      UserModel userModel = UserModel(
        userName: email.getEmailPrefix(),
        email: email,
      );
      //await _firestoreService.getCurrentUserAllData(userID)
    } else {
      print("Oturum açılamadı");
    }
    return null;
  }

  Future<void> signOut() async {
    await _firebaseAuthService.signOut();
  }

  Stream<bool> authStateChanges() {
    return _firebaseAuthService.authStateChanges();
  }

  Future<UserModel?> getCurrentUserAllData() async {
    User? user = await _firebaseAuthService.currentUser();
    if (user != null) {
      Map<String, dynamic>? mapData = await _firestoreService
          .getCurrentUserAllData(user.uid);

      if (mapData != null) {
        // Test edildi çalıştı. Burası düzenlenecek.
        UserModel userModel = UserModel.fromJson(mapData);
        return userModel;
        //return UserModel.fromJson(mapData);
      } else {
        return null;
      }
    } else {
      return null;
    }
  }

  Future<void> createNewPost(PostModel postModel, {File? imageFile}) async {
    /* if (imageFile != null) {
      
    } */

    await _firestoreService.createNewPost(
      postModel.toJson(),
      imageFile: imageFile,
    );
  }

  Future<List<PostModel?>> getLastFivePosts() async {
    List<Map<String, dynamic>?> mapList =
        await _firestoreService.currentUserGetLastFivePosts();

    if (mapList.isNotEmpty) {
      for (Map<String, dynamic>? v in mapList) {
        PostModel p = PostModel.fromJson(v!);
        _postModelList.add(p);
      }
    }
    return _postModelList;
  }

  Future<List<PostModel>> getMoreUserPosts(
    String userId,
    String lastPostId,
    int limit,
  ) async {
    List<Map<String, dynamic>?> mapList = await _firestoreService
        .getMoreUserPosts(lastPostId, limit);

    List<PostModel> newPosts = [];
    if (mapList.isNotEmpty) {
      for (Map<String, dynamic>? v in mapList) {
        if (v != null) {
          PostModel p = PostModel.fromJson(v);
          newPosts.add(p);
        }
      }
      _postModelList.addAll(newPosts);
    }
    return _postModelList;
  }

  Future<void> addCommentToPost(String postId, PostCommentModel commetModel) async {

    // Burada post'a yorum ekleniyor
    

    Map<String, dynamic> commentJson = commetModel.toJson();
    //commentJson.update("createdAt", (value) => DateTime.now());

    await _firestoreService.addCommentToPost(postId, commetModel.toJson());

   } 

   Future<void> removeCommentFromPost(
     Map<String, dynamic> commentData,
   ) async {
     await _firestoreService.deleteComment(commentData);
   }

   Future<void> deletePost(String postId, String userId) async {
     await _firestoreService.deletePost(postId, userId);
   }

   Future<void> likeComment(
     String postId,
     Map<String, dynamic> commentData,
     String userId,
     bool isLiked,
   ) async {
   
      await _firestoreService.likeComment(postId, commentData, userId, isLiked);
    
     
   }


  Future<void> likePost(String postID) async {
   await _firestoreService.likePost(postID);
  }


  Stream<List<String>> getLikedPostsStream(){
    return _firestoreService.getLikedPostsStream();
  }

  Stream<int> getPostLikesCountStream(String postId) {
    return _firestoreService.getPostLikesCountStream(postId);
  }

  Future<void> savePost(String postId) async {
      await _firestoreService.savePost(postId);
    
  }

  Stream<List<String>> getSavedPostsStream() {
    return _firestoreService.getSavedPostsStream();
  }

}
