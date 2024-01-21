import 'package:flutter/material.dart';
import 'package:flutter_application_1/views/account/LoginPage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Управление финансами',
      home: LoginPage(), // Используйте вашу страницу входа здесь
    );
  }
}
