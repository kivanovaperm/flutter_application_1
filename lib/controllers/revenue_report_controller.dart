import 'package:flutter_application_1/api/api_connection.dart';
import 'package:flutter_application_1/api/revenue_api.dart';
import 'package:flutter_application_1/models/revenue.dart';
import 'package:flutter_application_1/services/secure_storage_manager.dart'; // Путь к вашему файлу login_api.dart
import 'package:flutter_application_1/models/category.dart';

import '../api/revenue_report_api.dart';
import '../models/reportRevenue.dart'; // Путь к вашему файлу login_api.dart

class RevenueReportController {
  final RevenueReportApi _revenueReportApi =
      RevenueReportApi(); // Инициализация вашего API для входа

  Future<List<ReportRevenue>> reportRevenues(
      String startDate, String endDate) async {
    List<ReportRevenue> reportRevenues = [];
    try {
      SecureStorageManager secureStorageManager = SecureStorageManager();
      final accessToken = await secureStorageManager.getAccessToken();
      final revenuesListJson =
          await _revenueReportApi.revenueList(accessToken, startDate, endDate);
      for (var element in revenuesListJson) {
        ReportRevenue reportRevenue = ReportRevenue.fromJson(element);
        reportRevenues.add(reportRevenue);
      }
      return reportRevenues;
    } catch (e) {
      return reportRevenues;
    }
  }
}
