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
  final FirebaseStorageService _storageService =
      locator<FirebaseStorageService>();

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
    DocumentSnapshot userDoc =
        await _firestore.collection('users').doc(userId).get();

    if (!userDoc.exists ||
        !(userDoc.data() as Map<String, dynamic>).containsKey('posts')) {
      return [];
    }

    List<dynamic> allPosts = (userDoc.data() as Map<String, dynamic>)['posts'];
    return allPosts.take(5).map((postId) => postId.toString()).toList();
  }

  // POST METHODS
  Future<void> createNewPost(
    Map<String, dynamic> postJsonData, {
    File? imageFile,
  }) async {
    if (imageFile != null) {
      String? url = await _storageService.uploadPostMedia(
        imageFile,
        "${postJsonData['authorId']}-${postJsonData['id']}-${DateTime.now()}",
      );
      postJsonData['mediaUrls'] = [url];
      postJsonData['hasMedia'] = true;
    } else {}

    postJsonData.update("createdAt", (value) => FieldValue.serverTimestamp());
    String content = postJsonData['content'];
    List<String> splitList = content.split(' ');
    postJsonData.update("searchKey", (value) => splitList);

    print("searchKey : ${postJsonData['searchKey']}");

    CollectionReference postRef = _firestore.collection("posts");
    DocumentReference docRef = postRef.doc(); // Rastgele ID oluşturur

    // Post ID'sini postJsonData'ya ekle
    postJsonData['id'] = docRef.id;

    await docRef.set(postJsonData);

    // Muhtemelen PostModel'de sıkıntı var ki veritabanına boş yorum ekliyor.
    // Bu sebeple eklediği yorumu direkt siliyoruz.
    // Sonra bu düzeltilecek!!!
    await _firestore.collection('posts').doc(docRef.id).update({
      'comments': FieldValue.arrayRemove([{}]),
    });

    String userId = postJsonData['authorId'];
    await _firestore.collection('users').doc(userId).update({
      'posts': FieldValue.arrayUnion([postJsonData['id']]),
      'postsCount': FieldValue.increment(1),
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

  Future<void> addCommentToPost(
    String postId,
    Map<String, dynamic> commentData,
  ) async {
    print("post id: $postId");
    DocumentReference postRef = _firestore.collection('posts').doc(postId);

    await postRef.update({
      'comments': FieldValue.arrayUnion([
        {
          'content': commentData['content'],
          'userId': commentData['user_id'],
          'postId': commentData['post_id'],
          'userProfileImage': commentData['user_profile_image'],
          'username': commentData['username'],
          // Burada Firebase'in sistem saati ayarlanacak.
          // FieldValue.serverTimeStamp() hata verdiği için şimdilik kalsın.
          'createdAt': DateTime.now(),
          'likedUserIds': commentData['liked_user_ids'] ?? [],
        },
      ]),
      'commentsCount': FieldValue.increment(1),
    });
  }

  Future<List<Map<String, dynamic>>> getPostComments(String postId) async {
    DocumentSnapshot postDoc =
        await _firestore.collection('posts').doc(postId).get();

    if (postDoc.exists && postDoc.data() != null) {
      List<dynamic> comments =
          (postDoc.data() as Map<String, dynamic>)['comments'] ?? [];
      return comments
          .map((comment) => comment as Map<String, dynamic>)
          .toList();
    }

    return [];
  }

  Future<void> deletePost(
    String postId,
    String userId,
    String? mediaURL,
  ) async {
    DocumentReference postRef = _firestore.collection('posts').doc(postId);
    DocumentReference userRef = _firestore.collection('users').doc(userId);
    await userRef.update({
      'posts': FieldValue.arrayRemove([postId]),
    });

    await postRef.delete();
    if (mediaURL != null && mediaURL.isNotEmpty) {
      await _storageService.deletePostMedia(mediaURL);
    }
  }

  Future<void> deleteComment(Map<String, dynamic> commentData) async {
    DocumentReference postRef = _firestore
        .collection('posts')
        .doc(commentData['postId']);
    await postRef.update({
      'comments': FieldValue.arrayRemove([commentData]),
      'commentsCount': FieldValue.increment(-1),
    });
  }

  Future<void> likeComment(
    String postId,
    Map<String, dynamic> commentData,
    String userId,
    bool isLiked,
  ) async {
    DocumentReference postRef = _firestore.collection('posts').doc(postId);
    List<dynamic> likedUserIds = commentData['likedUserIds'] as List<dynamic>;

    /*  if(likedUserIds.contains(userId)) {
      print("liked içinde var");
      return;
    } */

    if (isLiked) {
      likedUserIds.remove(userId);
    } else {
      likedUserIds.add(userId);
    }

    await postRef.update({
      'comments': FieldValue.arrayUnion([
        {
          'content': commentData['content'],
          'userId': commentData['userId'],
          'postId': commentData['postId'],
          'userProfileImage': commentData['userProfileImage'],
          'username': commentData['username'],

          // Burada Firebase'in sistem saati ayarlanacak.
          // FieldValue.serverTimeStamp() hata verdiği için şimdilik kalsın.
          'createdAt': commentData['createdAt'],
          'likedUserIds': likedUserIds,
        },
      ]),
    });
  }
  /* 
  Future<void> unlikeComment(String postId, Map<String, dynamic> commentData, String userId) async {
    DocumentReference postRef = _firestore.collection('posts').doc(postId);
    List<dynamic> likedUserIds = commentData['likedUserIds'] as List<dynamic>;
    likedUserIds.remove(userId);
    print("unlikeComment çalıştı");
    await postRef.update({
      'comments': FieldValue.arrayRemove([
        {
        'content' : commentData['content'],
        'userId' : commentData['userId'],
        'postId' : commentData['postId'],
        'userProfileImage' : commentData['userProfileImage'],
        'username' : commentData['username'],
        // Burada Firebase'in sistem saati ayarlanacak. 
        // FieldValue.serverTimeStamp() hata verdiği için şimdilik kalsın.
        'createdAt' : commentData['createdAt'],
        'likedUserIds' : likedUserIds,
        
      }]),
    });
  } */

  Future<void> likePost(String postID) async {
    User? user = await _authService.currentUser();
    DocumentReference userRef = _firestore.collection("users").doc(user!.uid);
    DocumentReference postRef = _firestore.collection("posts").doc(postID);
    DocumentSnapshot userDoc = await userRef.get();

    final userData = userDoc.data() as Map<String, dynamic>;
    final likedPosts = List<String>.from(userData['likedPosts'] ?? []);

    if (likedPosts.contains(postID)) {
      // Post zaten beğenilmiş, beğeniyi kaldır
      await userRef.update({
        "likedPosts": FieldValue.arrayRemove([postID]),
      });

      await postRef.update({
        "likes": FieldValue.arrayRemove([user.uid]),
      });

      await postRef.update({"likesCount": FieldValue.increment(-1)});
    } else {
      // Post beğenilmemiş, beğeni ekle

      await userRef.update({
        "likedPosts": FieldValue.arrayUnion([postID]),
      });

      await postRef.update({
        "likes": FieldValue.arrayUnion([user.uid]),
      });

      await postRef.update({"likesCount": FieldValue.increment(1)});
    }
  }

  // Mevcut kullanıcı beğenilen postları dinleyen stream
  Stream<List<String>> getLikedPostsStream() {
    String userId = _init.user!.uid!;

    return _firestore.collection('users').doc(userId).snapshots().map((
      snapshot,
    ) {
      if (!snapshot.exists) return [];
      final userData = snapshot.data() as Map<String, dynamic>;
      return List<String>.from(userData['likedPosts'] ?? []);
    });
  }

  // Belirli bir postun beğeni sayısını dinleyen stream
  Stream<int> getPostLikesCountStream(String postId) {
    return _firestore.collection('posts').doc(postId).snapshots().map((
      snapshot,
    ) {
      if (!snapshot.exists) return 0;
      final postData = snapshot.data() as Map<String, dynamic>;
      return postData['likesCount'] as int? ?? 0;
    });
  }

  Future<void> savePost(String postId) async {
    User? user = await _authService.currentUser();
    DocumentReference userRef = _firestore.collection("users").doc(user!.uid);
    DocumentReference postRef = _firestore.collection("posts").doc(postId);

    DocumentSnapshot userDoc = await userRef.get();

    final userData = userDoc.data() as Map<String, dynamic>;
    final savedPosts = List<String>.from(userData['savedPosts'] ?? []);

    if (savedPosts.contains(postId)) {
      // Post zaten kaydedilmiş, kayıttan kaldır
      await userRef.update({
        "savedPosts": FieldValue.arrayRemove([postId]),
      });

      await postRef.update({
        "favoritedUsers": FieldValue.arrayRemove([user.uid]),
      });
    } else {
      // Post kaydedilmemiş, kaydet
      await userRef.update({
        "savedPosts": FieldValue.arrayUnion([postId]),
      });

      await postRef.update({
        "favoritedUsers": FieldValue.arrayUnion([user.uid]),
      });
    }
  }

  // Kaydedilen postları dinleyen stream
  Stream<List<String>> getSavedPostsStream() {
    String userId = _init.user!.uid!;
    return _firestore.collection('users').doc(userId).snapshots().map((
      snapshot,
    ) {
      if (!snapshot.exists) return [];
      final userData = snapshot.data() as Map<String, dynamic>;
      return List<String>.from(userData['savedPosts'] ?? []);
    });
  }

  Future<Map<String, dynamic>?> getPostById(String postId) async {
    DocumentSnapshot postDoc =
        await _firestore.collection('posts').doc(postId).get();
    if (postDoc.exists) {
      return postDoc.data() as Map<String, dynamic>;
    }
    return null;
  }

  Future<Map<String, dynamic>?> getUserDataById(String userId) async {
    try {
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(userId).get();

      if (userDoc.exists) {
        return userDoc.data() as Map<String, dynamic>;
      }
      return null;
    } catch (e) {
      print('Kullanıcı bilgileri getirme hatası: $e');
      return null;
    }
  }

  Stream<Map<String, dynamic>?> getUserByIdStream(String userId) {
    //String userId = _init.user!.uid!;
    return _firestore.collection('users').doc(userId).snapshots().map((
      snapshot,
    ) {
      if (!snapshot.exists) return {};
      final userData = snapshot.data() as Map<String, dynamic>;
      return userData;
    });
  }

  Future<List<Map<String, dynamic>>> searchUsers(String searchQuery) async {
    // Boş arama sorgusunu engelle
    if (searchQuery.trim().isEmpty) return [];

    // Büyük/küçük harf duyarlılığını kaldır
    searchQuery = searchQuery.toLowerCase();

    // Kullanıcı adı veya email ile eşleşenleri bul
    final usersSnapshot =
        await _firestore
            .collection('users')
            .orderBy('userName')
            .startAt([searchQuery])
            .endAt(['$searchQuery\uf8ff'])
            .get();

    List<Map<String, dynamic>> list =
        usersSnapshot.docs.map((doc) => doc.data()).toList();

    return list;
  }

  Stream<List<String>> getUsersFollowingStream(String uid) {
    return _firestore.collection('users').doc(uid).snapshots().map((snapshot) {
      if (!snapshot.exists) return [];
      final userData = snapshot.data() as Map<String, dynamic>;
      final allFollowing = List<String>.from(userData['following'] ?? []);
      return allFollowing.take(6).toList();
    });
  }

  /* Stream<List<String>> getUsersFollowersStream(String uid) {
    return _firestore.collection('users').doc(uid).snapshots();
  } */

  Future<void> updateUserTheme(String userId, bool isDarkMode) async {
    await _firestore.collection('users').doc(userId).update({
      'isDarkMode': isDarkMode,
    });
  }

  Stream<bool> getUserThemeStream(String userId) {
    return _firestore.collection('users').doc(userId).snapshots().map((
      snapshot,
    ) {
      if (!snapshot.exists) return false;
      final userData = snapshot.data() as Map<String, dynamic>;
      return userData['isDarkMode'] as bool? ?? false;
    });
  }

  Future<bool> getUserTheme(String userId) async {
    print("usereee: $userId");
    DocumentSnapshot snapshot =
        await _firestore.collection('users').doc(userId).get();

    if (!snapshot.exists) return false;
    final userData = snapshot.data() as Map<String, dynamic>;
    print("firestore'dan gelen tema: ${userData['isDarkMode']}");
    return userData['isDarkMode'] as bool? ?? false;
  }

  Future<List<Map<String, dynamic>>> searchPosts(String searchQuery) async {
    if (searchQuery.trim().isEmpty) return [];

    final postsSnapshot =
        await _firestore
            .collection('posts')
            .where('content', arrayContains: searchQuery)
            .limit(20)
            .get();

    return postsSnapshot.docs.map((doc) => doc.data()).toList();
  }

  Future<void> saveProfileEdit(
    String fullName,
    String userName,
    String bio, {
    File? imageFile,
  }) async {
    FieldValue time = FieldValue.serverTimestamp();
    String? url;

    String fileName = time.toString() + _init.user!.uid.toString();
    if (imageFile != null) {
      url = await _storageService.uploadPPMedia(imageFile, fileName);
    }
    _firestore.collection('users').doc(_init.user!.uid.toString()).update({
      'bio': bio,
      'name': fullName,
      'userName': userName,
      'photoUrl': url,
    });
  }

  // if user profile is private
  Future<void> followRequest(String targetUserId) async {
    await _firestore.collection('follow_requests').add({
      'senderId': _init.user!.uid,
      'receiverId': targetUserId,
      'status': 'pending',
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  Future<void> acceptFollowRequest(String senderId) async {
    await _firestore.collection('follow_requests').doc(senderId).delete();
  }

  // if not private
  Future<void> followUser(String targetUserId) async {
    await _firestore.collection('users').doc(_init.user!.uid).update({
      'following': FieldValue.arrayUnion([targetUserId]),
    });

    await _firestore
        .collection('users')
        .doc(_init.user?.uid)
        .collection('following')
        .doc(targetUserId)
        .set({
          'timestamp': FieldValue.serverTimestamp(),
          'followingId': targetUserId,
        });

    await _firestore.collection("users").doc(targetUserId).update({
      "followers": FieldValue.arrayUnion([_init.user?.uid]),
    });

    await _firestore
        .collection("users")
        .doc(targetUserId)
        .collection("followers")
        .doc(_init.user?.uid)
        .set({
          "timestamp": FieldValue.serverTimestamp(),
          "followerId": _init.user?.uid,
        });
  }

  Future<void> unFollowUser(String targetUserId) async {
    await _firestore.collection('users').doc(_init.user!.uid).update({
      'following': FieldValue.arrayRemove([targetUserId]),
    });

    await _firestore
        .collection('users')
        .doc(_init.user?.uid)
        .collection('following')
        .doc(targetUserId)
        .delete();

    await _firestore.collection("users").doc(targetUserId).update({
      "followers": FieldValue.arrayRemove([_init.user?.uid]),
    });

    await _firestore
        .collection("users")
        .doc(targetUserId)
        .collection("followers")
        .doc(_init.user?.uid)
        .delete();

    print("bütün işler tamamlandı");
  }

  Stream<List<Map<String, dynamic>>> listenMyPost() {
    return _firestore
        .collection('posts')
        .where(
          "authorId",
          isEqualTo: _init.user!.uid,
        ) // Bu kısım hatalıydı, doğru userId kullanılmalı
        .snapshots()
        .map((snapshot) {
          // Liste boşsa boş liste döndür
          if (snapshot.docs.isEmpty) return [];

          // Her dokümanı map olarak al
          final userData = snapshot.docs.map((doc) => doc.data()).toList();

          return userData;
        });
  }

  Future<String> getAboutText() async {

    DocumentSnapshot<Map<String, dynamic>> doc = await _firestore.collection("about").doc('about-project').get();
    Map<String, dynamic>? map = doc.data();
    if(map != null){
      return map["about"] as String;
    }else{
      return "null";
    }
  }

  Future<String> getPolicyText() async {

    DocumentSnapshot<Map<String, dynamic>> doc = await _firestore.collection("policy").doc('privacy-policy').get();
    Map<String, dynamic>? map = doc.data();
    if(map != null){
      return map["policy"] as String;
    }else{
      return "null";
    }
  }


Future<void> toggleIsMeydan() async {

      DocumentReference userRef = _firestore.collection('users').doc(_init.user?.uid);
      DocumentSnapshot userSnapshot = await userRef.get();

      if (userSnapshot.exists && userSnapshot.data() != null) {
        bool currentIsMeydan = (userSnapshot.data() as Map<String, dynamic>)['isMeydan'] ?? false;

        bool newIsMeydan = !currentIsMeydan;

        await userRef.update({'isMeydan': newIsMeydan});

      }
  }

  Future<void> toggleUserVerificationStatus(bool newStatus)async{
    await _firestore.collection('users')
        .doc(_init.user?.uid)
        .update({'isVerified': newStatus});
  }
  /*  Future<bool> rePost(Map<String, dynamic> postJsonData) async {
    DocumentSnapshot<Map<String, dynamic>> snap =
        await _firestore.collection('users').doc(_init.user!.uid).get();

    Map<String, dynamic>? userData = snap.data();

    postJsonData['rePostCreatedAt'] = postJsonData["createdAt"];
    postJsonData['createdAt'] = FieldValue.serverTimestamp();
    postJsonData['rePostUserId'] = _init.user?.uid;
    postJsonData['isRepost'] = true;
    List repostList = userData!['rePosts'] ?? [];


    if (userData['rePosts'] != null && repostList.isNotEmpty && repostList.contains(postJsonData['id'])) {

        
        await _firestore.collection("posts").doc(postJsonData['id']).delete();

        await _firestore.collection('users').doc(_init.user?.uid).update({
          'rePosts': FieldValue.arrayRemove([postJsonData['id']]),
        });
        print("gönderi geri alındı.");
        return false;
      
    }

    
    CollectionReference postRef = _firestore.collection("posts");
    DocumentReference docRef = postRef.doc(); // Rastgele ID oluşturur
    postJsonData['id'] = docRef.id;
    await docRef.set(postJsonData);

    await _firestore.collection('users').doc(_init.user?.uid).update({
      'rePosts': FieldValue.arrayUnion([postJsonData['id']]),
    });
    return true;
    /* 
    CollectionReference postRef = _firestore.collection("posts");
     DocumentReference docRef = postRef.doc(); // Rastgele ID oluşturur

    // Post ID'sini postJsonData'ya ekle
    postJsonData['id'] = docRef.id;

    print("repost edilen id: ${postJsonData['id']}");

    await docRef.set(postJsonData); 

    await _firestore.collection('users').doc(_init.user?.uid).update({
      'posts': FieldValue.arrayUnion([postJsonData['id']]),
      'postsCount': FieldValue.increment(1),
    }); */

    /* postJsonData.update("createdAt", (value) => FieldValue.serverTimestamp());
    String content = postJsonData['content'];
    List<String> splitList = content.split(' ');
    postJsonData.update("searchKey", (value) => splitList);

    print("searchKey : ${postJsonData['searchKey']}");

    CollectionReference postRef = _firestore.collection("posts");
    DocumentReference docRef = postRef.doc(); // Rastgele ID oluşturur


    // Post ID'sini postJsonData'ya ekle
    postJsonData['id'] = docRef.id;

    await docRef.set(postJsonData);

    // Muhtemelen PostModel'de sıkıntı var ki veritabanına boş yorum ekliyor.
    // Bu sebeple eklediği yorumu direkt siliyoruz.
    // Sonra bu düzeltilecek!!!
    await _firestore.collection('posts').doc(docRef.id).update({
      'comments': FieldValue.arrayRemove([{}]),
    });

    String userId = postJsonData['authorId'];
    await _firestore.collection('users').doc(userId).update({
      'posts': FieldValue.arrayUnion([postJsonData['id']]),
      'postsCount': FieldValue.increment(1),
    });
  } */
  } */
}
