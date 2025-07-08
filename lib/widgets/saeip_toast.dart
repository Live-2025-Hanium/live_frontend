import 'package:flutter/material.dart';
import 'package:live_frontend/theme/app_text_styles.dart';

class SaeipToast extends StatelessWidget {
  final String message;

  const SaeipToast({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.1),
            offset: Offset(1, 1),
            blurRadius: 10,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Text(
        message,
        style: AppTextStyles.bodyRegular(context, color: Colors.black),
        textAlign: TextAlign.center,
      ),
    );
  }
}
