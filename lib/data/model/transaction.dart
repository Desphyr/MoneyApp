import 'dart:convert';

class Transaction {
  int id;
  String categoryName;
  String categoryType;
  int amount;
  DateTime transactionDate;
  String? note;
  String? image;
  DateTime createdAt;
  DateTime updatedAt;

  Transaction({
    required this.id,
    required this.categoryName,
    required this.categoryType,
    required this.amount,
    required this.transactionDate,
    required this.note,
    required this.image,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Transaction.fromJson(String str) =>
      Transaction.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Transaction.fromMap(Map<String, dynamic> json) => Transaction(
    id: json["id"],
    categoryName: json["category_name"],
    categoryType: json["category_type"],
    amount: json["amount"],
    transactionDate: DateTime.parse(json["transaction_date"]),
    note: json["note"],
    image: json["image"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "category_name": categoryName,
    "category_type": categoryType,
    "amount": amount,
    "transaction_date":
        "${transactionDate.year.toString().padLeft(4, '0')}-${transactionDate.month.toString().padLeft(2, '0')}-${transactionDate.day.toString().padLeft(2, '0')}",
    "note": note,
    "image": image,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}
