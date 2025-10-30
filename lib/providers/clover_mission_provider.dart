import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:live_frontend/core/controllers/clover_mission_controller.dart';
import 'package:live_frontend/models/clover_mission_model.dart';
import 'package:live_frontend/models/mission_models.dart';

final cloverMissionProvider =
    FutureProvider.family<List<CloverMissionModel>?, void>((ref, _) {
      final controller = ref.read(cloverMissionControllerProvider);
      return controller.fetchMissions();
    });

final cloverMissionStateUpdateProvider =
    FutureProvider.family<void, Map<String, dynamic>>((ref, payload) {
      final controller = ref.read(cloverMissionControllerProvider);
      final status = payload['status'] as MissionStatus;
      final missionId = payload['missionId'] as int;
      return controller.updateMissionState(status, missionId);
    });

final newCloverMissionProvider =
    FutureProvider.family<List<CloverMissionModel>?, void>((ref, _) {
      final controller = ref.read(cloverMissionControllerProvider);
      return controller.fetchNewMissions();
    });

final cloverMissionDetailProvider =
    FutureProvider.family<CloverMissionDetailModel?, int>((ref, missionId) {
      final controller = ref.read(cloverMissionControllerProvider);
      return controller.fetchCloverMissionDetail(missionId);
    });
