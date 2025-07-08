import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:live_frontend/theme/app_colors.dart';
import 'package:live_frontend/theme/app_text_styles.dart';
import 'package:live_frontend/widgets/saeip_app_bar.dart';
import 'package:markdown_widget/markdown_widget.dart';

class TermsDetailScreen extends StatefulWidget {
  final String path;
  final bool isChecked;
  const TermsDetailScreen({
    super.key,
    required this.path,
    this.isChecked = false,
  });

  @override
  State<TermsDetailScreen> createState() => _TermsDetailScreenState();
}

class _TermsDetailScreenState extends State<TermsDetailScreen> {
  late bool _isChecked;

  @override
  void initState() {
    super.initState();
    _isChecked = widget.isChecked;
  }

  void onChanged(bool? value) {
    setState(() {
      _isChecked = value ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    void onBack() {
      Navigator.of(context).pop(_isChecked);
    }

    return Scaffold(
      appBar: SaeipAppBar(title: '서비스 이용 약관', onBack: onBack),
      body: FutureBuilder<String>(
        future: rootBundle.loadString('assets/terms/${widget.path}'),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('불러오기 실패: ${snapshot.error}'));
          }
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Stack(
                children: [
                  // 마크다운 본문
                  Positioned.fill(
                    bottom: 80,
                    left: 0,
                    right: 0,
                    top: 0,
                    child: MarkdownWidget(data: snapshot.data!),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 96,
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
                      color: Colors.white,
                      child: Container(
                        width: double.infinity,
                        height: 48,
                        padding: const EdgeInsets.fromLTRB(16, 0, 4, 0),
                        decoration: BoxDecoration(
                          color: AppColors.blackBlack0,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              '약관 동의',
                              style: AppTextStyles.subtitleMedium(
                                context,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(
                              width: 48,
                              height: 48,
                              child: Center(
                                child: Transform.scale(
                                  scale: 32 / 18,
                                  child: Checkbox(
                                    value: _isChecked,
                                    onChanged: onChanged,
                                    activeColor: AppColors.greenNormal,
                                    checkColor: Colors.white,
                                    shape: const CircleBorder(),
                                    materialTapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                    visualDensity: VisualDensity.compact,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
