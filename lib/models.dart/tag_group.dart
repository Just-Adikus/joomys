import 'package:flutter/material.dart';



class TagGroup extends StatefulWidget {
  final List<String> tags;
  final List<String> selectedTags;
  final Function(List<String>) onTagsChanged;

  const TagGroup({
    super.key,
    required this.tags,
    required this.selectedTags,
    required this.onTagsChanged,
  });

  @override
  State<TagGroup> createState() => _TagGroupState();
}

class _TagGroupState extends State<TagGroup> {
  bool get isSelected => widget.selectedTags.any((tag) => widget.tags.contains(tag));

  void _toggleSelection() {
    final newTags = isSelected
        ? widget.selectedTags.where((tag) => !widget.tags.contains(tag)).toList()
        : [...widget.selectedTags, ...widget.tags];
    widget.onTagsChanged(newTags);
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: widget.tags.map((tag) {
        return FilterChip(
          disabledColor: Colors.blueAccent,
          checkmarkColor: Colors.black,
          selectedColor: Colors.blueAccent,
          label: Text(tag),
          selected: isSelected,
          onSelected: (_) => _toggleSelection(),
        );
      }).toList(),
    );
  }
}