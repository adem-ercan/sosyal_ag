import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String? uid;
  final String userName;
  final String email;
  final String? name;
  final String? photoUrl;
  final String? bio;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<String>? followers;
  final List<String>? following;
  final int followersCount;
  final int followingCount;
  final int postsCount;
  final bool isVerified;
  final bool isPrivate;
  final bool isMeydan;
  final DateTime? lastActive;
  final String? fcmToken;
  final List<String>? likedPosts;
  final List<String>? favoritedPosts;
  final List<String>? blockedUsers;
  final List<String>? posts;
  final List<String>? rePosts;
  final bool isDarkMode;

  UserModel({
    this.uid,
    required this.userName,
    required this.email,
    this.name,
    this.photoUrl,
    this.bio,
    this.createdAt,
    this.updatedAt,
    this.followers,
    this.following = const [],
    this.followersCount = 0,
    this.followingCount = 0,
    this.postsCount = 0,
    this.isVerified = false,
    this.isPrivate = false,
    this.isMeydan = true,
    this.lastActive,
    this.fcmToken,
    this.likedPosts,
    this.favoritedPosts,
    this.blockedUsers,
    this.posts,
    this.rePosts,
    this.isDarkMode = true,
  });

  // JSON'dan UserModel'e dönüştürme
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'] as String?,
      userName: json['userName'] as String,
      name: json['name'] as String?,
      email: json['email'] as String,
      photoUrl: json['photoUrl'] as String?,
      bio: json['bio'] as String?,
      createdAt: json['createdAt'] != null 
          ? (json['createdAt'] as Timestamp).toDate()
          : null,
      updatedAt: json['updatedAt'] != null 
          ? (json['createdAt'] as Timestamp).toDate()
          : null,
      followers: (json['followers'] as List<dynamic>?)?.cast<String>(),
      following: (json['following'] as List<dynamic>?)?.cast<String>(),
      followersCount: json['followersCount'] as int? ?? 0,
      followingCount: json['followingCount'] as int? ?? 0,
      postsCount: json['postsCount'] as int? ?? 0,
      isVerified: json['isVerified'] as bool? ?? false,
      isPrivate: json['isPrivate'] as bool? ?? false,
      isMeydan: json['isMeydan'] as bool? ?? false,
      lastActive: json['lastActive'] != null 
          ? DateTime.parse(json['lastActive'] as String) 
          : null,
      fcmToken: json['fcmToken'] as String?,
      likedPosts: (json['likedPosts'] as List<dynamic>?)?.cast<String>(),
      favoritedPosts: (json['favoritedPosts'] as List<dynamic>?)?.cast<String>(),
      blockedUsers: (json['blockedUsers'] as List<dynamic>?)?.cast<String>(),
      posts: (json['posts'] as List<dynamic>?)?.cast<String>(),
      rePosts: (json['rePosts'] as List<dynamic>?)?.cast<String>(),
      isDarkMode: json['isDarkMode'] as bool? ?? true,
    );
  }

  // UserModel'i JSON'a dönüştürme
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'userName': userName,
      'name' : name,
      'email': email,
      'photoUrl': photoUrl,
      'bio': bio,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'followers': followers,
      'following': following,
      'followersCount': followersCount,
      'followingCount': followingCount,
      'postsCount': postsCount,
      'isVerified': isVerified,
      'isPrivate': isPrivate,
      'isMeydan': isMeydan,
      'lastActive': lastActive?.toIso8601String(),
      'fcmToken': fcmToken,
      'likedPosts': likedPosts,
      'favoritedPosts': favoritedPosts,
      'blockedUsers': blockedUsers,
      'posts': posts,
      'rePosts': rePosts,
      'isDarkMode': isDarkMode,
    };
  }

  // UserModel'i kopyalama ve güncelleme
  UserModel copyWith({
    String? uid,
    String? userName,
    String? name,
    String? email,
    String? photoUrl,
    String? bio,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<String>? followers,
    List<String>? following,
    int? followersCount,
    int? followingCount,
    int? postsCount,
    bool? isVerified,
    bool? isPrivate,
    bool? isMeydan,
    DateTime? lastActive,
    String? fcmToken,
    List<String>? likedPosts,
    List<String>? favoritedPosts,
    List<String>? blockedUsers,
    List<String>? posts,
    List<String>? rePosts,
    bool? isDarkMode,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      userName: userName ?? this.userName,
      email: email ?? this.email,
      photoUrl: photoUrl ?? this.photoUrl,
      bio: bio ?? this.bio,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      followers: followers ?? this.followers,
      following: following ?? this.following,
      followersCount: followersCount ?? this.followersCount,
      followingCount: followingCount ?? this.followingCount,
      postsCount: postsCount ?? this.postsCount,
      isVerified: isVerified ?? this.isVerified,
      isPrivate: isPrivate ?? this.isPrivate,
      isMeydan: isMeydan ?? this.isMeydan,
      lastActive: lastActive ?? this.lastActive,
      fcmToken: fcmToken ?? this.fcmToken,
      likedPosts: likedPosts ?? this.likedPosts,
      favoritedPosts: favoritedPosts ?? this.favoritedPosts,
      blockedUsers: blockedUsers ?? this.blockedUsers,
      posts: posts ?? this.posts,
      rePosts: rePosts ?? this.rePosts,
      isDarkMode: isDarkMode ?? this.isDarkMode,
    );
  }
}
