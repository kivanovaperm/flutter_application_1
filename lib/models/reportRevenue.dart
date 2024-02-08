import 'package:flutter_application_1/models/user.dart';
import 'package:flutter_application_1/models/category.dart';
import 'package:intl/intl.dart';

class ReportRevenue {
  int? categoryId;
  String? categoryName;
  String? totalSum;
  String? difference;

  ReportRevenue();

  factory ReportRevenue.fromJson(Map<String, dynamic> json) {
    ReportRevenue reportRevenue = ReportRevenue();
    reportRevenue.categoryId = json['category_id'];
    reportRevenue.categoryName = (json['category_name']);
    reportRevenue.difference = (json['difference']);
    reportRevenue.totalSum = (json['total_sum']);
    return reportRevenue;
  }
}
