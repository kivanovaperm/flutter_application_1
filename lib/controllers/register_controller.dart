import 'package:flutter_application_1/api/api_connection.dart';

class RegisterController {
  Future<List<String>> registerUser({
    required String username,
    required String firstName,
    required String lastName,
    required String password1,
    required String password2,
  }) async {
    LoginApi _loginApi = LoginApi();
    final isSuccessfullyRegistered = await _loginApi.register(
        username,
        firstName,
        lastName,
        password1,
        password2); // Implement your registration logic here
    // This is a placeholder, replace it with your actual registration logi
    if (isSuccessfullyRegistered!.entries.isEmpty) {
      await Future.delayed(Duration(seconds: 1));
      return [];
    } else {
      List<String> errors = [];
      if (isSuccessfullyRegistered != null) {
        for (final key in isSuccessfullyRegistered.entries) {
          // List<String> values = key.value.cast<List<String>>();t
          List<dynamic> values = key.value;
          for (int i = 0; i < values.length; i++) {
            errors.add(values[i]);
          }
        }
        return errors;
      }
      return [];
    }
  }
}
