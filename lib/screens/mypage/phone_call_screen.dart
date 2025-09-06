import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class PhoneCallScreen extends StatelessWidget {
  const PhoneCallScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Image.asset('assets/images/phone_call_mock.png'),
    );
  }
}
