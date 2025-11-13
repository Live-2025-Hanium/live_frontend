import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:live_frontend/core/controllers/my_mission_controller.dart';
import 'package:live_frontend/core/repositories/my_mission_repository.dart';
import 'package:live_frontend/models/my_mission_model.dart';

final myMissionControllerProvider = Provider<MyMissionController>((ref) {
  final repository = ref.watch(myMissionRepositoryProvider);
  return MyMissionController(repository);
});

final myMissionsProvider = FutureProvider.autoDispose<List<MyMissionModel>>((
  ref,
) {
  final controller = ref.watch(myMissionControllerProvider);
  return controller.fetchMyMissions();
});

final allMyMissionsProvider =
    FutureProvider.autoDispose<List<AllMyMissionsModel>?>((ref) {
      final controller = ref.watch(myMissionControllerProvider);
      return controller.fetchAllMyMissions();
    });
