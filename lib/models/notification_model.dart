import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationModel {
  final String type; // like, comment, follow gibi
  final String userId; // bildirimi alan kullanıcı
  final String fromUserId; // bildirimi gönderen kullanıcı
  final DateTime? createdAt;
  final bool isSeen;

  NotificationModel({
    required this.type,
    required this.userId,
    required this.fromUserId,
    this.createdAt,
    this.isSeen = false,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      type: json['type'] as String,
      userId: json['userId'] as String,
      fromUserId: json['fromUserId'] as String,
      createdAt: json['createdAt'] != null 
          ? (json['createdAt'] as Timestamp).toDate() 
          : null,
      isSeen: json['isSeen'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'userId': userId,
      'fromUserId': fromUserId,
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : null,
      'isSeen': isSeen,
    };
  }

  NotificationModel copyWith({
    String? type,
    String? userId,
    String? fromUserId,
    DateTime? createdAt,
    bool? isSeen,
  }) {
    return NotificationModel(
      type: type ?? this.type,
      userId: userId ?? this.userId,
      fromUserId: fromUserId ?? this.fromUserId,
      createdAt: createdAt ?? this.createdAt,
      isSeen: isSeen ?? this.isSeen,
    );
  }
}
