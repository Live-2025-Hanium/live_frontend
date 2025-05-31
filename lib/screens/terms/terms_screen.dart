import 'package:flutter/material.dart';
import 'package:live_frontend/theme/app_text_styles.dart';
import 'package:live_frontend/theme/app_colors.dart';

class TermsScreen extends StatefulWidget {
  @override
  _TermsScreenState createState() => _TermsScreenState();
}

class _TermsScreenState extends State<TermsScreen> {
  bool agreedToAll = false;
  bool agreedToService = false;
  bool agreedToPrivacy = false;
  bool isOlderThen14 = false;
  bool agreedToThirdParty = false;

  String userName = "유저"; // Replace with actual user name

  void updateAll(bool? value) {
    setState(() {
      agreedToAll = value ?? false;
      agreedToService = value ?? false;
      agreedToPrivacy = value ?? false;
      isOlderThen14 = value ?? false;
      agreedToThirdParty = value ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('이용 약관')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "$userName 님, 반갑습니다!",
              style: AppTextStyles.titleMedium(context, color: Colors.black),
            ),
            SizedBox(height: 8.0),
            Text(
              "Live 서비스 시작을 위해 \n아래 이용 약관을 확인해주세요.",
              style: AppTextStyles.subtitleMedium(
                context,
                color: AppColors.blackBlack4,
              ),
            ),
            SizedBox(height: 16.0),
            Padding(
              padding: EdgeInsets.only(
                left: 4.0,
                right: 0,
                top: 12.0,
                bottom: 12.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("전체 동의", style: AppTextStyles.bodyMedium(context)),
                  Checkbox(value: agreedToAll, onChanged: updateAll),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
