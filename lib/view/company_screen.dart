import 'package:flutter/material.dart';

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:joomys/view/add_screen.dart';

class Company {
  final int id;
  final String name;
  final String description;
  final String headcount;
  final String type;
  final String industry;
  final String techStack;
  double averageRating;

  Company({
    required this.id,
    required this.name,
    required this.description,
    required this.headcount,
    required this.type,
    required this.industry,
    required this.techStack,
    required this.averageRating,
  });

  factory Company.fromJson(Map<String, dynamic> json) {
    final summary = json['company_review_summary'];
    final averageRating = summary != null
        ? (summary['salary'] +
                summary['work_schedule'] +
                summary['remote_work'] +
                summary['equipment'] +
                summary['career'] +
                summary['projects'] +
                summary['tech_stack'] +
                summary['management'] +
                summary['recommend']) /
            9.0
        : 0.0;

    return Company(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      headcount: json['headcount'],
      type: json['type'],
      industry: json['industry'],
      techStack: json['tech_stack'],
      averageRating: averageRating,
    );
  }
}

class CompanyScreen extends StatefulWidget {
  const CompanyScreen({super.key, required this.token});
  final String token;
  @override
  _CompanyScreenState createState() => _CompanyScreenState();
}

class _CompanyScreenState extends State<CompanyScreen> {
  List<Company> _companies = [];


  @override
  void initState() {
    super.initState();
    _loadCompanies();
  }

  Future<void> _loadCompanies() async {
    final response =
        await http.get(Uri.parse('http://192.168.250.49:8000/api/companies/'));
    if (response.statusCode == 200) {
      // Decode response body using utf8.decode for proper Cyrillic handling
      final decodedResponseBody = utf8.decode(response.bodyBytes);

      // Parse JSON using jsonDecode
      final companies = jsonDecode(decodedResponseBody) as List;
      setState(() {
        _companies =
            companies.map((company) => Company.fromJson(company)).toList();
      });
    } else {
      throw Exception('Failed to load companies');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        shadowColor: Colors.white,
        surfaceTintColor: Colors.white,
        automaticallyImplyLeading: false,
        title: Text(
          'Список компаний',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: _buildCompanyList(setState),
    );
  }

  Widget _buildCompanyList(StateSetter setStateCompanyList) {
    return ListView.builder(
      itemCount: _companies.length,
      itemBuilder: (context, index) {
        final company = _companies[index];
        return InkWell(
            onTap: () => _showCompanyDialog(company, setStateCompanyList),
            child: Card(
              elevation: 0.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.blueAccent),
                    borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding: EdgeInsets.all(30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          child: Text(
                        company.name,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      )),
                      SizedBox(height: 10),
                      FutureBuilder<double>(
                        future: _fetchCompanyAverageRating(company.id),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return _buildRichText(
                              'Рейтинг: ',
                              '${snapshot.data}',
                            );
                          } else if (snapshot.hasError) {
                            return Text('Ошибка: ${snapshot.error}');
                          } else {
                            return Text('Загрузка...');
                          }
                        },
                      ),
                      Text(company.description),
                    ],
                  ),
                ),
              ),
            ));
      },
    );
  }

  Future<double> _fetchCompanyAverageRating(int companyId) async {
    final response = await http
        .get(Uri.parse('http://192.168.250.49:8000/api/company/$companyId/'));
    if (response.statusCode == 200) {
      final companyDetails = jsonDecode(response.body);
      final companyReviewSummary = companyDetails['company_review_summary'];
      return _calculateAverageRating(companyReviewSummary);
    } else {
      throw Exception('Failed to load company details');
    }
  }

  void _showCompanyDialog(
      Company company, StateSetter setStateCompanyList) async {
    final response = await http.get(
        Uri.parse('http://192.168.250.49:8000/api/company/${company.id}/'));
    if (response.statusCode == 200) {
      final decodedResponseBody = utf8.decode(response.bodyBytes);
      final companyDetails = jsonDecode(decodedResponseBody);
      final companyReviewSummary = companyDetails['company_review_summary'];
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            surfaceTintColor: Colors.white,
            backgroundColor: Colors.white,
            title: Text(company.name),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 5),
                _buildRichText(
                        'Рейтинг: ',
                        '${_calculateAverageRating(companyReviewSummary)}',
                      ),
                SizedBox(height: 10),
                _buildRichText(
                  'Тип компании: ',
                  '${companyDetails['company']['type']}',
                ),
                SizedBox(height: 10),
                _buildRichText(
                  'Индустрия: ',
                  '${companyDetails['company']['industry']}',
                ),
                SizedBox(height: 10),
                _buildRichText(
                  'Технологический стек: ',
                  '${companyDetails['company']['tech_stack']}',
                ),
                SizedBox(height: 10),
                Text('${companyDetails['company']['description']}'),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _showReviewDialog(company, setStateCompanyList);
                },
                child: Text(
                  'Оценить',
                  style: TextStyle(color: Colors.blueAccent),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  'Закрыть',
                  style: TextStyle(color: Colors.blueAccent),
                ),
              ),
            ],
          );
        },
      );
    } else {
      throw Exception('Failed to load company details');
    }
  }

  void _showReviewDialog(Company company, StateSetter setStateCompanyList) {
    // Создайте Map для хранения оценок
    Map<String, int> ratings = {
      'career': 0,
      'salary': 0,
      'projects': 0,
      'equipment': 0,
      'recommend': 0,
      'management': 0,
      'tech_stack': 0,
      'remote_work': 0,
      'work_schedule': 0,
    };

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          surfaceTintColor: Colors.white,
          backgroundColor: Colors.white,
          title: Text('Оценить компанию'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildRatingSlider('Я доволен зарплатой', 'salary', ratings),
                _buildRatingSlider('Я доволен рабочим графиком в компании',
                    'work_schedule', ratings),
                _buildRatingSlider(
                    'Я могу выбирать откуда работать', 'remote_work', ratings),
                _buildRatingSlider(
                    'Компания предоставляет всю необходимую технику для работы',
                    'equipment',
                    ratings),
                _buildRatingSlider(
                    'Компания предоставляет возможность карьерного роста',
                    'career',
                    ratings),
                _buildRatingSlider(
                    'В компании интересные проекты', 'projects', ratings),
                _buildRatingSlider(
                    'В компании используют современные технологии/стек',
                    'tech_stack',
                    ratings),
                _buildRatingSlider(
                    'Мне нравится менеджмент компании', 'management', ratings),
                _buildRatingSlider('Я готов рекомендовать компанию друзьям',
                    'recommend', ratings),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                // Здесь вы можете отправить запрос POST с оценками
                final url = Uri.parse(
                    'http://192.168.250.49:8000/api/company/${company.id}/review/');
                final headers = {
                  'Authorization': 'Bearer ${widget.token}',
                  'Content-Type': 'application/json', // Добавлено
                };

                try {
                  final response = await http.post(
                    url,
                    headers: headers,
                    body: jsonEncode(ratings),
                  );

                  print('Response status: ${response.statusCode}');

                  if (response.statusCode == 201) {
                    await _fetchCompanyAverageRating(company.id)
                        .then((newRating) {
                      final companyIndex =
                          _companies.indexWhere((c) => c.id == company.id);
                      if (companyIndex != -1) {
                        _companies[companyIndex].averageRating = newRating;
                        setStateCompanyList(() {});
                      }
                    });
                    // Отправка успешна
                    print('! Отправка успешна');
                    print(
                        'Ответ сервера: ${response.body}'); // Выведите ответ сервера
                  } else {
                    // Отправка не удалась
                    print('Отправка не удалась: ${response.body}');
                  }
                } catch (e) {
                  print('Произошла ошибка: $e');
                }

                Navigator.of(context).pop();
              },
              child: Text(
                'Отправить',
                style: TextStyle(color: Colors.blueAccent),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Закрыть',
                style: TextStyle(color: Colors.blueAccent),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildRichText(String prefix, String value) {
    return RichText(
      text: TextSpan(
        text: prefix,
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        children: [
          WidgetSpan(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.blueAccent.withAlpha(50),
                border: Border.all(
                  color: Colors.blueAccent,
                  width: 1.0,
                ),
                borderRadius: BorderRadius.circular(20.0),
              ),
              padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              child: Text(
                value,
                style: TextStyle(color: Colors.blueAccent),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingSlider(
      String title, String key, Map<String, int> ratings) {
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title),
            Slider(
              inactiveColor: Colors.blueAccent,
              activeColor: Colors.blueAccent,
              value: ratings[key]!
                  .toDouble(), // Преобразуйте в double для ползунка
              min: 0,
              max: 10,
              divisions: 10, // Количество делений на ползунке
              label: ratings[key]!
                  .toString(), // Преобразуйте в строку для отображения
              onChanged: (double value) {
                setState(() {
                  ratings[key] =
                      value.round(); // Округлите до ближайшего целого числа
                });
              },
            ),
          ],
        );
      },
    );
  }

  double _calculateAverageRating(Map<String, dynamic> companyReviewSummary) {
    final values =
        companyReviewSummary.values.map((value) => value.toDouble()).toList();

    if (values.isNotEmpty) {
      final sum = values.reduce((a, b) => a + b);
      final average = sum / values.length;
      return double.parse(average
          .toStringAsFixed(1)); // Округление до одного знака после запятой
    }

    return 0.0;
  }
}
