import 'package:flutter/material.dart';

class VacancyFilter {
  final List<Map<String, dynamic>> _allVacancies;

  VacancyFilter(this._allVacancies);

  VacancyFilter.withTags(this._allVacancies, List<String> tags) {
    if (tags.isNotEmpty) {
      _filteredVacancies = _filterVacanciesByTags(tags);
    } else {
      _filteredVacancies = _allVacancies;
    }
  }

  List<Map<String, dynamic>> _filteredVacancies = [];

  List<Map<String, dynamic>> get filteredVacancies => _filteredVacancies;

  List<Map<String, dynamic>> _filterVacanciesByTags(List<String> tags) {
    return _allVacancies.where((vacancy) {
      final vacancyTagsString = vacancy['tags'] as String? ?? '';
      print(vacancyTagsString);
      final vacancyTags = vacancyTagsString
          .split(',')
          .map((tag) => tag.trim().toLowerCase())
          .toList();
      return tags.every((tag) => vacancyTags.contains(tag.toLowerCase()));
    }).toList();
  }
}
