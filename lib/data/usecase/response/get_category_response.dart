import 'dart:convert';
import 'package:money_app/data/model/category.dart';

class GetCategoryResponse {
    final String status;
    final String message;
    final List<Category> data;

    GetCategoryResponse({
        required this.status,
        required this.message,
        required this.data,
    });

    factory GetCategoryResponse.fromJson(String str) => GetCategoryResponse.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory GetCategoryResponse.fromMap(Map<String, dynamic> json) => GetCategoryResponse(
        status: json["status"],
        message: json["message"],
        data: List<Category>.from(json["data"].map((x) => Category.fromMap(x))),
    );

    Map<String, dynamic> toMap() => {
        "status": status,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toMap())),
    };
}