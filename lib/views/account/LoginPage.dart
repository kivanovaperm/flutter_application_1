import 'package:flutter_application_1/views/revenue/RevenueListPage.dart';
import 'package:flutter_application_1/views/sidebar/SideBarPage.dart';
import 'package:flutter/material.dart';

import 'package:flutter_application_1/controllers/login_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();

  final LoginController _loginController = LoginController();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool _isLoading = false;
  bool _isError = false;
  String? accessToken;
  String? refreshToken;
  bool passwordVisible = true;
  List<String> _isLogged = [];

  @override
  void initState() {
    super.initState();
    loadTokensFromSharedPrefs();
  }

  Future<void> loadTokensFromSharedPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      accessToken = prefs.getString('accessToken');
      refreshToken = prefs.getString('refreshToken');
    });
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavDrawer(),
      appBar: AppBar(
        title: const Text("Авторизация"),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(10),
              child: TextField(
                controller: usernameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Логин пользователя',
                  hintText: 'Введите ваш логин',
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: TextField(
                controller: passwordController,
                obscureText: passwordVisible,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Пароль пользователя',
                  hintText: 'Введите ваш пароль',
                  suffixIcon: IconButton(
                    icon: Icon(passwordVisible
                        ? Icons.visibility
                        : Icons.visibility_off),
                    onPressed: () {
                      setState(
                        () {
                          passwordVisible = !passwordVisible;
                        },
                      );
                    },
                  ),
                ),
              ),
            ),
            // TextButton(
            //   onPressed: (){
            //     //TODO FORGOT PASSWORD SCREEN GOES HERE
            //   },
            //   child: Text(
            //     'Забыли пароль?',
            //     style: TextStyle(color: Colors.blue, fontSize: 15),
            //   ),
            // ),
            Container(
              height: 50,
              width: 250,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(20),
              ),
              child: TextButton(
                onPressed: _isLoading ? null : () => _loginUser(context),
                child: _isLoading
                    ? Container(
                        width: 24,
                        height: 24,
                        padding: const EdgeInsets.all(2.0),
                        child: const CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 3,
                        ),
                      )
                    : Text(
                        'Войти',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Visibility(
              visible: _isError,
              child: Text(
                _isLogged.join("\n"),
                style: TextStyle(
                  color: Colors.redAccent,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _loginUser(BuildContext context) async {
    print("ASDASDASD");

    setState(() {
      _isLoading = true;
      _isError = false;
      _isLogged = [];
    });

    // Get values from text controllers
    String username = usernameController.text;
    String password = passwordController.text;

    if (username.isEmpty || password.isEmpty) {
      setState(() {
        _isLoading = false;
        _isError = true;
      });
      return;
    }

    // Call the registerUser method from the controller
    List<String> loginResult = await widget._loginController.loginUser(
      username: username,
      password: password,
    );

    print("EEEEEEE: ${loginResult}");

    // Set _isRegistered to true upon successful registration
    setState(() {
      _isLoading = false;
      _isLogged = loginResult;
    });

    // Navigate to LoginPage after successful registration
    if (loginResult.isEmpty) {
      await Future.delayed(Duration(seconds: 1));
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => RevenuePage()),
      );
    } else {
      setState(() {
        _isError = true;
      });
    }
  }
}
