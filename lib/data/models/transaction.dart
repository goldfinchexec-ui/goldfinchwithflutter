
enum TransactionType { INCOME, EXPENSE }

enum TransactionCategory {
  DRIVER_PAYOUT,
  CLIENT_INVOICE,
  GENERAL_EXPENSE,
  GENERAL_INCOME,
}

enum TransactionStatus { PAID, PENDING, RECEIVED, OUTSTANDING }

class TransactionModel {
  final String id;
  final TransactionType type;
  final TransactionCategory category;
  final String? relatedId; // DriverID or ClientID
  final TransactionStatus status;
  final List<String> fileUrls;
  final DateTime date; // For single date or start of range
  final DateTime? endDate; // For range
  final double amount;
  final String description; // Expense name or description

  TransactionModel({
    required this.id,
    required this.type,
    required this.category,
    this.relatedId,
    required this.status,
    required this.fileUrls,
    required this.date,
    this.endDate,
    required this.amount,
    required this.description,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'],
      type: TransactionType.values.firstWhere((e) => e.toString() == 'TransactionType.${json['type']}'),
      category: TransactionCategory.values.firstWhere((e) => e.toString() == 'TransactionCategory.${json['category']}'),
      relatedId: json['related_id'],
      status: TransactionStatus.values.firstWhere((e) => e.toString() == 'TransactionStatus.${json['status']}'),
      fileUrls: List<String>.from(json['files'] ?? []),
      date: DateTime.parse(json['date']),
      endDate: json['end_date'] != null ? DateTime.parse(json['end_date']) : null,
      amount: (json['amount'] as num).toDouble(),
      description: json['description'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.toString().split('.').last,
      'category': category.toString().split('.').last,
      'related_id': relatedId,
      'status': status.toString().split('.').last,
      'files': fileUrls,
      'date': date.toIso8601String(),
      'end_date': endDate?.toIso8601String(),
      'amount': amount,
      'description': description,
    };
  }
}
