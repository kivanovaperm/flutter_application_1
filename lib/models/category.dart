import 'package:flutter/foundation.dart'; 

class RevenueCategory{
  int? id;
  String? name;
  String? categoryType;
  DateTime? createdAt;
  DateTime? updatedAt;

  RevenueCategory();

  factory RevenueCategory.fromJson(Map<String, dynamic> json) {
    RevenueCategory category = RevenueCategory();

    category.id = json['id'];
    category.name = json['name'];

    return category;
}
}
