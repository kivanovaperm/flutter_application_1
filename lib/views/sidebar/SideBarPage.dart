import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/views/account/RegisterPage.dart';
import 'package:flutter_application_1/views/account/LoginPage.dart';
import 'package:flutter_application_1/views/expenditure/ExpenditureListPage.dart';
import 'package:flutter_application_1/views/revenue/RevenueListPage.dart';
import 'package:flutter_application_1/views/report/ReportExpenditurePage.dart';
import 'package:flutter_application_1/views/report/ReportRevenuePage.dart';

import '../../services/secure_storage_manager.dart';

class NavDrawer extends StatelessWidget {
  final SecureStorageManager _storageManager = SecureStorageManager();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: FutureBuilder<bool>(
        future: _checkLoginStatus(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            bool isLoggedIn = snapshot.data ?? false;

            return ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                DrawerHeader(
                  child: Text(
                    'Учет доходов и расходов',
                    style: TextStyle(color: Colors.white, fontSize: 25),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue[400],
                    image: DecorationImage(
                      fit: BoxFit.fill,
                      image: AssetImage('assets/images/cover.jpg'),
                    ),
                  ),
                ),
                if (isLoggedIn)
                  Column(
                    children: [
                      ListTile(
                        title: Text('Доходы'),
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RevenuePage(),
                            ),
                          );
                        },
                      ),
                      ListTile(
                        title: Text('Расходы'),
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ExpenditureListPage(),
                            ),
                          );
                        },
                      ),
                      ListTile(
                        title: Text('Отчеты по расходам'),
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ReportExpenditurePage(),
                            ),
                          );
                        },
                      ),
                      ListTile(
                        title: Text('Отчеты по доходам'),
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ReportRevenuePage(),
                            ),
                          );
                        },
                      ),
                      ListTile(
                        title: Text('Напоминания'),
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ReportRevenuePage(),
                            ),
                          );
                        },
                      ),
                      ListTile(
                        title: Text('Пароль'),
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ReportRevenuePage(),
                            ),
                          );
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.exit_to_app),
                        title: Text('Выход'),
                        onTap: () async {
                          await _logoutUser();
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginPage(),
                            ),
                          );
                        },
                      )
                    ],
                  )
                else // User is not logged in
                  Column(
                    children: [
                      ListTile(
                        leading: Icon(Icons.login),
                        title: Text('Вход'),
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginPage(),
                            ),
                          );
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.person_add),
                        title: Text('Регистрация'),
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RegisterPage(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
              ],
            );
          }
        },
      ),
    );
  }

  Future<bool> _checkLoginStatus() async {
    final isLoggedIn = await _storageManager.isLoggedIn();
    return isLoggedIn;
  }

  Future<void> _logoutUser() async {
    final isLoggedOut = await _storageManager.clearTokens();
  }
}
