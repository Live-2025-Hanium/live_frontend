import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:live_frontend/models/mission_models.dart';
import 'package:live_frontend/theme/app_colors.dart';
import 'package:live_frontend/theme/app_text_styles.dart';

class MissionTile extends StatefulWidget {
  final MissionStatus missionStatus;
  final String missionTitle;
  final Widget subContent;

  const MissionTile({
    super.key,
    required this.missionStatus,
    required this.missionTitle,
    required this.subContent,
  });

  @override
  State<MissionTile> createState() => _MissionTileState();
}

class _MissionTileState extends State<MissionTile> {
  bool isCompleted = false;

  @override
  void initState() {
    super.initState();
    isCompleted = widget.missionStatus == MissionStatus.completed;
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
      ),
      child: InkWell(
        // 클릭 기능
        onTap:
            isCompleted
                ? null // disabled 처리
                : () {
                  // 다른 페이지로 이동
                },
        borderRadius: BorderRadius.circular(8),
        child: IntrinsicHeight(
          child: Row(
            children: [
              // 왼쪽 선
              Container(
                width: 4,
                decoration: BoxDecoration(
                  color:
                      isCompleted
                          ? AppColors.blackBlack3
                          : AppColors.greenNormal,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              // 내용 영역
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    left: 20,
                    right: 12,
                    top: 16,
                    bottom: 16,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.missionTitle,
                              style: AppTextStyles.bodyRegular(context),
                            ),
                            SizedBox(height: 4),
                            widget.subContent,
                          ],
                        ),
                      ),
                      // 체크박스 (클릭 이벤트 분리)
                      GestureDetector(
                        onTap:
                            isCompleted
                                ? null
                                : () {
                                  // 완료 모달 띄우기
                                  _showCompletionModal();
                                },
                        child: SizedBox(
                          height: 48,
                          width: 48,
                          child: Transform.scale(
                            scale: 28 / 18,
                            child: Checkbox(
                              value: isCompleted,
                              onChanged: null, // GestureDetector로 처리
                              activeColor: AppColors.greenNormal,
                              checkColor: Colors.white,
                              shape: const CircleBorder(
                                side: BorderSide(color: AppColors.greenNormal),
                              ),
                              visualDensity: VisualDensity.compact,
                            ),
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
    );
  }

  // 완료 모달 함수
  void _showCompletionModal() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('미션 완료'),
          content: Text('미션을 완료하시겠습니까?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('취소'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  isCompleted = true;
                });
                Navigator.of(context).pop();
              },
              child: Text('완료'),
            ),
          ],
        );
      },
    );
  }
}
