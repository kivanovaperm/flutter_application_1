import 'package:flutter_application_1/api/api_connection.dart';
import 'package:flutter_application_1/api/revenue_api.dart';
import 'package:flutter_application_1/models/revenue.dart';
import 'package:flutter_application_1/services/secure_storage_manager.dart'; // Путь к вашему файлу login_api.dart
import 'package:flutter_application_1/models/category.dart'; // Путь к вашему файлу login_api.dart

class RevenueController {
  final RevenueApi _revenueApi =
      RevenueApi(); // Инициализация вашего API для входа

  Future<List<Revenue>> fetchRevenues() async {
    List<Revenue> revenues = [];
    try {
      SecureStorageManager secureStorageManager = SecureStorageManager();
      final accessToken = await secureStorageManager.getAccessToken();
      final revenuesListJson = await _revenueApi.revenueList(accessToken);
      for (var element in revenuesListJson) {
        Revenue revenue = Revenue.fromJson(element);
        revenues.add(revenue);
      }
      //  List<Revenue> revenues = revenuesListJson.map((element) => Revenue.fromJson(element)).toList();
      return revenues;
    } catch (e) {
      print('Error jhjfghfetching revenues: $e');
      return revenues;
    }
  }

  Future<Revenue> fetchRevenueDetail(int id) async {
    SecureStorageManager secureStorageManager = SecureStorageManager();
    final accessToken = await secureStorageManager.getAccessToken();
    final revenueJson = await _revenueApi.revenueDetailList(accessToken, id);

    Revenue revenue = Revenue.fromJson(revenueJson);

    return revenue;
  }

  Future<bool> deleteRevenue(int id) async {
    try {
      SecureStorageManager secureStorageManager = SecureStorageManager();
      final accessToken = await secureStorageManager.getAccessToken();

      // Вызов API для удаления данных по их ID
      final response = await _revenueApi.deleteRevenue(accessToken, id);
      if (response.statusCode == 200 || response.statusCode == 204) {
        // Успешно удалено
        return true;
      } else {
        // Обработка ошибок при удалении
        print('Error deleting revenue: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      // Обработка других ошибок при удалении
      print('Error deleting revenue: $e');
      return false;
    }
  }

  Future<bool> updateRevenue(int id, String updatedSum, int updatedCategoryId,
      String updatedRevenueDate) async {
    bool isUpdated = false;
    try {
      SecureStorageManager secureStorageManager = SecureStorageManager();
      final accessToken = await secureStorageManager.getAccessToken();
      final isUpdated = await _revenueApi.updateRevenue(
          accessToken, id, updatedSum, updatedCategoryId, updatedRevenueDate);
      if (isUpdated == true) {
        return true;
      }
    } catch (e) {
      // If there's an error during the update, return false
      print('Failed to update revenue: $e');
      return false;
    }
    return isUpdated;
  }

  Future<bool> createRevenue(
      double newSum, int newCategoryId, String newRevenueDate) async {
    bool isCreated = false;
    try {
      SecureStorageManager secureStorageManager = SecureStorageManager();
      final accessToken = await secureStorageManager.getAccessToken();
      final isCreated = await _revenueApi.createRevenue(
          accessToken, newSum, newCategoryId, newRevenueDate);
      if (isCreated == true) {
        return true;
      }
    } catch (e) {
      // If there's an error during the update, return false
      print('Failed to update revenue: $e');
      return false;
    }
    return isCreated;
  }

  Future<List<RevenueCategory>> fetchCategories() async {
    try {
      // Здесь вызываете метод или API для получения списка категорий
      SecureStorageManager secureStorageManager = SecureStorageManager();
      final accessToken = await secureStorageManager.getAccessToken();
      final categoriesData = await _revenueApi.getCategories(accessToken);

      // Преобразование данных в список объектов RevenueCategory
      List<RevenueCategory> categories = categoriesData!.map((categoryData) {
        return RevenueCategory.fromJson(categoryData);
      }).toList();
      print(",dfsjagasj${categories}");
      return categories;
    } catch (e) {
      // Обработка ошибок при получении категорий
      print('Error fetching categories: $e');
      throw Exception('Failed to fetch categories');
    }
  }
}
