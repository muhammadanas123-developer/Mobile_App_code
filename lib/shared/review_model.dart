class ReviewModel {
  final String id;
  final String reviewerName;
  final double rating;
  final String comment;
  final DateTime date;
  final String? replyContent;

  const ReviewModel({
    required this.id,
    required this.reviewerName,
    required this.rating,
    required this.comment,
    required this.date,
    this.replyContent,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json['id'] as String,
      reviewerName: json['reviewerName'] as String,
      rating: (json['rating'] as num).toDouble(),
      comment: json['comment'] as String,
      date: DateTime.parse(json['date'] as String),
      replyContent: json['replyContent'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'reviewerName': reviewerName,
      'rating': rating,
      'comment': comment,
      'date': date.toIso8601String(),
      'replyContent': replyContent,
    };
  }
}