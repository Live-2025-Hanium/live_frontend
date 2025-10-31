import 'package:flutter/material.dart';
import 'package:live_frontend/models/mission_models.dart';
import 'package:live_frontend/theme/app_colors.dart';
import 'package:live_frontend/theme/app_text_styles.dart';

class MissionTile extends StatefulWidget {
  final MissionStatus missionStatus;
  final String missionTitle;
  final Widget? subContent;
  final VoidCallback onTap;
  final VoidCallback onCheckBoxTap;

  const MissionTile({
    super.key,
    required this.missionStatus,
    required this.missionTitle,
    this.subContent,
    required this.onTap,
    required this.onCheckBoxTap,
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
  void didUpdateWidget(covariant MissionTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.missionStatus != widget.missionStatus) {
      setState(() {
        isCompleted = widget.missionStatus == MissionStatus.completed;
      });
    }
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.white),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          // 클릭 기능
          onTap: isCompleted
              ? null // disabled 처리
              : () => widget.onTap(),
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
                                widget.missionTitle,
                                style: AppTextStyles.bodyRegular(context),
                              ),
                              SizedBox(height: 4),
                              if (widget.subContent != null) widget.subContent!,
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: isCompleted
                              ? null
                              : () {
                                  widget.onCheckBoxTap();
                                },
                          child: SizedBox(
                            height: 48,
                            width: 48,
                            child: Switch(
                              value: isCompleted,
                              onChanged: isCompleted
                                  ? null
                                  : (value) {
                                      widget.onCheckBoxTap();
                                    },
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
