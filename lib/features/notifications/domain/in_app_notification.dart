import 'package:uuid/uuid.dart';

/// In-app notification item stored locally (JSON in SharedPreferences).
class InAppNotification {
  const InAppNotification({
    required this.id,
    required this.kind,
    required this.title,
    required this.body,
    required this.createdAt,
    this.read = false,
    this.routePayload,
  });

  final String id;
  final String kind;
  final String title;
  final String body;
  final DateTime createdAt;
  final bool read;
  /// Route hint: [kNotificationPayloadPractice], achievement gallery, etc.
  final String? routePayload;

  InAppNotification copyWith({
    String? id,
    String? kind,
    String? title,
    String? body,
    DateTime? createdAt,
    bool? read,
    String? routePayload,
  }) {
    return InAppNotification(
      id: id ?? this.id,
      kind: kind ?? this.kind,
      title: title ?? this.title,
      body: body ?? this.body,
      createdAt: createdAt ?? this.createdAt,
      read: read ?? this.read,
      routePayload: routePayload ?? this.routePayload,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'kind': kind,
        'title': title,
        'body': body,
        'createdAt': createdAt.toIso8601String(),
        'read': read,
        'routePayload': routePayload,
      };

  factory InAppNotification.fromJson(Map<String, dynamic> json) {
    return InAppNotification(
      id: json['id'] as String,
      kind: json['kind'] as String? ?? 'system',
      title: json['title'] as String? ?? '',
      body: json['body'] as String? ?? '',
      createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ??
          DateTime.now(),
      read: json['read'] as bool? ?? false,
      routePayload: json['routePayload'] as String?,
    );
  }

  static String newId() => const Uuid().v4();
}
