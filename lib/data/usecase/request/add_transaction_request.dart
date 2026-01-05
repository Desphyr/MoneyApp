import 'dart:io';

class AddTransactionRequest {
  final int categoryId;
  final double amount;
  final String transactionDate;
  final String? note;
  final File? image;

  AddTransactionRequest({
    required this.categoryId,
    required this.amount,
    required this.transactionDate,
    this.note,
    this.image,
  });

  Map<String, String> toMap() {
    return <String, String>{
      'category_id': categoryId.toString(),
      'amount': amount.toString(),
      'transaction_date': transactionDate,
      'note': note!,
      'image': image != null ? image!.path : '',
    };
  }
}
