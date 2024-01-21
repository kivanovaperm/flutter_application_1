import 'package:flutter/foundation.dart';
import 'package:flutter_application_1/models/user.dart';
import 'package:flutter_application_1/models/category.dart';
import 'package:intl/intl.dart';

class Expenditure {
  int? id;
  double? sum;
  RevenueCategory? category;
  String? expenditureType;
  String? expenditureDate;
  User? user;
  String? comment;
  DateTime? createdAt;
  DateTime? updatedAt;

  Expenditure();

  factory Expenditure.fromJson(Map<String, dynamic> json) {
    Expenditure expenditure = Expenditure();
    expenditure.id = json['id'];
    expenditure.sum = double.parse(json['sum']);
    expenditure.category = RevenueCategory.fromJson(json['category']);
    expenditure.expenditureType = json['expenditure_type'];

    expenditure.comment = json['comment'];
    DateTime createdAt = DateTime.parse(json['created_at']);
    DateTime updatedAt = DateTime.parse(json['updated_at']);

    DateTime expenditureDate = DateTime.parse(json['expenditure_date']);
    String formattexpenditureDate =
        DateFormat('dd.MM.yyyy').format(expenditureDate);

    expenditure.expenditureDate = formattexpenditureDate;

    return expenditure;
  }
}
