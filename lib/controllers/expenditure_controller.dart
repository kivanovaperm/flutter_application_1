import 'package:flutter_application_1/api/api_connection.dart';
import 'package:flutter_application_1/api/expenditure_api.dart';
import 'package:flutter_application_1/models/expenditure.dart';
import 'package:flutter_application_1/services/secure_storage_manager.dart';
import 'package:flutter_application_1/models/category.dart';

class ExpenditureController {
  final ExpenditureApi _expenditureApi = ExpenditureApi();

  Future<List<Expenditure>> fetchExpenditures() async {
    List<Expenditure> expenditures = [];
    try {
      SecureStorageManager secureStorageManager = SecureStorageManager();
      final accessToken = await secureStorageManager.getAccessToken();
      final expendituresListJson =
          await _expenditureApi.expenditureList(accessToken);
      for (var element in expendituresListJson) {
        Expenditure expenditure = Expenditure.fromJson(element);
        expenditures.add(expenditure);
      }

      return expenditures;
    } catch (e) {
      print('Error jhjfghfetching revenues: $e');
      return expenditures;
    }
  }

  Future<Expenditure> fetchExpenditureDetail(int id) async {
    SecureStorageManager secureStorageManager = SecureStorageManager();
    final accessToken = await secureStorageManager.getAccessToken();
    final expenditureJson =
        await _expenditureApi.expenditureDetailList(accessToken, id);

    Expenditure expenditure = Expenditure.fromJson(expenditureJson);

    return expenditure;
  }

  Future<bool> deleteExpenditure(int id) async {
    try {
      SecureStorageManager secureStorageManager = SecureStorageManager();
      final accessToken = await secureStorageManager.getAccessToken();

      // Вызов API для удаления данных по их ID
      final response = await _expenditureApi.deleteExpenditure(accessToken, id);
      if (response.statusCode == 200 || response.statusCode == 204) {
        // Успешно удалено
        return true;
      } else {
        // Обработка ошибок при удалении
        print('Error deleting expenditure: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      // Обработка других ошибок при удалении
      print('Error deleting expenditure: $e');
      return false;
    }
  }

  Future<bool?> updateExpenditure(
      int id,
      String updatedSum,
      int updatedCategoryId,
      String updatedExpenditureDate,
      String updatedExpanditureType) async {
    bool isUpdated = false;
    SecureStorageManager secureStorageManager = SecureStorageManager();
    final accessToken = await secureStorageManager.getAccessToken();
    isUpdated = await _expenditureApi.updateExpenditure(
        accessToken,
        id,
        updatedSum,
        updatedCategoryId,
        updatedExpenditureDate,
        updatedExpanditureType);

    return isUpdated;
  }

  Future<bool?> createExpenditure(double newSum, int newCategoryId,
      String newExpenditureType, String newExpenditureDate) async {
    bool isCreated = false;
    try {
      SecureStorageManager secureStorageManager = SecureStorageManager();
      final accessToken = await secureStorageManager.getAccessToken();
      isCreated = await _expenditureApi.createExpenditure(accessToken, newSum,
          newCategoryId, newExpenditureType, newExpenditureDate);
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
      final categoriesData = await _expenditureApi.getCategories(accessToken);

      // Преобразование данных в список объектов RevenueCategory
      List<RevenueCategory> categories = categoriesData!.map((categoryData) {
        return RevenueCategory.fromJson(categoryData);
      }).toList();

      return categories;
    } catch (e) {
      // Обработка ошибок при получении категорий
      print('Error fetching categories: $e');
      throw Exception('Failed to fetch categories');
    }
  }
}
