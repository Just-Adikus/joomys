import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import 'package:joomys/models.dart/tag.dart';
import 'package:joomys/models.dart/tag_group.dart';
import 'package:joomys/view/vacancy_filter.dart';
import 'package:url_launcher/url_launcher.dart' as launcher;
import 'package:url_launcher/url_launcher_string.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'vacancy_filter.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key, required this.token});
  final String token;

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<Map<String, dynamic>> _vacancyList = [];
  List<Map<String, dynamic>> _filteredVacancies = [];
  VacancyFilter? _vacancyFilter;
  List<String> _selectedTags = [];

  List<Tag> availableTags = [
    // Список доступных тегов
  ];

  @override
  void initState() {
    super.initState();
    _getVacancies();
    _checkUniqueAliases();
  }

 
  void _checkUniqueAliases() {
    final allAliases =
        availableTags.expand((tag) => tag.aliases).toSet().toList();
    if (allAliases.length !=
        availableTags.expand((tag) => tag.aliases).length) {
      print('Есть дублирующиеся алиасы тегов!');
    } else {
      print('Все алиасы тегов уникальны');
    }
  }

Future<void> _getVacancies() async {
  final response = await http.get(Uri.parse('http://192.168.250.49:8000/api/'));
  if (response.statusCode == 200) {
    final data = jsonDecode(utf8.decode(response.bodyBytes));
    final vacancies = data['all_vacancies'] as List<dynamic>;
    _vacancyList = vacancies.map((vacancy) => vacancy as Map<String, dynamic>).toList();

    // Получаем все теги из всех вакансий
    final allTags = <String>{};
    for (var vacancy in _vacancyList) {
      final tags = vacancy['tags'];
      if (tags != null) {
        _addTagsToSet(allTags, tags);
      }
    }

    print('Теги вакансий: $allTags');
          setState(() {
        availableTags = allTags.map((tag) => Tag(tag, [tag])).toList();
      });

    _vacancyFilter = VacancyFilter(_vacancyList);
    _filteredVacancies = _filterVacanciesByTags(_vacancyList, _selectedTags, allTags);
  } else {
    throw Exception('Failed to load vacancies');
  }
}

void _addTagsToSet(Set<String> allTags, dynamic tags) {
  if (tags is String) {
    allTags.add(tags.trim().toLowerCase());
  } else if (tags is List) {
    for (var tag in tags) {
      if (tag is String) {
        allTags.add(tag.trim().toLowerCase());
      } else if (tag is List<String>) {
        allTags.addAll(tag.map((t) => t.trim().toLowerCase()));
      }
    }
  }
}

  List<Tag> getTagsFromStrings(List<String> tagStrings) {
    return tagStrings
        .map((tagString) => availableTags.firstWhere(
              (tag) => tag.aliases.contains(tagString.trim().toLowerCase()),
              orElse: () => Tag(tagString, [tagString]),
            ))
        .toList();
  }

  List<Map<String, dynamic>> _filterVacanciesByTags(
      List<Map<String, dynamic>> vacancies,
      List<String> selectedTags,
      Set<String> allTags) {
    if (selectedTags.isEmpty) {
      print('Нет выбранных тегов, возвращаем все вакансии');
      return vacancies;
    }

    print('Выбранные теги: $selectedTags');

    final filteredVacancies = vacancies.where((vacancy) {
      final vacancyTags = vacancy['tags'] as List<String>? ?? [];
      final lowercaseVacancyTags = vacancyTags.map((tag) => tag.toLowerCase()).toSet();
      final matchingTags = selectedTags.where((tag) => lowercaseVacancyTags.contains(tag));
      print('Вакансия: ${vacancy['title']}, Теги вакансии: $vacancyTags, Совпадающие теги: $matchingTags');
      return matchingTags.isNotEmpty;
    }).toList();

    print('Отфильтрованные вакансии: $filteredVacancies');
    return filteredVacancies;
  }

void _updateCardsDisplay(List<String> selectedTags) {
  _filteredVacancies = _filterVacanciesByTags(
      _vacancyList,
      selectedTags,
      Set.from(_vacancyList.expand((vacancy) =>
          (vacancy['tags'] as List? ?? [])
              .expand((tag) => tag is String ? [tag.toLowerCase()] : tag.cast<String>().map((t) => t.toLowerCase())))));
  print('Отфильтрованные вакансии: $_filteredVacancies');
  setState(() {});
}

Widget _buildTagList() {
  return Wrap(
    spacing: 8.0,
    children: availableTags.map((tag) {
      return TagGroup(
        tags: tag.aliases,
        selectedTags: _selectedTags,
        onTagsChanged: (newTags) {
          _selectedTags = newTags;
          print('Выбранные теги: $newTags');
          _updateCardsDisplay(_selectedTags);
        },
      );
    }).toList(),
  );
}

@override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Colors.white,
    appBar: AppBar(
      elevation: 0,
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white,
      centerTitle: true,
      title: const Text('Найди подходящую вакансию'),
    ),
    body: ListView(
      children: [
        _buildTagList(),
        _filteredVacancies.isEmpty
            ? const Center(
                child: Text('Вакансии не найдены'),
              )
            : Column(
                children: _filteredVacancies.map((vacancy) {
                  return ListTile(
                    title: Text(vacancy['title']),
                    subtitle: Text(vacancy['company']),
                  );
                }).toList(),
              ),
      ],
    ),
  );
}
}