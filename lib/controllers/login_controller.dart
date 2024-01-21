import 'package:flutter_application_1/api/api_connection.dart'; // Путь к вашему файлу login_api.dart

class LoginController {
  Future<List<String>> loginUser({
    required String username,
    required String password,
  }) async {
    LoginApi _loginApi = LoginApi();
    final isSuccessfullyLoginned = await _loginApi.login(
        username, password); // Implement your registration logic here
    if (isSuccessfullyLoginned!.entries.isEmpty) {
      await Future.delayed(Duration(seconds: 2));
      return [];
    } else {
      List<String> errors = [];
      if (isSuccessfullyLoginned != null) {
        for (final key in isSuccessfullyLoginned.entries) {
          // List<String> values = key.value.cast<List<String>>();
          // List<dynamic> values = key.value;
          // for (int i = 0; i < values.length; i++) {
          //   errors.add(values[i]);
          // }
          errors.add(key.value.toString());
        }
        return errors;
      }
      return [];
    }
  }
}
