import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:live_frontend/widgets/saeip_toast.dart';

class SaeipToastController {
  static OverlayEntry? _currentEntry;
  static AnimationController? _animationController;

  static void showToast({
    required BuildContext context,
    required Widget child,
    Duration duration = const Duration(seconds: 2),
  }) {
    _removeCurrent(immediate: true);

    final overlay = Overlay.of(context);

    late OverlayEntry entry;

    entry = OverlayEntry(
      builder: (context) {
        final bottomPadding = MediaQuery.of(context).viewPadding.bottom;
        final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
        final bottomOffset = max(bottomPadding, keyboardHeight);

        return _ToastAnimator(
          bottomOffset: bottomOffset,
          onDismiss: () => _removeCurrent(immediate: true),
          child: child,
        );
      },
    );

    _currentEntry = entry;
    overlay.insert(entry);

    // 자동 제거
    Future.delayed(duration, () {
      if (_currentEntry == entry) {
        _removeCurrent(immediate: false);
      }
    });
  }

  static void _removeCurrent({bool immediate = false}) {
    if (_currentEntry == null) return;

    if (!immediate && _animationController != null) {
      _animationController!.reverse().then((_) {
        _currentEntry?.remove();
        _currentEntry = null;
      });
    } else {
      _currentEntry?.remove();
      _currentEntry = null;
    }
  }

  static void showMessage(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 2),
  }) {
    showToast(
      context: context,
      child: SaeipToast(message: message),
      duration: duration,
    );
  }
}

class _ToastAnimator extends StatefulWidget {
  final Widget child;
  final double bottomOffset;
  final VoidCallback onDismiss;

  const _ToastAnimator({
    required this.child,
    required this.bottomOffset,
    required this.onDismiss,
  });

  @override
  State<_ToastAnimator> createState() => _ToastAnimatorState();
}

class _ToastAnimatorState extends State<_ToastAnimator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fade;
  late Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
      reverseDuration: const Duration(milliseconds: 100),
    );
    SaeipToastController._animationController = _controller;

    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _slide = Tween(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    if (SaeipToastController._animationController == _controller) {
      SaeipToastController._animationController = null;
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: Stack(
        children: [
          Positioned.fill(
            child: Container(color: const Color.fromRGBO(0, 0, 0, 0.1)),
          ),
          // 토스트
          Positioned(
            left: 40,
            right: 40,
            bottom: 40 + widget.bottomOffset,
            child: SlideTransition(position: _slide, child: widget.child),
          ),
        ],
      ),
    );
  }
}
