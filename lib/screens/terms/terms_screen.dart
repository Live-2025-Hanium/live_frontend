import 'package:flutter/material.dart';
import 'package:live_frontend/screens/terms/widgets/term.dart';
import 'package:live_frontend/theme/app_text_styles.dart';
import 'package:live_frontend/theme/app_colors.dart';

class Agreement {
  final String label;
  bool agreed;

  Agreement(this.label, {this.agreed = false});
}

class TermsScreen extends StatefulWidget {
  @override
  TermsScreenState createState() => TermsScreenState();
}

class TermsScreenState extends State<TermsScreen> {
  bool agreedToAll = false;

  String userName = "유저"; // Replace with actual user name

  List<Agreement> terms = [
    Agreement("서비스 이용 약관 (필수)"),
    Agreement("개인정보 처리 방침 (필수)"),
    Agreement("14세 이상 확인 (필수)"),
    Agreement("제3자 정보 제공 동의 (선택)"),
  ];

  void updateAll(bool? value) {
    setState(() {
      agreedToAll = value ?? false;
      terms =
          terms
              .map((term) => Agreement(term.label, agreed: agreedToAll))
              .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('이용 약관')),
      body: Padding(
        padding: EdgeInsets.only(
          left: 20.0,
          right: 8.0,
          top: 4.0,
          bottom: 40.0,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "$userName 님, 반갑습니다!",
                  style: AppTextStyles.titleMedium(
                    context,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 8.0),
                Text(
                  "Live 서비스 시작을 위해 \n아래 이용 약관을 확인해주세요.",
                  style: AppTextStyles.subtitleMedium(
                    context,
                    color: AppColors.blackBlack4,
                  ),
                ),
                SizedBox(height: 44.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "전체 동의",
                      style: AppTextStyles.subtitleMedium(
                        context,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(
                      height: 48,
                      width: 48,
                      child: Transform.scale(
                        scale: 32 / 18,
                        child: Checkbox(
                          value: agreedToAll,
                          onChanged: updateAll,
                          activeColor: AppColors.greenNormal,
                          checkColor: Colors.white,
                          shape: const CircleBorder(
                            side: BorderSide(color: AppColors.greenNormal),
                          ),
                          visualDensity: VisualDensity.compact,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.0),
                Divider(color: AppColors.greenLightActive, thickness: 1.0),
                SizedBox(height: 12.0),
                Column(
                  children:
                      terms.map((term) {
                        return Term(
                          title: term.label,
                          description: "자세히 보기",
                          isChecked: term.agreed,
                          onChanged: (value) {
                            setState(() {
                              term.agreed = value ?? false;
                              agreedToAll = terms.every((t) => t.agreed);
                            });
                          },
                        );
                      }).toList(),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(right: 12.0),
              child: ElevatedButton(
                onPressed:
                    agreedToAll
                        ? () {
                          // Handle agreement submission
                          //   Navigator.pop(context);
                        }
                        : null,
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  backgroundColor:
                      agreedToAll ? AppColors.greenDark : AppColors.blackBlack2,
                ),
                child: Text(
                  "다음",
                  style: AppTextStyles.subtitleSemibold(
                    context,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
