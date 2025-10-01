import 'package:live_frontend/core/repositories/my_mission_repository.dart';
import 'package:live_frontend/models/my_mission_model.dart';

class MyMissionController {
  final MyMissionRepository _repository;

  MyMissionController(this._repository);

  Future<List<MyMissionModel>> fetchMyMissions() {
    return _repository.fetchMyMissions();
  }

  Future<void> addMyMission(MyMissionAddPayloadModel mission) {
    return _repository.addMyMission(mission);
  }

  Future<void> completeMyMission(int userMissionId) {
    return _repository.completeMyMission(userMissionId);
  }
}
