class TransactionModel {
  final String id;
  final String title;
  final DateTime dateTime;
  final double amount;
  final String type; // 'debit' or 'credit'
  final String status; // 'completed', 'pending', 'failed'

  const TransactionModel({
    required this.id,
    required this.title,
    required this.dateTime,
    required this.amount,
    required this.type,
    required this.status,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'] as String,
      title: json['title'] as String,
      dateTime: DateTime.parse(json['dateTime'] as String),
      amount: (json['amount'] as num).toDouble(),
      type: json['type'] as String,
      status: json['status'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'dateTime': dateTime.toIso8601String(),
      'amount': amount,
      'type': type,
      'status': status,
    };
  }
}
