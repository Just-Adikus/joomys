import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:joomys/view/company_screen.dart';
import 'package:joomys/view/main_screen.dart';
import 'package:joomys/view/search_screen.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key, required this.token});
  final String token;

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  String dateString = '';
  String formattedDate = '';
  Map<String, dynamic> _userData = {}; // Store user data here

  Future<void> _getUserProfile() async {
    final url = Uri.parse('http://192.168.250.49:8000/api/dashboard/');
    final headers = {
      'Authorization': 'Bearer ${widget.token}'
    }; // Set authorization header

    try {
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _userData = data;
          dateString = _userData['created_at']; // Update state with user data
          DateTime dateTime = DateTime.parse(dateString);
          formattedDate = DateFormat('dd/MM/yy').format(dateTime);
          print(formattedDate);
        });
      } else {
        throw Exception('Failed to fetch user profile data');
      }
    } catch (e) {
      print('Error: $e'); // Handle errors
    }
  }

  @override
  void initState() {
    super.initState();
    _getUserProfile(); // Fetch user data on initialization
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 55, vertical: 55),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    child: Icon(Icons.account_circle_outlined,
                        color: Colors.blueAccent, size: 100),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  _userData['user_type'] == 'recruiter'
                      ? Text(
                          "Рекрутер",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 30,
                              fontWeight: FontWeight.bold),
                        )
                      : Text(
                          "Соискатель",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 30,
                              fontWeight: FontWeight.bold),
                        )
                ],
              ),
              SizedBox(
                height: 20,
              ),
              RichText(
                text:TextSpan(
                text: 'Эл. почта : ',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w200, color: Colors.black),
                children: [
                TextSpan(
                 text: '${_userData['user']}',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w200, color: Colors.black),
              ),
              ]
              )),
               RichText(
                text:TextSpan(
                text: 'С нами вместе с : ',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w200,color: Colors.black),
                children: [
                TextSpan(
                 text: '${formattedDate}',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w200,color: Colors.black),
              ),
              ]
              )),
              // Text(
              //   'Эл.почта: ${_userData['user']}',
              //   style: TextStyle(fontSize: 20, fontWeight: FontWeight.w200),
              // ),
              // Text(
              //   'С нами вместе с : ${formattedDate}',
              //   style: TextStyle(fontSize: 20, fontWeight: FontWeight.w200),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
