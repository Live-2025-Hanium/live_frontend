import 'package:flutter/material.dart';
import 'package:live_frontend/models/forum_post_detail_model.dart'; // ReactionType import

class PostDetailReaction extends StatelessWidget {
  const PostDetailReaction({
    super.key,
    required this.counts,
    required this.selected,
    required this.onToggle,
  });

  final Map<ReactionType, int> counts;
  final Set<ReactionType> selected;
  final void Function(ReactionType) onToggle;

  @override
  Widget build(BuildContext context) {
    const order = <ReactionType>[
      ReactionType.empathy,
      ReactionType.useful,
      ReactionType.helpful,
      ReactionType.inspiring,
      ReactionType.encouraging,
    ];

    return Wrap(
      spacing: 8,
      children: [
        for (final r in order)
          ChoiceChip(
            label: Text(_label(r, counts[r] ?? 0)),
            selected: selected.contains(r),
            onSelected: (_) => onToggle(r),
          ),
      ],
    );
  }

  String _label(ReactionType r, int count) {
    switch (r) {
      case ReactionType.empathy:
        return '공감 $count';
      case ReactionType.useful:
        return '유용 $count';
      case ReactionType.helpful:
        return '도움 $count';
      case ReactionType.inspiring:
        return '영감 $count';
      case ReactionType.encouraging:
        return '응원 $count';
      case ReactionType.unknown:
        return '기타 $count';
    }
  }
}
