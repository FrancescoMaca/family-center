

import 'package:cloud_firestore/cloud_firestore.dart';

enum NotificationType {
  unknown,
  joinRequest,
}

enum NotificationStatus {
  delivered,
  seen,
}

class Notification {
  final NotificationType type;
  final String title;
  final String message;

  Notification({
    required this.type,
    required this.title,
    required this.message,
  });

  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'title': title,
      'message': message,
    };
  }

  factory Notification.fromDoc(DocumentSnapshot snap) {
    final map = snap.data() as Map<String, dynamic>;

    return Notification(
      type: map['type'] ?? NotificationType.unknown,
      title: map['title'] ?? '',
      message: map['message'] ?? '',
    );
  }
}