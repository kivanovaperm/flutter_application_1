import 'package:flutter_application_1/models/user.dart';
import 'package:flutter_application_1/models/category.dart';
import 'package:intl/intl.dart';

class ReportRevenue {
  int? categoryId;
  String? categoryName;
  String? totalSum;

  ReportRevenue();

  factory ReportRevenue.fromJson(Map<String, dynamic> json) {
    ReportRevenue reportRevenue = ReportRevenue();
    reportRevenue.categoryId = json['category_id'];
    reportRevenue.categoryName = (json['category_name']);
    reportRevenue.totalSum = (json['total_sum']);
    return reportRevenue;
  }
}
