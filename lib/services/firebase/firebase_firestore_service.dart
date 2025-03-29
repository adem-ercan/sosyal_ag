// Metotlarda try-catch'i sadece viewmodel'lerde kullanıyoruz. 
// Firebase servisleri ve repository'de kullanmıyoruz. 
// Her katmanda ayrı hata yakalamaya gerek yok. Efektif de değil.

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sosyal_ag/core/db_base.dart';
import 'package:sosyal_ag/init.dart';
import 'package:sosyal_ag/utils/locator.dart';

class FirestoreService implements DataBaseCore {

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Init _init = locator<Init>();
  



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
  Future<void> createNewPost(Map<String, dynamic> postJsonData) async {
   postJsonData.update("createdAt", (value) => FieldValue.serverTimestamp());
    CollectionReference postRef = _firestore.collection("posts");
    DocumentReference docRef = postRef.doc(); // Rastgele ID oluşturur
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

}