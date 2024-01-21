import 'dart:convert'; // Если требуется для работы с JSON
import 'package:flutter_application_1/models/token.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_application_1/services/secure_storage_manager.dart';

class LoginApi {
  final String baseUrl =
      'https://financialmanagementbackend-production.up.railway.app'; //
  // final String baseUrl = 'http://192.168.188.102:8000'; //

  Future<Map<String, dynamic>?> login(String username, String password) async {
    try {
      // Создание запроса на бэкенд, например, авторизации пользователя
      final response = await http.post(
        Uri.parse('$baseUrl/api/auth/signin'), // Пример URL для запроса на вход
        headers: <String, String>{
          'Content-Type': 'application/json', // Пример заголовка
        },
        body: jsonEncode(<String, String>{
          'username': username,
          'password': password,
        }),
      );
      if (response.statusCode == 200) {
        Token token = new Token.fromJson(json.decode(response.body));

        SecureStorageManager secureStorageManager = SecureStorageManager();
        secureStorageManager.saveTokens(token.token, token.refreshToken);
        return {};
      } else if (response.statusCode == 401) {
        return json.decode(utf8.decode(response.bodyBytes));
      }
    } catch (e) {
      // Обработка ошибок, если запрос не удался (например, сетевая ошибка)
      // print('Error during login API request: $e');
      return {};
    }
  }

  Future<String?> refreshToken() async {
    try {
      SecureStorageManager secureStorageManager = SecureStorageManager();
      final refreshToken = await secureStorageManager.getRefreshToken();
      if (refreshToken != null) {
        final response = await http.post(
          Uri.parse('$baseUrl/api/auth/refresh'), // URL для обновления токена
          headers: <String, String>{
            'Content-Type': 'application/json', // Пример заголовка
          },
          body: jsonEncode(<String, String>{
            'refresh': refreshToken,
          }),
        );

        if (response.statusCode == 200) {
          final newAccessToken = json.decode(response.body)['access'];
          print("WEFFEDFGDGF${newAccessToken}");
          await secureStorageManager.updateAccessToken(newAccessToken);

          return newAccessToken;
        }
      } else {
        return "";
      }
    } catch (e) {
      return "";
    }
  }

  Future<Map<String, dynamic>?> register(String username, String firstName,
      String lastName, String password1, String password2) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/auth/signup'), // URL для обновления токена
        headers: <String, String>{
          'Content-Type': 'application/json', // Пример заголовка
        },
        body: jsonEncode(<String, String>{
          "username": username,
          "first_name": firstName,
          "last_name": lastName,
          "password1": password1,
          "password2": password2
        }),
      );

      if (response.statusCode == 400) {
        return json.decode(utf8.decode(response.bodyBytes));
      } else if (response.statusCode == 201) {
        return {};
      }
    } catch (e) {
      return {};
    }
  }
}
