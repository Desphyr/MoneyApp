import 'dart:io';

class AddTransactionRequest {
  final int categoryId;
  final int amount;
  final DateTime transactionDate;
  final String note;
  final File? image;

  AddTransactionRequest({
    required this.categoryId,
    required this.amount,
    required this.transactionDate,
    required this.note,
    this.image,
  });

  Map<String, dynamic> toMap() {
    return {
      'category_id': categoryId,
      'amount': amount,
      'transaction_date': "${transactionDate.year.toString().padLeft(4, '0')}-${transactionDate.month.toString().padLeft(2, '0')}-${transactionDate.day.toString().padLeft(2, '0')}",
      'note': note,
    };
  }
}

