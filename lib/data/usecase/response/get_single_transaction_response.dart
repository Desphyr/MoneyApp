import 'dart:convert';

import 'package:money_app/data/model/transaction.dart';

class GetSingleTransactionResponse {
  final String status;
  final String message;
  final Datum data;

  GetSingleTransactionResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory GetSingleTransactionResponse.fromJson(String str) =>
      GetSingleTransactionResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory GetSingleTransactionResponse.fromMap(Map<String, dynamic> json) =>
      GetSingleTransactionResponse(
        status: json["status"],
        message: json["message"],
        data: Datum.fromMap(json["data"]),
      );

  Map<String, dynamic> toMap() => {
        "status": status,
        "message": message,
        "data": data.toMap(),
      };
}

