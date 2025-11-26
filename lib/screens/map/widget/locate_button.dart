import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LocateButton extends StatelessWidget {
  final VoidCallback? onPressed;
  const LocateButton({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: const CircleBorder(),
        padding: const EdgeInsets.all(8),
      ),
      onPressed: onPressed,
      child: SizedBox(
        width: 24,
        height: 24,
        child: SvgPicture.asset('assets/icons/reset_location.svg'),
      ),
    );
  }
}
