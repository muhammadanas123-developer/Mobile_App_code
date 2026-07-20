class NotificationModel {
  final String id;
  final String title;
  final String body;
  final DateTime dateTime;
  final String category; // 'appointment', 'ai_scan', 'billing', 'promo'
  final bool isRead;

  const NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.dateTime,
    required this.category,
    this.isRead = false,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] as String,
      title: json['title'] as String,
      body: json['body'] as String,
      dateTime: DateTime.parse(json['dateTime'] as String),
      category: json['category'] as String,
      isRead: json['isRead'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'dateTime': dateTime.toIso8601String(),
      'category': category,
      'isRead': isRead,
    };
  }

  NotificationModel copyWith({
    String? id,
    String? title,
    String? body,
    DateTime? dateTime,
    String? category,
    bool? isRead,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      dateTime: dateTime ?? this.dateTime,
      category: category ?? this.category,
      isRead: isRead ?? this.isRead,
    );
  }
}