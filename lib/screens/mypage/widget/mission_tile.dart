import 'package:flutter/material.dart';
import 'package:live_frontend/theme/app_colors.dart';
import 'package:live_frontend/theme/app_text_styles.dart';

class MissionTile extends StatelessWidget {
  final bool active;
  final String missionTitle;
  final Widget? child;
  final VoidCallback onTap;
  final VoidCallback onCheckBoxTap;

  const MissionTile({
    super.key,
    required this.active,
    required this.missionTitle,
    this.child,
    required this.onTap,
    required this.onCheckBoxTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.white),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          // 클릭 기능
          onTap: onTap,
          child: IntrinsicHeight(
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: 20,
                      right: 20,
                      top: 16,
                      bottom: 16,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                missionTitle,
                                style: AppTextStyles.bodyRegular(context),
                              ),
                              SizedBox(height: 4),
                              if (child != null) child!,
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: onCheckBoxTap,
                          child: SizedBox(
                            height: 48,
                            width: 48,
                            child: Switch(
                              value: active,
                              onChanged: (value) {
                                onCheckBoxTap();
                              },
                              inactiveTrackColor: AppColors.blackBlack2,
                              inactiveThumbColor: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
