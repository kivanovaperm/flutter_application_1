import 'package:flutter_application_1/models/user.dart';
import 'package:flutter_application_1/models/category.dart';
import 'package:intl/intl.dart';

class Revenue {
  int? id;
  double? sum;
  RevenueCategory? category;
  String? revenueDate;
  int? user;
  String? createdAt;
  String? updatedAt;

  Revenue();

  factory Revenue.fromJson(Map<String, dynamic> json) {
    Revenue revenue = Revenue();
    revenue.id = json['id'];
    revenue.category = RevenueCategory.fromJson(json['category']);
    revenue.sum = double.parse(json['sum']);
    revenue.user = json['user'];

    DateTime parsedDate = DateTime.parse(json['created_at']);
    String formattedDate = DateFormat('dd.MM.yyyy').format(parsedDate);

    DateTime parsedDateupdate = DateTime.parse(json['updated_at']);
    String formattedDateupdate = DateFormat('dd.MM.yyyy').format(parsedDate);

    revenue.createdAt = formattedDate;
    revenue.updatedAt = formattedDateupdate;
    revenue.revenueDate = (json['revenue_date']);

    return revenue;
  }
}
