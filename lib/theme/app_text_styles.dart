import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

double responsiveFont(double base, {required double min, required double max}) {
  final scaled = base.sp;
  return scaled.clamp(min, max);
}

class AppTextStyles {
  static TextStyle titleSemibold(BuildContext context) => TextStyle(
    fontFamily: 'Pretendard',
    fontSize: responsiveFont(22, min: 18, max: 28),
    fontWeight: FontWeight.w600,
    height: 32 / 22,
    letterSpacing: 0,
  );

  static TextStyle titleMedium(BuildContext context) => TextStyle(
    fontFamily: 'Pretendard',
    fontSize: responsiveFont(22, min: 18, max: 28),
    fontWeight: FontWeight.w500,
    height: 32 / 22,
    letterSpacing: 0,
  );

  static TextStyle subtitleSemibold(BuildContext context) => TextStyle(
    fontFamily: 'Pretendard',
    fontSize: responsiveFont(18, min: 16, max: 24),
    fontWeight: FontWeight.w600,
    height: 24 / 18,
    letterSpacing: 0,
  );

  static TextStyle subtitleMedium(BuildContext context) => TextStyle(
    fontFamily: 'Pretendard',
    fontSize: responsiveFont(18, min: 16, max: 24),
    fontWeight: FontWeight.w500,
    height: 24 / 18,
    letterSpacing: 0,
  );

  static TextStyle bodySemibold(BuildContext context) => TextStyle(
    fontFamily: 'Pretendard',
    fontSize: responsiveFont(15, min: 12, max: 22),
    fontWeight: FontWeight.w600,
    height: 20 / 15,
    letterSpacing: 0,
  );

  static TextStyle bodyMedium(BuildContext context) => TextStyle(
    fontFamily: 'Pretendard',
    fontSize: responsiveFont(15, min: 12, max: 22),
    fontWeight: FontWeight.w500,
    height: 20 / 15,
    letterSpacing: 0,
  );

  static TextStyle bodyRegular(BuildContext context) => TextStyle(
    fontFamily: 'Pretendard',
    fontSize: responsiveFont(15, min: 12, max: 22),
    fontWeight: FontWeight.w400,
    height: 20 / 15,
    letterSpacing: 0,
  );

  static TextStyle smallSemibold(BuildContext context) => TextStyle(
    fontFamily: 'Pretendard',
    fontSize: responsiveFont(12, min: 10, max: 18),
    fontWeight: FontWeight.w600,
    height: 16 / 12,
    letterSpacing: 0,
  );

  static TextStyle smallMedium(BuildContext context) => TextStyle(
    fontFamily: 'Pretendard',
    fontSize: responsiveFont(12, min: 10, max: 18),
    fontWeight: FontWeight.w500,
    height: 16 / 12,
    letterSpacing: 0,
  );

  static TextStyle tinyMedium(BuildContext context) => TextStyle(
    fontFamily: 'Pretendard',
    fontSize: responsiveFont(10, min: 8, max: 14),
    fontWeight: FontWeight.w500,
    height: 16 / 10,
    letterSpacing: 0,
  );
}
