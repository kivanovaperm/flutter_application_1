import 'package:flutter/material.dart';
import 'package:flutter_application_1/views/sidebar/SideBarPage.dart';
import 'package:flutter_application_1/controllers/register_controller.dart';

import 'LoginPage.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController firstnameController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();
  TextEditingController passwordOneController = TextEditingController();
  TextEditingController passwordTwoController = TextEditingController();

  bool passwordVisible = true;
  bool _isLoading = false;
  bool _isError = false;
  List<String> _isRegistered = [];

  final RegisterController _registerController = RegisterController();

  @override
  void dispose() {
    usernameController.dispose();
    passwordOneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavDrawer(),
      appBar: AppBar(
        title: const Text("Регистрация"),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(10),
              child: TextField(
                controller: usernameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Имя пользователя',
                  hintText: 'Введите ваше имя пользователя',
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: TextField(
                controller: firstnameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Имя',
                  hintText: 'Введите ваше имя',
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: TextField(
                controller: lastnameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Фамилия',
                  hintText: 'Введите вашу фамилию',
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: TextField(
                controller: passwordOneController,
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
            Padding(
              padding: EdgeInsets.all(10),
              child: TextField(
                controller: passwordTwoController,
                obscureText: passwordVisible,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Повторите пароль пользователя',
                  hintText: 'Повторите ваш пароль',
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
            Container(
              height: 50,
              width: 250,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(20),
              ),
              child: TextButton(
                onPressed: _isLoading ? null : () => _registerUser(context),
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
                        'Зарегистрироваться',
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
                _isRegistered.join("\n"),
                style: TextStyle(
                  color: Colors.redAccent,
                ),
              ),
            ),
            Visibility(
              visible: _isRegistered == [],
              child: AnimatedOpacity(
                duration: Duration(seconds: 1),
                opacity: _isRegistered.isEmpty ? 1.0 : 0.0,
                child: Text(
                  "Регистрация прошла успешно!",
                  style: TextStyle(
                    color: Colors.green,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _registerUser(BuildContext context) async {
    setState(() {
      _isLoading = true;
      _isError = false;
      _isRegistered = [];
    });

    // Get values from text controllers
    String username = usernameController.text;
    String firstName = firstnameController.text;
    String lastName = lastnameController.text;
    String password1 = passwordOneController.text;
    String password2 = passwordTwoController.text;

    // Validate inputs
    if (username.isEmpty ||
        firstName.isEmpty ||
        lastName.isEmpty ||
        password1.isEmpty ||
        password2.isEmpty) {
      setState(() {
        _isLoading = false;
        _isError = true;
      });
      return;
    }

    // Call the registerUser method from the controller
    List<String> registrationResult = await _registerController.registerUser(
      username: username,
      firstName: firstName,
      lastName: lastName,
      password1: password1,
      password2: password2,
    );

    // Set _isRegistered to true upon successful registration
    setState(() {
      _isLoading = false;
      _isRegistered = registrationResult;
    });

    // Navigate to LoginPage after successful registration
    if (registrationResult.isEmpty) {
      await Future.delayed(Duration(seconds: 1));
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => LoginPage()),
      );
    } else {
      setState(() {
        _isError = true;
      });
    }
  }
}
