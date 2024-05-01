import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:joomys/view/main_screen.dart';
import 'package:joomys/view/sample_one.dart';
import 'dart:convert';

import 'package:joomys/view/sign_up_screen.dart';
import 'package:joomys/view/user_profile_screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key,});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  late String token = '';
// Default user type

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    if (_formKey.currentState!.validate()) {
      final email = _emailController.text;
      final password = _passwordController.text;

      final url = Uri.parse('http://192.168.250.49:8000/api/login/');

      try {
        final response = await http.post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'email': email,
            'password': password,
          }),
        );

        if (response.statusCode == 200) {
          token = jsonDecode(response.body)['access'];
          print('Token: $token');
          Navigator.push(
              context, MaterialPageRoute(builder: (context) =>SampleOne(token: token,)));
          print('Вход успешен');
        } else {
          print('Ошибка при входе: ${response.body}');
        }
      } catch (e) {
        print('Произошла ошибка: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleSpacing: 30.0,
      ),
      body: Stack(
        children: [
          Positioned(
            left: 120.0,
            right: 30.0,
            top: 10.0,
            child: Container(
              child: Text(
                'Joomys',
                style: GoogleFonts.josefinSans(
                  fontSize: 50,
                  textStyle: TextStyle(color: Colors.blueAccent),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(30.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Container(
                      height: 100,
                    ),
                    TextFormField(
                      cursorColor: Colors.blueAccent,
                      controller: _emailController,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(width: 2, color: Colors.blueAccent),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(width: 2, color: Colors.blueAccent),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        labelText: 'Почта',
                        labelStyle: TextStyle(color: Colors.blueAccent),
                        prefixIcon: Icon(
                          Icons.email_outlined,
                          color: Colors.blueAccent,
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Введите почту';
                        }
                        return null;
                      },
                    ),
                    Container(
                      height: 20,
                    ),
                    TextFormField(
                      cursorColor: Colors.blueAccent,
                      controller: _passwordController,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(width: 2, color: Colors.blueAccent),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(width: 2, color: Colors.blueAccent),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        labelText: 'Пароль',
                        labelStyle: TextStyle(color: Colors.blueAccent),
                        prefixIcon: Icon(
                          Icons.key,
                          color: Colors.blueAccent,
                        ),
                      ),
                      obscureText: true,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Введите пароль';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 40.0),
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.blueAccent),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                            side: BorderSide(color: Colors.blueAccent),
                          ),
                        ),
                      ),
                      onPressed: _signIn,
                      child: Text(
                        'Войти',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                    SizedBox(height: 16.0),
                    SizedBox(height: 16.0),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SignUpScreen()));
                      },
                      child: Text(
                        'Нет аккаунта? Зарегистрируйтесь!',
                        style: TextStyle(color: Colors.black, fontSize: 15),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
