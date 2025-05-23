// Metotlarda try-catch'i sadece viewmodel'lerde kullanıyoruz. 
// Firebase servisleri ve repository'de kullanmıyoruz. 
// Her katmanda ayrı hata yakalamaya gerek yok. Efektif de değil.

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sosyal_ag/core/db_base.dart';
import 'package:sosyal_ag/init.dart';
import 'package:sosyal_ag/services/firebase/firebase_auth_service.dart';
import 'package:sosyal_ag/services/firebase/firebase_storage_service.dart';
import 'package:sosyal_ag/utils/locator.dart';

class FirestoreService implements DataBaseCore {

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Init _init = locator<Init>();
  final FirebaseAuthService _authService = locator<FirebaseAuthService>();
  final FirebaseStorageService _storageService = locator<FirebaseStorageService>();

  bool isFirstPost = false;
  



  // USER METHODS
  Future<void> createNewUser(Map<String, dynamic> userJsonData) async {
    userJsonData.update("createdAt", (value) => FieldValue.serverTimestamp());
    CollectionReference usersRef = _firestore.collection('users');
    await usersRef.doc(userJsonData['uid']).set(userJsonData); 
  }
  

  Future<Map<String, dynamic>?> getCurrentUserAllData(String userID) async {
    CollectionReference usersRef = _firestore.collection('users');
    DocumentSnapshot doc = await usersRef.doc(userID).get();

    

    return doc.data() as Map<String, dynamic>;
  }

  Future<List<String>> getUserFirstFivePostsIdList(String userId) async {
    DocumentSnapshot userDoc = await _firestore.collection('users').doc(userId).get();
    
    if (!userDoc.exists || !(userDoc.data() as Map<String, dynamic>).containsKey('posts')) {
      return [];
    }

    List<dynamic> allPosts = (userDoc.data() as Map<String, dynamic>)['posts'];
    return allPosts.take(5).map((postId) => postId.toString()).toList();
  }
  

  // POST METHODS
  Future<void> createNewPost(Map<String, dynamic> postJsonData, {File? imageFile}) async {
    if(imageFile != null){
      await _storageService.uploadPostMedia(imageFile, "pinhani");
    }

    postJsonData.update("createdAt", (value) => FieldValue.serverTimestamp());
   
    CollectionReference postRef = _firestore.collection("posts");
    DocumentReference docRef = postRef.doc(); // Rastgele ID oluşturur
    
    // Post ID'sini postJsonData'ya ekle
    postJsonData['id'] = docRef.id;

    await docRef.set(postJsonData);

    // Post ID'sini kullanıcının posts array'ine ekle
    String userId = postJsonData['authorId'];
    await _firestore.collection('users').doc(userId).update({
      'posts': FieldValue.arrayUnion([docRef.id])
    }); 
  }




  Future<List<Map<String, dynamic>>> currentUserGetLastFivePosts() async {

    // Önce kullanıcının son 5 post ID'sini al
    List<String> postIds = await getUserFirstFivePostsIdList(_init.user!.uid!);
    
    if (postIds.isEmpty) return [];

    // Post ID'lerine göre posts koleksiyonundan dokümanları çek
    CollectionReference postRef = _firestore.collection("posts");
    List<Map<String, dynamic>> posts = [];
    
    for (String postId in postIds) {
      DocumentSnapshot postDoc = await postRef.doc(postId).get();
      if (postDoc.exists) {
        posts.add(postDoc.data() as Map<String, dynamic>);
      }
    }

    // Postları tarihe göre sırala (en yeniden en eskiye)
    posts.sort((a, b) {
      Timestamp timeA = a['createdAt'] as Timestamp;
      Timestamp timeB = b['createdAt'] as Timestamp;
      return timeB.compareTo(timeA);
    });

    return posts;
  }

  Future<List<Map<String, dynamic>>> getMoreUserPosts(String lastPostId, int limit) async {
    
    
   User? user= await _authService.currentUser();

    // Kullanıcı dokümanını al
    DocumentSnapshot userDoc = await _firestore.collection('users').doc(user?.uid).get();
    
    if (!userDoc.exists || !(userDoc.data() as Map<String, dynamic>).containsKey('posts') || isFirstPost) {
      return [];
    }

    // Tüm post ID'lerini al
    List<dynamic> allPosts = (userDoc.data() as Map<String, dynamic>)['posts'];
    
    // Son yüklenen postun indeksini bul
    int lastIndex = allPosts.indexOf(lastPostId);
    if (lastIndex == -1) return [];
    
    // Sonraki postların ID'lerini al
    List<String> nextPostIds = allPosts
        .skip(lastIndex)
        .take(limit)
        .map((postId) => postId.toString())
        .toList();
    
    if (nextPostIds.isEmpty) return [];

    // Post detaylarını getir
    List<Map<String, dynamic>> posts = [];
    CollectionReference postRef = _firestore.collection("posts");
    
    for (String postId in nextPostIds) {
      DocumentSnapshot postDoc = await postRef.doc(postId).get();
      if (postDoc.exists) {
        posts.add(postDoc.data() as Map<String, dynamic>);
      }
    }

    // Postları tarihe göre sırala
    posts.sort((a, b) {

      Timestamp timeA = a['createdAt'] as Timestamp;
      Timestamp timeB = b['createdAt'] as Timestamp;
      return timeB.compareTo(timeA);

    });

    return posts;
  }


  Future<void> addCommentToPost(String postId, Map<String, dynamic> commentData) async {
    print("post id: $postId");
    DocumentReference postRef = _firestore.collection('posts').doc(postId);
    

     await postRef.update({
      'comments': FieldValue.arrayUnion([
        {
        'content' : commentData['content'],
        'userId' : commentData['user_id'],
        'postId' : commentData['post_id'],
        'userProfileImage' : commentData['user_profile_image'],
        'username' : commentData['username'],
        // Burada Firebase'in sistem saati ayarlanacak. 
        // FieldValue.serverTimeStamp() hata verdiği için şimdilik kalsın.
        'createdAt' : DateTime.now(),
        
      }]),
      'commentsCount': FieldValue.increment(1)
    });  
  }


  Future<List<Map<String, dynamic>>> getPostComments(String postId) async {
    DocumentSnapshot postDoc = await _firestore.collection('posts').doc(postId).get();
    
    if (postDoc.exists && postDoc.data() != null) {
      List<dynamic> comments = (postDoc.data() as Map<String, dynamic>)['comments'] ?? [];
      return comments.map((comment) => comment as Map<String, dynamic>).toList();
    }
    
    return [];
  }

  Future<void> deletePost(String postId) async {
    DocumentReference postRef = _firestore.collection('posts').doc(postId);
    await postRef.delete();
  }

  Future<void> deleteComment(String postId, String commentId) async {
    DocumentReference postRef = _firestore.collection('posts').doc(postId);
    await postRef.update({
      'comments': FieldValue.arrayRemove([commentId]),
      'commentsCount': FieldValue.increment(-1)
    });
  }

}