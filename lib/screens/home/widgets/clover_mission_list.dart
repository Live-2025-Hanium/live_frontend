import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:live_frontend/models/mission_models.dart';
import 'package:live_frontend/screens/home/widgets/clover_sub_content.dart';
import 'package:live_frontend/screens/home/widgets/mission_tile.dart';
import 'package:live_frontend/theme/app_text_styles.dart';

class CloverMissionList extends StatelessWidget {
  final List<Mission> missions;
  const CloverMissionList({super.key, required this.missions});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Clover',
            style: AppTextStyles.titleMedium(context, color: Colors.black),
          ),
          ...missions.map((mission) {
            return Column(
              children: [
                MissionTile(
                  missionStatus: mission.missionStatus,
                  missionTitle: mission.title,
                  subContent: CloverSubContent(
                    category: mission.missionCategory,
                    difficulty: mission.missionDifficulty,
                  ),
                ),
                Gap(8),
              ],
            );
          }).toList(),
        ],
      ),
    );
  }
}
