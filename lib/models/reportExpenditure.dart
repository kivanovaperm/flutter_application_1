import 'package:flutter_application_1/models/user.dart';
import 'package:flutter_application_1/models/category.dart';
import 'package:intl/intl.dart';

class ReportExpenditure {
  int? categoryId;
  String? categoryName;
  String? totalSum;

  ReportExpenditure();

  factory ReportExpenditure.fromJson(Map<String, dynamic> json) {
    ReportExpenditure reportExpenditure = ReportExpenditure();
    reportExpenditure.categoryId = json['category_id'];
    reportExpenditure.categoryName = (json['category_name']);
    reportExpenditure.totalSum = (json['total_sum']);
    return reportExpenditure;
  }
}
