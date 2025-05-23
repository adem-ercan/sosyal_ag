class PostCommentModel {
  final String content;
  final String userId;
  final String postId;
  final String? userProfileImage;
  final String? username;
  final DateTime? createdAt;

  PostCommentModel({
    required this.content,
    required this.userId,
    required this.postId,
    this.userProfileImage,
    this.username,
    
    this.createdAt,
  });

  factory PostCommentModel.fromJson(Map<String, dynamic> json) {
    return PostCommentModel(
      content: json['content'] as String,
      userId: json['user_id'] as String,
      postId: json['post_id'] as String,
      userProfileImage: json['user_profile_image'] as String?,
      username: json['username'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'content': content,
      'user_id': userId,
      'post_id': postId,
      'user_profile_image': userProfileImage,
      'username': username,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  PostCommentModel copyWith({
    String? content,
    String? userId,
    String? postId,
    String? userProfileImage,
    String? username,
    DateTime? createdAt,
  }) {
    return PostCommentModel(
      content: content ?? this.content,
      userId: userId ?? this.userId,
      postId: postId ?? this.postId,
      userProfileImage: userProfileImage ?? this.userProfileImage,
      username: username ?? this.username,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
