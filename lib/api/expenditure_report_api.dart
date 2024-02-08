import 'dart:convert'; // Если требуется для работы с JSON

import 'package:flutter_application_1/models/revenue.dart';
import 'package:flutter_application_1/models/token.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_application_1/services/secure_storage_manager.dart';
import 'package:flutter_application_1/api/api_connection.dart';

class ExpenditureReportApi {
  // https://financialmanagementbackend-production.up.railway.app/
  final String baseUrl =
      'https://financialmanagementbackend-production.up.railway.app';
  // final String baseUrl = 'http://192.168.188.102:8000';

  Future<dynamic> expenditureList(
      String accessToken, String startDate, String endDate) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/reports/expenditure'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': "Bearer " + accessToken
        },
        body: jsonEncode({
          'start_date': startDate,
          'end_date': endDate,
        }),
      );
      if (response.statusCode == 200) {
        print("5555555555${json.decode(utf8.decode(response.bodyBytes))}");
        return json.decode(utf8.decode(response.bodyBytes));
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}
