import 'package:flutter/material.dart';
import 'package:financial_management/views/account/LoginPage.dart';
 
void main() {
  runApp(MyApp());
}
 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Управление финансами',
      debugShowCheckedModeBanner: false,
      home: LoginPage(), // Используйте вашу страницу входа здесь
    );
  }
}
