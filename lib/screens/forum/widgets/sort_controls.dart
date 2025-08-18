import 'package:flutter/material.dart';

enum ForumSort { latest, popular, commented }

class SortControls extends StatelessWidget {
  const SortControls({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final ForumSort value;
  final ValueChanged<ForumSort> onChanged;

  @override
  Widget build(BuildContext context) {
    Widget chip(String label, ForumSort v) => ChoiceChip(
          label: Text(label),
          selected: value == v,
          onSelected: (_) => onChanged(v),
        );

    return Row(
      children: [
        chip('최신순', ForumSort.latest),
        const SizedBox(width: 8),
        chip('인기순', ForumSort.popular),
        const SizedBox(width: 8),
        chip('댓글순', ForumSort.commented),
      ],
    );
  }
}
