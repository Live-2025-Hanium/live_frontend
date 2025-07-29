import 'package:flutter/material.dart';

class CountdownTimer extends StatelessWidget {
  final String formattedTime;
  final double width;

  const CountdownTimer({
    super.key,
    required this.formattedTime,
    this.width = 200,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Text(
        formattedTime,
        textAlign: TextAlign.left,
        textWidthBasis: TextWidthBasis.longestLine,
        style: TextStyle(
          fontFamily: 'Pretendard',
          color: Colors.black,
          fontWeight: FontWeight.w500,
          fontSize: 48,
          height: 56 / 50,
          fontFeatures: [FontFeature.tabularFigures()],
        ),
      ),
    );
  }
}
