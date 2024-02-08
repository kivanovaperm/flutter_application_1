

import 'package:financial_management/api/api_connection.dart';
import 'package:financial_management/api/revenue_api.dart';
import 'package:financial_management/models/revenue.dart';
import 'package:financial_management/services/secure_storage_manager.dart'; // Путь к вашему файлу login_api.dart
import 'package:financial_management/models/category.dart';

import '../api/expenditure_report_api.dart';
import '../api/revenue_report_api.dart';
import '../models/reportExpenditure.dart';
import '../models/reportRevenue.dart'; // Путь к вашему файлу login_api.dart

class ExpenditureReportController {
  final ExpenditureReportApi _expenditureReportApi =
      ExpenditureReportApi(); // Инициализация вашего API для входа

  Future<List<ReportExpenditure>> reportExpenditures(String startDate, String endDate) async {
    List<ReportExpenditure> reportExpenditures = [];
    try {
      SecureStorageManager secureStorageManager = SecureStorageManager();
      final accessToken = await secureStorageManager.getAccessToken();
      final expendituresListJson = await _expenditureReportApi.expenditureList(accessToken, startDate, endDate);
      for (var element in expendituresListJson) {
        ReportExpenditure reportExpenditure = ReportExpenditure.fromJson(element);
        reportExpenditures.add(reportExpenditure);
      }
      print("sfkjdhsdhgdf${reportExpenditures}");
      //  List<Revenue> revenues = revenuesListJson.map((element) => Revenue.fromJson(element)).toList();
      return reportExpenditures;
    } catch (e) {
        print('Error jhjfghfetching revenues: $e');
        return reportExpenditures;
      }
  }
}