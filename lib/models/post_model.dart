import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  final String? id;
  final String authorId;
  final String? rePostUserId;
  final String content;
  final List<String>? mediaUrls;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? rePostCreatedAt;


  final List<String>? likes;
  final List<Map<String, dynamic>>? comments;
  final List<String>? tags;
  final List<String>? searchKey;
  final List<String>? rePostingUser;
  final int likesCount;
  final int commentsCount;
  final int repostsCount;
  final bool isEdited;
  final bool isPinned;
  final bool isFirstPost;
  final bool hasMedia;
  final bool isRepost;
  final String? parentPostId; // Yanıt olarak yazıldığı post
  final String? repostedFromId; // Repost yapıldığı post
  final String? quotedPostId; // Alıntı yapıldığı post

  PostModel({
    this.id,
    this.rePostUserId,
    required this.authorId,
    required this.content,
    this.mediaUrls,
    this.createdAt,
    this.updatedAt,
    this.rePostCreatedAt,
    this.searchKey,
    this.likes,
    this.rePostingUser,
    this.comments = const <Map<String, dynamic>>[{}],
    this.tags,
    this.likesCount = 0,
    this.commentsCount = 0,
    this.repostsCount = 0,
    this.isEdited = false,
    this.isPinned = false,
    this.isFirstPost = false,
    this.hasMedia = false,
    this.isRepost = false,
    this.parentPostId,
    this.repostedFromId,
    this.quotedPostId,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id'] as String?,
      rePostUserId: json['rePostUserId'] as String?,
      authorId: json['authorId'] as String,
      content: json['content'] as String,
      mediaUrls: (json['mediaUrls'] as List<dynamic>?)?.cast<String>(),
      createdAt:
          json['createdAt'] != null
              ? (json['createdAt'] as Timestamp).toDate()
              : null,
      rePostCreatedAt:
          json['rePostCreatedAt'] != null && (json['rePostCreatedAt'] is String)
              ? DateTime.tryParse(json['rePostCreatedAt'])
              : null,
      updatedAt:
          json['updatedAt'] != null
              ? (json['updatedAt'] as Timestamp).toDate()
              : null,
    
      likes: (json['likes'] as List<dynamic>?)?.cast<String>(),
      rePostingUser: (json['rePostingUser'] as List<dynamic>?)?.cast<String>(),
      searchKey: (json['searchKey'] as List<dynamic>?)?.cast<String>(),
      comments:
          (json['comments'] as List<dynamic>?)
              ?.map((e) => Map<String, dynamic>.from(e as Map))
              .toList(),
      tags: (json['tags'] as List<dynamic>?)?.cast<String>(),
      likesCount: json['likesCount'] as int? ?? 0,
      commentsCount: json['commentsCount'] as int? ?? 0,
      repostsCount: json['repostsCount'] as int? ?? 0,
      isEdited: json['isEdited'] as bool? ?? false,
      isPinned: json['isPinned'] as bool? ?? false,
      isFirstPost: json['isFirstPost'] as bool? ?? false,
      hasMedia: json['hasMedia'] as bool? ?? false,
      isRepost: json['isRepost'] as bool? ?? false,
      parentPostId: json['parentPostId'] as String?,
      repostedFromId: json['repostedFromId'] as String?,
      quotedPostId: json['quotedPostId'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'rePostUserId': rePostUserId,
      'authorId': authorId,
      'content': content,
      'mediaUrls': mediaUrls,
      'createdAt': createdAt?.toIso8601String(),
      'rePostCreatedAt': rePostCreatedAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'likes': likes,
      'rePostingUser': rePostingUser,
      'searchKey': searchKey,
      'comments': comments?.map((comment) => comment).toList(),
      'tags': tags,
      'likesCount': likesCount,
      'commentsCount': commentsCount,
      'repostsCount': repostsCount,
      'isEdited': isEdited,
      'isPinned': isPinned,
      'hasMedia': hasMedia,
      'isRepost': isRepost,
      'isFirstPost': isFirstPost,
      'parentPostId': parentPostId,
      'repostedFromId': repostedFromId,
      'quotedPostId': quotedPostId,
    };
  }

  PostModel copyWith({
    String? id,
    String? rePostUserId,
    String? authorId,
    String? content,
    List<String>? mediaUrls,
    DateTime? createdAt,
    DateTime? updatedAt,
    
    DateTime? rePostCreatedAt,
    List<String>? likes,
    List<String>? rePostingUser,
    List<String>? searchKey,
    List<Map<String, dynamic>>? comments,
    List<String>? tags,

    int? likesCount,
    int? commentsCount,
    int? repostsCount,
    bool? isEdited,
    bool? isPinned,
    bool? hasMedia,
    bool? isRepost,
    bool? isFirstPost,
    String? parentPostId,
    String? repostedFromId,
    String? quotedPostId,
  }) {
    return PostModel(
      id: id ?? this.id,
      rePostUserId: rePostUserId ?? this.rePostUserId,
      authorId: authorId ?? this.authorId,
      content: content ?? this.content,
      mediaUrls: mediaUrls ?? this.mediaUrls,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rePostCreatedAt: rePostCreatedAt ?? this.rePostCreatedAt,
      likes: likes ?? this.likes,
      rePostingUser: rePostingUser ?? this.rePostingUser,
      searchKey: searchKey ?? this.searchKey,
      comments: comments ?? this.comments,
      tags: tags ?? this.tags,
      likesCount: likesCount ?? this.likesCount,
      commentsCount: commentsCount ?? this.commentsCount,
      repostsCount: repostsCount ?? this.repostsCount,
      isEdited: isEdited ?? this.isEdited,
      isPinned: isPinned ?? this.isPinned,
      hasMedia: hasMedia ?? this.hasMedia,
      isRepost: isRepost ?? this.isRepost,
      isFirstPost: isFirstPost ?? this.isFirstPost,
      parentPostId: parentPostId ?? this.parentPostId,
      repostedFromId: repostedFromId ?? this.repostedFromId,
      quotedPostId: quotedPostId ?? this.quotedPostId,
    );
  }
}
