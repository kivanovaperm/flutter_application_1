import 'dart:convert'; // Если требуется для работы с JSON
import 'package:flutter_application_1/models/expenditure.dart';
import 'package:flutter_application_1/models/token.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_application_1/services/secure_storage_manager.dart';
import 'package:flutter_application_1/api/api_connection.dart';

class ExpenditureApi {
  // https://financialmanagementbackend-production.up.railway.app/
  final String baseUrl =
      'https://financialmanagementbackend-production.up.railway.app';
  // final String baseUrl =
  //     'http://192.168.188.102:8000';

  Future<dynamic> expenditureList(String accessToken) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/api/expenditure'),
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization': "Bearer " + accessToken
          });
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else if (response.statusCode == 401) {
        LoginApi loginApi = LoginApi();
        final newAccessToken =
            await loginApi.refreshToken(); // функция обновления токена
        expenditureList(newAccessToken!);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<dynamic> expenditureDetailList(String accessToken, int id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/api/expenditure/$id'),
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization': "Bearer " + accessToken
          });
      if (response.statusCode == 200) {
        return json.decode(utf8.decode(response.bodyBytes));
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<http.Response> deleteExpenditure(String accessToken, int id) async {
    try {
      final response = await http.delete(
        Uri.parse(
            '$baseUrl/api/expenditure/delete/$id'), // URL для удаления данных по ID
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );
      return response;
    } catch (e) {
      throw Exception('Failed to delete expenditure: $e');
    }
  }

  Future<bool> updateExpenditure(
      String accessToken,
      int id,
      String updatedSum,
      int updatedCategoryId,
      String updatedExpenditureDate,
      String updatedExpanditureType) async {
    bool isUpdated = false;

    final DateTime parsedDate =
        DateFormat('dd.MM.yyyy').parse(updatedExpenditureDate);

    // Форматирование даты в нужный формат 'yyyy-MM-dd'
    final String formattedDate = DateFormat('yyyy-MM-dd').format(parsedDate);

    try {
      final response = await http.put(
        Uri.parse(
            '$baseUrl/api/expenditure/update/$id'), // URL для обновления данных по ID
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode({
          'sum': updatedSum,
          'category': updatedCategoryId,
          'expenditure_date': formattedDate,
          'expenditure_type': updatedExpanditureType
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        isUpdated = true;
      } else {
        isUpdated = false;
        print(
            'Error updating expenditure: ${json.decode(utf8.decode(response.bodyBytes))}');
      }
    } catch (e) {
      throw Exception('Failed to update expenditure: $e');
    }

    return isUpdated;
  }

  Future<bool> createExpenditure(
      String accessToken,
      double newSum,
      int newCategoryId,
      String newExpenditureType,
      String newExpenditureDate) async {
    bool isCreated = false;
    List<String> splittedDate = newExpenditureDate.split("-");
    try {
      final response = await http.post(
        Uri.parse(
            '$baseUrl/api/expenditure/new'), // URL для обновления данных по ID
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode({
          'sum': newSum,
          'category': newCategoryId,
          'expenditure_type': newExpenditureType,
          'expenditure_date': newExpenditureDate,
        }),
      );

      if (response.statusCode == 201 || response.statusCode == 204) {
        isCreated = true;
      } else {
        // Обработка ошибок при обновлении
        isCreated = false;
        print(
            'Error updating revenue: ${json.decode(utf8.decode(response.bodyBytes))}');
      }
    } catch (e) {
      throw Exception('Failed to update revenue: $e');
    }
    return isCreated;
  }

  Future<List<Map<String, dynamic>>?> getCategories(String accessToken) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/categories'), //  URL для запроса категорий
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        List<Map<String, dynamic>> categories = List<Map<String, dynamic>>.from(
          json.decode(utf8.decode(response.bodyBytes)) as List<dynamic>,
        );

        return categories;
      } else {
        // Обработка ошибок получения категорий
        print(
            'Failed to fetch categories: ${json.decode(utf8.decode(response.bodyBytes))}');
        return null;
      }
    } catch (e) {
      // Обработка ошибок при выполнении запроса
      print('Error fetching categories: $e');
      return null;
    }
  }
}
