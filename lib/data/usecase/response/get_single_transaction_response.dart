import 'dart:convert';
import 'package:money_app/data/model/transaction.dart';

class GetTransactionsResponse {
  final String status;
  final String message;
  final Transaction data;

  GetTransactionsResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  GetTransactionsResponse copyWith({
    String? status,
    String? message,
    Transaction? data,
  }) {
    return GetTransactionsResponse(
      status: status ?? this.status,
      message: message ?? this.message,
      data: data ?? this.data,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'status': status,
      'message': message,
      'data': data.toMap(),
    };
  }

  factory GetTransactionsResponse.fromMap(Map<String, dynamic> map) {
    return GetTransactionsResponse(
      status: map['status'] as String,
      message: map['message'] as String,
      data: Transaction.fromMap(map['data'] as Map<String, dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory GetTransactionsResponse.fromJson(String source) =>
      GetTransactionsResponse.fromMap(
        json.decode(source) as Map<String, dynamic>,
      );
}
