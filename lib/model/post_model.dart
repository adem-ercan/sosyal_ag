class PostModel {
  final String? id;
  final String authorId;
  final String content;
  final List<String>? mediaUrls;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<String>? likes;
  final List<String>? comments;
  final List<String>? tags;
  final int likesCount;
  final int commentsCount;
  final int repostsCount;
  final bool isEdited;
  final bool isPinned;
  final String? parentPostId; // Yanıt olarak yazıldığı post
  final String? repostedFromId; // Repost yapıldığı post
  final String? quotedPostId; // Alıntı yapıldığı post

  PostModel({
    this.id,
    required this.authorId,
    required this.content,
    this.mediaUrls,
    this.createdAt,
    this.updatedAt,
    this.likes,
    this.comments,
    this.tags,
    this.likesCount = 0,
    this.commentsCount = 0,
    this.repostsCount = 0,
    this.isEdited = false,
    this.isPinned = false,
    this.parentPostId,
    this.repostedFromId,
    this.quotedPostId,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id'] as String?,
      authorId: json['authorId'] as String,
      content: json['content'] as String,
      mediaUrls: (json['mediaUrls'] as List<dynamic>?)?.cast<String>(),
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt'] as String) 
          : null,
      updatedAt: json['updatedAt'] != null 
          ? DateTime.parse(json['updatedAt'] as String) 
          : null,
      likes: (json['likes'] as List<dynamic>?)?.cast<String>(),
      comments: (json['comments'] as List<dynamic>?)?.cast<String>(),
      tags: (json['tags'] as List<dynamic>?)?.cast<String>(),
      likesCount: json['likesCount'] as int? ?? 0,
      commentsCount: json['commentsCount'] as int? ?? 0,
      repostsCount: json['repostsCount'] as int? ?? 0,
      isEdited: json['isEdited'] as bool? ?? false,
      isPinned: json['isPinned'] as bool? ?? false,
      parentPostId: json['parentPostId'] as String?,
      repostedFromId: json['repostedFromId'] as String?,
      quotedPostId: json['quotedPostId'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'authorId': authorId,
      'content': content,
      'mediaUrls': mediaUrls,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'likes': likes,
      'comments': comments,
      'tags': tags,
      'likesCount': likesCount,
      'commentsCount': commentsCount,
      'repostsCount': repostsCount,
      'isEdited': isEdited,
      'isPinned': isPinned,
      'parentPostId': parentPostId,
      'repostedFromId': repostedFromId,
      'quotedPostId': quotedPostId,
    };
  }

  PostModel copyWith({
    String? id,
    String? authorId,
    String? content,
    List<String>? mediaUrls,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<String>? likes,
    List<String>? comments,
    List<String>? tags,
    int? likesCount,
    int? commentsCount,
    int? repostsCount,
    bool? isEdited,
    bool? isPinned,
    String? parentPostId,
    String? repostedFromId,
    String? quotedPostId,
  }) {
    return PostModel(
      id: id ?? this.id,
      authorId: authorId ?? this.authorId,
      content: content ?? this.content,
      mediaUrls: mediaUrls ?? this.mediaUrls,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      likes: likes ?? this.likes,
      comments: comments ?? this.comments,
      tags: tags ?? this.tags,
      likesCount: likesCount ?? this.likesCount,
      commentsCount: commentsCount ?? this.commentsCount,
      repostsCount: repostsCount ?? this.repostsCount,
      isEdited: isEdited ?? this.isEdited,
      isPinned: isPinned ?? this.isPinned,
      parentPostId: parentPostId ?? this.parentPostId,
      repostedFromId: repostedFromId ?? this.repostedFromId,
      quotedPostId: quotedPostId ?? this.quotedPostId,
    );
  }
}
