import 'dart:convert'; // Если требуется для работы с JSON

import 'package:financial_management/models/revenue.dart';
import 'package:financial_management/models/token.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:financial_management/services/secure_storage_manager.dart';
import 'package:financial_management/api/api_connection.dart';


class RevenueReportApi {
  // https://financialmanagementbackend-production.up.railway.app/
  final String baseUrl = 'https://financialmanagementbackend-production.up.railway.app'; // Замените на URL вашего API
  // final String baseUrl = 'http://192.168.188.102:8000'; // Замените на URL вашего API

 Future<dynamic> revenueList(String accessToken,String startDate, String endDate) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/reports/revenue'), 
        headers: <String, String>{
          'Content-Type': 'application/json', // Пример заголовка
          'Authorization': "Bearer " + accessToken
        },
        body: jsonEncode({
          'start_date': startDate,
          'end_date': endDate,
          // ... другие поля, которые вы хотите обновить
        }),

      );
      if (response.statusCode == 200) {
        return json.decode(utf8.decode(response.bodyBytes));
      } 
      
      else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}