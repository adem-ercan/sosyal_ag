import 'package:firebase_auth/firebase_auth.dart';
import 'package:sosyal_ag/model/post_model.dart';
import 'package:sosyal_ag/model/user_model.dart';
import 'package:sosyal_ag/services/firebase/firebase_auth_service.dart';
import 'package:sosyal_ag/services/firebase/firebase_firestore_service.dart';
import 'package:sosyal_ag/utils/extensions/string_extensions.dart';
import 'package:sosyal_ag/utils/locator.dart';

class Repository {
  final FirebaseAuthService _firebaseAuthService =
      locator<FirebaseAuthService>();
  final FirestoreService _firestoreService = locator<FirestoreService>();
  List<PostModel> _postModelList = [];

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

    /* if (user != null) {
      // Burada uid null kontrolüde yapılacak
      Map<String, dynamic>? mapData = await _firestoreService
          .getCurrentUserAllData(user.uid);
      if (mapData != null) {
        pragma("Veriyi oku: $mapData");
        return UserModel.fromJson(mapData); 
      } else {
        print("data yok!");
      }
    } else {
      print("Oturum açılamadı");
    } */
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

  Future<void> createNewPost(PostModel postModel) async {
    await _firestoreService.createNewPost(postModel.toJson());
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
}
