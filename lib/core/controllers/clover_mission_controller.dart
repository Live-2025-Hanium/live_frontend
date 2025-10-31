import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:live_frontend/core/repositories/clover_mission_repository.dart';
import 'package:live_frontend/models/clover_mission_model.dart';
import 'package:live_frontend/models/mission_models.dart';

final cloverMissionControllerProvider = Provider<CloverMissionController>((
  ref,
) {
  final repository = ref.read(cloverMissionRepositoryProvider);
  return CloverMissionController(repository);
});

class CloverMissionController {
  final CloverMissionRepository _repository;

  CloverMissionController(this._repository);

  Future<List<CloverMissionModel>?> fetchMissions() async {
    return await _repository.getCloverMissions();
  }

  Future<void> updateMissionState(MissionStatus status, int missionId) async {
    await _repository.updateCloverMissionStatus(status, missionId);
  }

  Future<List<CloverMissionModel>?> fetchNewMissions() async {
    return await _repository.fetchNewMissions();
  }

  Future<CloverMissionDetailModel?> fetchCloverMissionDetail(
    int missionId,
  ) async {
    return await _repository.getCloverMissionDetail(missionId);
  }

  Future<void> submitCloverMissionFeedback(
    CloverMissionFeedbackModel feedback,
  ) async {
    await _repository.postCloverMissionFeedback(feedback);
  }
}
