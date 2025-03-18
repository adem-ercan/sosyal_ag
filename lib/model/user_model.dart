
class UserModel {
  final String? uid;
  final String name;
  final String email;
  final String? photoUrl;
  final String? bio;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<String>? followers;
  final List<String>? following;


  UserModel({
    this.uid,
    required this.name,
    required this.email,
    this.photoUrl,
    this.bio,
    this.createdAt,
    this.updatedAt,
    this.followers,
    this.following,
  });


  // JSON'dan UserModel'e dönüştürme
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'] as String?,
      name: json['name'] as String,
      email: json['email'] as String,
      photoUrl: json['photoUrl'] as String?,
      bio: json['bio'] as String?,
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt'] as String) 
          : null,
      updatedAt: json['updatedAt'] != null 
          ? DateTime.parse(json['updatedAt'] as String) 
          : null,
      followers: (json['followers'] as List<dynamic>?)?.cast<String>(),
      following: (json['following'] as List<dynamic>?)?.cast<String>(),
    );
  }


  // UserModel'i JSON'a dönüştürme
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'photoUrl': photoUrl,
      'bio': bio,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'followers': followers,
      'following': following,
    };
  }

  // UserModel'i kopyalama ve güncelleme
  UserModel copyWith({
    String? uid,
    String? name,
    String? email,
    String? photoUrl,
    String? bio,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<String>? followers,
    List<String>? following,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      email: email ?? this.email,
      photoUrl: photoUrl ?? this.photoUrl,
      bio: bio ?? this.bio,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      followers: followers ?? this.followers,
      following: following ?? this.following,
    );
  }
}
