import 'dart:convert';

import 'package:flutter_application_1/models/revenue.dart';
import 'package:flutter_application_1/models/token.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_application_1/services/secure_storage_manager.dart';
import 'package:flutter_application_1/api/api_connection.dart';

class RevenueApi {
  // https://financialmanagementbackend-production.up.railway.app/
  final String baseUrl =
      'https://financialmanagementbackend-production.up.railway.app';
  // final String baseUrl = 'http://192.168.188.102:8000';

  Future<dynamic> revenueList(String accessToken) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/api/revenue'),
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization': "Bearer " + accessToken
          });
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else if (response.statusCode == 401) {
        LoginApi loginApi = LoginApi();
        final newAccessToken = await loginApi.refreshToken();
        revenueList(newAccessToken!);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<dynamic> revenueDetailList(String accessToken, int id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/api/revenue/$id'),
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

  Future<http.Response> deleteRevenue(String accessToken, int id) async {
    try {
      final response = await http.delete(
        Uri.parse(
            '$baseUrl/api/revenue/delete/$id'), // URL для удаления данных по ID
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );
      return response;
    } catch (e) {
      throw Exception('Failed to delete revenue: $e');
    }
  }

  Future<bool> updateRevenue(String accessToken, int id, String updatedSum,
      int updatedCategoryId, String updatedRevenueDate) async {
    bool isUpdated = false;

    final DateTime parsedDate =
        DateFormat('dd.MM.yyyy').parse(updatedRevenueDate);

    final String formattedDate = DateFormat('yyyy-MM-dd').format(parsedDate);

    try {
      final response = await http.patch(
        Uri.parse(
            '$baseUrl/api/revenue/update/$id'), // URL для обновления данных по ID
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode({
          'sum': updatedSum,
          'category': updatedCategoryId,
          'revenue_date': formattedDate,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        isUpdated = true;
      } else {
        // Обработка ошибок при обновлении
        isUpdated = false;
        print('Error updating revenue: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to update revenue: $e');
    }
    return isUpdated;
  }

  Future<List<Map<String, dynamic>>?> getCategories(String accessToken) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/categories'), // URL для запроса категорий
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
        print('Failed to fetch categories: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      // Обработка ошибок при выполнении запроса
      print('Error fetching categories: $e');
      return null;
    }
  }

  Future<bool> createRevenue(String accessToken, double newSum,
      int newCategoryId, String newRevenueDate) async {
    bool isCreated = false;
    try {
      final response = await http.post(
        Uri.parse(
            '$baseUrl/api/revenue/new'), // URL для обновления данных по ID
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode({
          'sum': newSum,
          'category': newCategoryId,
          'revenue_date': newRevenueDate,
        }),
      );

      print("TTTTTTTT: ${json.decode(utf8.decode(response.bodyBytes))}");

      if (response.statusCode == 201 || response.statusCode == 204) {
        isCreated = true;
      } else {
        // Обработка ошибок при обновлении
        isCreated = false;
        print('Error updating revenue: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to update revenue: $e');
    }
    return isCreated;
  }
}
