import 'dart:async';
import 'package:flutter/material.dart';

void showSaeipToast({
  required BuildContext context,
  required Widget child,
  Duration duration = const Duration(seconds: 2),
}) {
  final overlay = Overlay.of(context);
  late final OverlayEntry entry;

  entry = OverlayEntry(
    builder: (context) {
      final bottomPadding = MediaQuery.of(context).viewPadding.bottom;

      return Stack(
        children: [
          GestureDetector(
            onTap: () => entry.remove(),
            child: Container(color: Color.fromRGBO(0, 0, 0, 0.1)),
          ),
          Positioned(
            bottom: 40 + bottomPadding,
            left: 40,
            right: 40,
            child: child,
          ),
        ],
      );
    },
  );

  overlay.insert(entry);
  Future.delayed(duration, () {
    entry.remove();
  });
}
