import 'dart:convert';
import 'package:money_app/data/model/transaction.dart';

class GetIncomeResponse {
  final String status;
  final String message;
  final Transaction data;

  GetIncomeResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  GetIncomeResponse copyWith({
    String? status,
    String? message,
    Transaction? data,
  }) {
    return GetIncomeResponse(
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

  factory GetIncomeResponse.fromMap(Map<String, dynamic> map) {
    return GetIncomeResponse(
      status: map['status'] as String,
      message: map['message'] as String,
      data: Transaction.fromMap(map['data'] as Map<String, dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory GetIncomeResponse.fromJson(String source) =>
      GetIncomeResponse.fromMap(
        json.decode(source) as Map<String, dynamic>,
      );
}
