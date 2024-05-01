import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart' as launcher;
import 'package:url_launcher/url_launcher_string.dart';


class MainScreen extends StatefulWidget {
  const MainScreen({super.key, required this.token});
  final String token;

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _initialCount = 5; // Начальное количество вакансий для отображения
  bool _showLoadMore = false; // Флаг для отображения кнопки "Загрузить больше"
  PersistentTabController _controller =
      PersistentTabController(initialIndex: 0);
  List<Map<String, dynamic>> _VacancyList = [];
  List<Map<String, dynamic>> _data = [];


void _printListsToConsole() {
  print('_VacancyList: ${_VacancyList.length}');
}


  Future<void> _getData() async {
    final response = await http.get(Uri.parse('http://192.168.250.49:8000/api/'));
    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      final topEmployers = data['top_employers'] as List<dynamic>;
      final topVacanciesByCompany =
          data['top_vacancies_by_company'] as List<dynamic>;

      _data = [];

      // Добавляем топ-компании в _data
      _data.addAll(topEmployers.map((company) {
        return {
          'type': 'company',
          'data': company,
        };
      }));

      // Добавляем вакансии для каждой компании в _data
      for (var companyData in topVacanciesByCompany) {
        final company = companyData['company'] as String;
        final vacancies = companyData['vacancies'] as List<dynamic>;

        for (var vacancyData in vacancies) {
          final vacancy = {
            'title': vacancyData['title'] as String,
            'description': vacancyData['description'],
            'url': vacancyData['url'] as String,
            'salary': vacancyData['salary'],
            'company': company,
            'city': vacancyData['city'] as String,
            'source': vacancyData['source'] as String,
            'created_by': vacancyData['created_by'],
            'created_at': vacancyData['created_at'] as String,
            'is_new': vacancyData['is_new'] as bool,
          };

          _data.add({
            'type': 'vacancy',
            'data': vacancy,
          });
        }
      }
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<void> _getVacancies() async {
    final response = await http.get(Uri.parse('http://192.168.250.49:8000/api/'));

    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      final vacancies = data['all_vacancies'] as List<dynamic>;
      _VacancyList =
          vacancies.map((vacancy) => vacancy as Map<String, dynamic>).toList();
    } else {
      throw Exception('Failed to load vacancies');
    }
  }

  void _loadMoreVacancies() {
    setState(() {
      _initialCount = _VacancyList
          .length; // Увеличиваем начальное количество для отображения всех вакансий
      _showLoadMore = false; // Скрываем кнопку "Загрузить больше"
    });
  }


  Widget _buildCompanyCard(
      Map<String, dynamic> company, List<Map<String, dynamic>> vacancies) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Container(
          width: 200,
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            border: Border.all(color: Colors.blueAccent),
            borderRadius: BorderRadius.circular(10.0),
            color: Colors.white,
          ),
          padding: const EdgeInsets.all(10),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  child: SizedBox(
                    width: 100,
                    height: 100,
                    child: Image.network(
                      company['logo']!,
                      width: 80,
                      height: 80,
                    ),
                  ),
                  width: 170,
                  height: 170,
                ),
                const SizedBox(height: 10.0),
                Container(
                  child: Center(
                    child: Text(
                      company['shown_name']!,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10.0,
                  width: 30,
                ),
                ...vacancies.map((vacancy) => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkWell(
                           onTap: () async {
                                    launcher.launchUrl(
                                      Uri.parse(vacancy['url']),
                                      mode:
                                          launcher.LaunchMode.externalApplication,
                                    );
                                  },
                          child: Column(
                           crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Divider(),
                              Text(
                                vacancy['title'] ?? '',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text('Город: ${vacancy['city']}'),
                              const SizedBox(height: 8),
                            ],
                          ),
                        ),
                      ],
                    )),
              ],
            ),
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        elevation: 0,
        // leading: IconButton(
        //   onPressed: () {},
        //   icon: Icon(Icons.account_circle_outlined),
        // ),
        centerTitle: true,
        title: Text(
          'Joomys',
          style: GoogleFonts.josefinSans(
            fontSize: 34,
            textStyle: TextStyle(color: Colors.blueAccent),
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
        child: Stack(
          children: [
            // Text("Top "),
            Positioned.fill(
              bottom: 490,
              child: FutureBuilder<void>(
                future: _getData(),
                builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Colors.blueAccent,
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: _data.map((item) {
                          if (item['type'] == 'company') {
                            final company =
                                item['data'] as Map<String, dynamic>;
                            final companyVacancies = _data
                                .where((item) =>
                                    item['type'] == 'vacancy' &&
                                    item['data']['company'] ==
                                        company['db_name'])
                                .map((item) =>
                                    item['data'] as Map<String, dynamic>)
                                .toList();

                            return _buildCompanyCard(company, companyVacancies);
                          } else {
                            return Container();
                          }
                        }).toList(),
                      ),
                    );
                  }
                },
              ),
            ),
            Positioned.fill(
                top: 285,
                child: Padding(
                  padding: EdgeInsets.only(left: 15),
                  child: Text(
                    "Вакансии",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                )),
        Positioned.fill(
          top: 320,
          child: Row(
            children: [
              Flexible(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: FutureBuilder<void>(
                        future: _getVacancies(),
                        builder:
                            (BuildContext context, AsyncSnapshot<void> snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Center(
                              child: CircularProgressIndicator(
                                color: Colors.blueAccent,
                              ),
                            );
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else {
                            _showLoadMore = _VacancyList.length > _initialCount;
                            return SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ListView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: _showLoadMore
                                        ? _VacancyList.length + 1
                                        : _VacancyList.length,
                                    itemBuilder: (BuildContext context, int index) {
                                      if (index == _initialCount) {
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 16.0),
                                          child: Center(
                                            child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.blueAccent),
                                              onPressed: _loadMoreVacancies,
                                              child: Text(
                                                'Еще ${_VacancyList.length - _initialCount} вакансии',
                                                style: TextStyle(color: Colors.white),
                                              ),
                                            ),
                                          ),
                                        );
                                      } else if (_showLoadMore &&
                                          index > _initialCount) {
                                        final vacancyIndex =
                                            index - (_initialCount + 1);
                                        final vacancy = _VacancyList[vacancyIndex];
                                        final title = vacancy['title'] ?? '';
                                        final description =
                                            vacancy['description'] ?? '';
                                        final company = vacancy['company'] ?? '';
                                        final salary = vacancy['salary'] ?? '';
                                        final city = vacancy['city'] ?? '';
                                        final tag = vacancy['tags'] ?? '';
                                        List<String> tags = tag.isNotEmpty
                                        ? (tag.startsWith('[') && tag.endsWith(']'))
                                            ? tag.substring(1, tag.length - 1).split(',')
                                            : [tag]
                                        : [];
                                        return InkWell(
                                          onTap: () async {
                                            launcher.launchUrl(
                                              Uri.parse(vacancy['url']),
                                              mode:
                                                  launcher.LaunchMode.externalApplication,
                                            );
                                          },
                                          child: Card(
                                            // ... (остальной код для отображения вакансии)
                                          ),
                                        );
                                      } else {
                                        final vacancy = _VacancyList[index];
                                        final title = vacancy['title'] ?? '';
                                        final description =
                                            vacancy['description'] ?? '';
                                        final company = vacancy['company'] ?? '';
                                        final salary = vacancy['salary'] ?? '';
                                        final city = vacancy['city'] ?? '';
                                        final tag = vacancy['tags'] ?? '';
                                        List<String> tags = tag.isNotEmpty
                                        ? (tag.startsWith('[') && tag.endsWith(']'))
                                            ? tag.substring(1, tag.length - 1).split(',')
                                            : [tag]
                                        : [];
                                        return InkWell(
                                          onTap: () async {
                                            launcher.launchUrl(
                                              Uri.parse(vacancy['url']),
                                              mode:
                                                  launcher.LaunchMode.externalApplication,
                                            );
                                          },
                                             child: Card(
                                                          elevation: 0,
                                                          shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                    20.0),
                                                          ),
                                                          child: Container(
                                                            decoration: BoxDecoration(
                                                                color: Colors.white,
                                                                border: Border.all(
                                                                    color: Colors
                                                                        .blueAccent),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(20)),
                                                            child: Padding(
                                                              padding:
                                                                  EdgeInsets.all(20),
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Container(
                                                                      child: Text(
                                                                    title,
                                                                    style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        fontSize: 18),
                                                                  )),
                                                                  SizedBox(height: 10),
                                                                Row(
                                                                  children: [
                                                                    Flexible(
                                                                      child: Text(company),
                                                                    ),
                                                                    SizedBox(width: 5),
                                                                    Container(
                                                                      width: 8,
                                                                      height: 8,
                                                                      decoration: BoxDecoration(
                                                                        color: Colors.blueAccent,
                                                                        shape: BoxShape.circle,
                                                                      ),
                                                                    ),
                                                                    SizedBox(width: 5),
                                                                    Flexible(
                                                                      child: Text(city),
                                                                    ),
                                                                  ],
                                                                ),

                                                                  SizedBox(height: 10),
                                                                  Container(
                                                                      child:
                                                                          Text(salary)),
                                                                  SizedBox(height: 10),
                                                                  Wrap(
                                                                    spacing:
                                                                        5, // Расстояние между тэгами
                                                                    children:
                                                                        tags.map((tag) {
                                                                      final trimmedTag =
                                                                          tag
                                                                              .trim()
                                                                              .replaceAll(
                                                                                  "'",
                                                                                  "");
                                                                      return trimmedTag
                                                                              .isNotEmpty
                                                                          ? Container(
                                                                              padding: EdgeInsets.symmetric(
                                                                                  horizontal:
                                                                                      10,
                                                                                  vertical:
                                                                                      5), // Отступы внутри контейнера
                                                                              decoration:
                                                                                  BoxDecoration(
                                                                                color: Colors
                                                                                    .blueAccent
                                                                                    .withOpacity(0.2), // Цвет фона тэга
                                                                                borderRadius:
                                                                                    BorderRadius.circular(15), // Скругление углов
                                                                                border: Border.all(
                                                                                    color:
                                                                                        Colors.blueAccent), // Обводка цвета golbueAccent
                                                                              ),
                                                                              child:
                                                                                  Text(
                                                                                trimmedTag,
                                                                                style: TextStyle(
                                                                                    color:
                                                                                        Colors.blueAccent), // Цвет текста
                                                                              ),
                                                                            )
                                                                          : const SizedBox
                                                                              .shrink();
                                                                    })?.toList()?? [],
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    }
                                                  }),
                                            ],
                                          ),
                                        );
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
          ],
        ),
      ),
    );
  }
}
