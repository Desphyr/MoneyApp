
import 'dart:convert';

class Category {
    final int id;
    final String name;
    final String type;

    Category({
        required this.id,
        required this.name,
        required this.type,
    });

    Category copyWith({
        int? id,
        String? name,
        String? type,
    }) => 
        Category(
            id: id ?? this.id,
            name: name ?? this.name,
            type: type ?? this.type,
        );

    factory Category.fromJson(String str) => Category.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Category.fromMap(Map<String, dynamic> json) => Category(
        id: json["id"],
        name: json["name"],
        type: json["type"],
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "type": type,
    };
}