import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class AddScreen extends StatefulWidget {
  const AddScreen({super.key, required this.token});
  final String token;

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  bool added = false;
  String dateString = '';
  String formattedDate = '';
  Map<String, dynamic> _userData = {}; // Store user data here
  final _formKey = GlobalKey<FormState>();
  final _companyNameController = TextEditingController();
  final _companyDescriptionController = TextEditingController();
  final _companyHeadcountController = TextEditingController();
  String _companyType = 'product';
  final _companyIndustryController = TextEditingController();
  final _companyTechStackController = TextEditingController();
  final _companyLogoUrlController = TextEditingController();
  final _companyWebsiteUrlController = TextEditingController();

  Future<void> _addCompany() async {
    final url = Uri.parse('http://192.168.250.49:8000/api/company/add/');
    final headers = {
      'Authorization': 'Bearer ${widget.token}',
      'Content-Type': 'application/json',
    };

    final body = {
      'name': _companyNameController.text,
      'description': _companyDescriptionController.text,
      'headcount': int.parse(_companyHeadcountController.text),
      'type': _companyType,
      'industry': _companyIndustryController.text,
      'tech_stack': _companyTechStackController.text.split(','),
      'logo_url': _companyLogoUrlController.text,
      'website_url': _companyWebsiteUrlController.text,
    };

    try {
      final response =
          await http.post(url, headers: headers, body: jsonEncode(body));

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        added = true;
        print(data);
        // Обработка успешного ответа
      } else {
        print('Failed to add company. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

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

  void _showAddCompanyDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          surfaceTintColor: Colors.white,
          backgroundColor: Colors.white,
          title: Text('Добавить компанию'),
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    cursorColor: Colors.blueAccent,
                    controller: _companyNameController,
                    decoration: InputDecoration(
                      labelText: 'Название компании',
                      labelStyle: TextStyle(color: Colors.black),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blueAccent),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blueAccent),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    cursorColor: Colors.blueAccent,
                    controller: _companyDescriptionController,
                    decoration: InputDecoration(
                      labelText: 'Описание компании',
                      labelStyle: TextStyle(color: Colors.black),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blueAccent),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blueAccent),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    cursorColor: Colors.blueAccent,
                    controller: _companyHeadcountController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Количество сотрудников',
                      labelStyle: TextStyle(color: Colors.black),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blueAccent),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blueAccent),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    value: _companyType,
                    onChanged: (String? newValue) {
                      setState(() {
                        _companyType = newValue!;
                      });
                    },
                    items: <String>['product', 'outsource', 'outstaff']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: TextStyle(),
                        ),
                      );
                    }).toList(),
                    decoration: InputDecoration(
                      labelText: 'Тип компании',
                      labelStyle: TextStyle(color: Colors.black),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blueAccent),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blueAccent),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    cursorColor: Colors.blueAccent,
                    controller: _companyIndustryController,
                    decoration: InputDecoration(
                      labelText: 'Индустрия',
                      labelStyle: TextStyle(color: Colors.black),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blueAccent),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blueAccent),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    cursorColor: Colors.blueAccent,
                    controller: _companyTechStackController,
                    decoration: InputDecoration(
                      labelText: 'Технологический стек (через запятую)',
                      labelStyle: TextStyle(color: Colors.black),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blueAccent),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blueAccent),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    cursorColor: Colors.blueAccent,
                    controller: _companyLogoUrlController,
                    decoration: InputDecoration(
                      labelText: 'Лого',
                      labelStyle: TextStyle(color: Colors.black),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blueAccent),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blueAccent),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    cursorColor: Colors.blueAccent,
                    controller: _companyWebsiteUrlController,
                    decoration: InputDecoration(
                      labelText: 'Сайт компании',
                      labelStyle: TextStyle(color: Colors.black),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blueAccent),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blueAccent),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Отмена',
                style: TextStyle(color: Colors.blueAccent),
              ),
            ),
            TextButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _addCompany();
                  Navigator.of(context).pop();
                }
              },
              child: Text(
                'Добавить',
                style: TextStyle(color: Colors.blueAccent),
              ),
            ),
          ],
        );
      },
    );
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
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 30,
                  ),
                  InkWell(
                    onTap: _showAddCompanyDialog,
                    child: Card(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: Container(
                            width: 300,
                            height: 200,
                            decoration: BoxDecoration(
                                color: Colors.blueAccent,
                                border: Border.all(color: Colors.blueAccent),
                                borderRadius: BorderRadius.circular(20)),
                            child: Padding(
                              padding: EdgeInsets.all(30),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Center(
                                    child: ListTile(
                                        leading: Icon(
                                          Icons.add_business,
                                          color: Colors.white,
                                          size: 40,
                                        ),
                                        title: Text(
                                          "Добавить компанию",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20),
                                        )),
                                  ),
                                ],
                              ),
                            ))),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  _userData['user_type'] == 'recruiter'
                      ? InkWell(
                          onTap: () {},
                          child: Card(
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              child: Container(
                                  width: 300,
                                  height: 200,
                                  decoration: BoxDecoration(
                                      color: Colors.blueAccent,
                                      border:
                                          Border.all(color: Colors.blueAccent),
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Padding(
                                    padding: EdgeInsets.all(30),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Center(
                                          child: ListTile(
                                              leading: Icon(
                                                Icons.add_box_outlined,
                                                color: Colors.white,
                                                size: 40,
                                              ),
                                              title: Text(
                                                "Добавить вакансию",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20),
                                              )),
                                        ),
                                      ],
                                    ),
                                  ))),
                        )
                      : Container()
                ],
              ),
            ),
          ),
        ));
  }
}
