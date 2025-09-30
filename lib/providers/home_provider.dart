import 'package:flutter/material.dart';
import 'package:live_frontend/models/clover_mission_model.dart';
import 'package:live_frontend/models/common_api_response_model.dart';
import 'package:live_frontend/models/mission_models.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:live_frontend/providers/dio_provider.dart';
part 'home_provider.g.dart';

@riverpod
class CloverMissionNotifier extends _$CloverMissionNotifier {
  // build 메서드는 Provider의 초기 상태를 설정합니다. (GET 요청 시뮬레이션)
  @override
  Future<List<CloverMissionModel>> build() async {
    await Future.delayed(const Duration(seconds: 1));
    // 실제 앱에서는 여기서 서버로부터 전체 미션 목록을 가져옵니다.
    return [
      CloverMissionModel(
        userMissionId: 1,
        missionTitle: '공원에서 30분 산책하기',
        missionStatus: MissionStatus.assigned,
        missionCategory: CloverMissionCategory.health,
        missionDifficulty: CloverMissionDifficulty.easy,
        cloverType: CloverMissionType.timer,
      ),
      CloverMissionModel(
        userMissionId: 2,
        missionTitle: '10분간 환기하기',
        missionStatus: MissionStatus.assigned,
        missionCategory: CloverMissionCategory.hobby,
        missionDifficulty: CloverMissionDifficulty.normal,
        cloverType: CloverMissionType.timer,
      ),
      CloverMissionModel(
        userMissionId: 3,
        missionTitle: '10분간 환기하기',
        missionStatus: MissionStatus.assigned,
        missionCategory: CloverMissionCategory.hobby,
        missionDifficulty: CloverMissionDifficulty.normal,
        cloverType: CloverMissionType.timer,
      ),
    ];
  }

  // 미션 상태를 'started'로 변경하는 메서드 (PATCH 요청 시뮬레이션)
  Future<void> startMission(int userMissionId) async {
    // 현재 상태(미션 목록)를 가져옵니다.
    final currentState = state.valueOrNull;
    if (currentState == null) return;

    // 서버에 상태 변경을 요청하는 것처럼 0.5초 대기합니다.
    debugPrint('서버 요청: 미션 ID $userMissionId 를 "started"로 변경합니다.');
    await Future.delayed(const Duration(milliseconds: 500));
    debugPrint('서버 응답: 성공');

    // 요청이 성공했다고 가정하고, 로컬 상태를 업데이트합니다.
    // state를 새로운 값으로 업데이트하면, 이를 watch하는 모든 위젯이 리빌드됩니다.
    state = AsyncData([
      for (final mission in currentState)
        // ID가 일치하는 미션을 찾으면
        if (mission.userMissionId == userMissionId)
          // missionStatus를 변경한 새로운 객체를 만들어 리스트에 추가합니다.
          mission.copyWith(missionStatus: MissionStatus.started)
        else
          // 다른 미션들은 그대로 둡니다.
          mission,
    ]);
  }

  // 미션 상태를 'paused'로 변경하는 메서드 (PATCH 요청 시뮬레이션)
  Future<void> pauseMission(int userMissionId) async {
    // 현재 상태(미션 목록)를 가져옵니다.
    final currentState = state.valueOrNull;
    if (currentState == null) return;

    // 서버에 상태 변경을 요청하는 것처럼 0.5초 대기합니다.
    debugPrint('서버 요청: 미션 ID $userMissionId 를 "paused"로 변경합니다.');
    await Future.delayed(const Duration(milliseconds: 500));
    debugPrint('서버 응답: 성공');

    // 요청이 성공했다고 가정하고, 로컬 상태를 업데이트합니다.
    // state를 새로운 값으로 업데이트하면, 이를 watch하는 모든 위젯이 리빌드됩니다.
    state = AsyncData([
      for (final mission in currentState)
        // ID가 일치하는 미션을 찾으면
        if (mission.userMissionId == userMissionId)
          // missionStatus를 변경한 새로운 객체를 만들어 리스트에 추가합니다.
          mission.copyWith(missionStatus: MissionStatus.paused)
        else
          // 다른 미션들은 그대로 둡니다.
          mission,
    ]);
  }

  // 미션 상태를 'complete'로 변경하는 메서드 (PATCH 요청 시뮬레이션)
  Future<void> completeMission(int userMissionId) async {
    // 현재 상태(미션 목록)를 가져옵니다.
    final currentState = state.valueOrNull;
    if (currentState == null) return;

    // 서버에 상태 변경을 요청하는 것처럼 0.5초 대기합니다.
    debugPrint('서버 요청: 미션 ID $userMissionId 를 "complete"로 변경합니다.');
    await Future.delayed(const Duration(milliseconds: 500));
    debugPrint('서버 응답: 성공');

    // 요청이 성공했다고 가정하고, 로컬 상태를 업데이트합니다.
    // state를 새로운 값으로 업데이트하면, 이를 watch하는 모든 위젯이 리빌드됩니다.
    state = AsyncData([
      for (final mission in currentState)
        // ID가 일치하는 미션을 찾으면
        if (mission.userMissionId == userMissionId)
          // missionStatus를 변경한 새로운 객체를 만들어 리스트에 추가합니다.
          mission.copyWith(missionStatus: MissionStatus.completed)
        else
          // 다른 미션들은 그대로 둡니다.
          mission,
    ]);
  }

  // 현재 전역으로 관리되는 미션 목록에서 ID로 특정 미션을 반환합니다.
  // 찾지 못하면 null을 반환합니다.
  CloverMissionModel? getMissionById(int userMissionId) {
    final currentState = state.valueOrNull;
    if (currentState == null) return null;
    try {
      return currentState.firstWhere((m) => m.userMissionId == userMissionId);
    } catch (_) {
      return null;
    }
  }

  // 특정 미션의 상세 정보를 서버에서 불러오는 시뮬레이션 메서드.
  // 실제 앱에서는 여기서 API를 호출해 상세 필드를 받아옵니다.
  Future<CloverMissionDetailModel?> fetchMissionDetail(
    int userMissionId,
  ) async {
    final base = getMissionById(userMissionId);
    if (base == null) return null;

    // 서버 요청 시뮬레이션
    await Future.delayed(const Duration(milliseconds: 400));

    // 예시: 기본 정보에 remainingTime, targetAddress 등의 필드를 추가한 상세 모델을 반환
    return CloverMissionDetailModel(
      userMissionId: base.userMissionId,
      cloverType: base.cloverType,
      missionTitle: base.missionTitle,
      missionStatus: base.missionStatus,
      missionDifficulty: base.missionDifficulty,
      missionCategory: base.missionCategory,
      // 샘플 값 — 실제 정보는 서버 응답을 사용하세요.
      remainingTime: const Duration(minutes: 30),
      targetAddress: null,
      remainingDistance: null,
    );
  }

  // 새로운 미션을 추가하는 메서드. (GET 요청 시뮬레이션)
  Future<List<CloverMissionModel>> addMission() async {
    // 현재 상태(미션 목록)를 가져옵니다.
    final currentState = state.valueOrNull;
    if (currentState == null) return [];

    // 서버에 새로운 미션 추가를 요청하는 것처럼 0.5초 대기합니다.
    debugPrint('서버 요청: 새로운 미션을 추가합니다.');
    await Future.delayed(const Duration(milliseconds: 500));
    debugPrint('서버 응답: 성공');

    // 요청이 성공했다고 가정하고, 로컬 상태를 업데이트합니다.
    // state를 새로운 값으로 업데이트하면, 이를 watch하는 모든 위젯이 리빌드됩니다.

    List<CloverMissionModel> newMission = [
      CloverMissionModel(
        userMissionId: 4,
        missionTitle: '공원에서 30분 산책하기',
        missionStatus: MissionStatus.assigned,
        missionCategory: CloverMissionCategory.health,
        missionDifficulty: CloverMissionDifficulty.easy,
        cloverType: CloverMissionType.timer,
      ),
      CloverMissionModel(
        userMissionId: 5,
        missionTitle: '공원에서 30분 산책하기',
        missionStatus: MissionStatus.assigned,
        missionCategory: CloverMissionCategory.health,
        missionDifficulty: CloverMissionDifficulty.easy,
        cloverType: CloverMissionType.timer,
      ),
      CloverMissionModel(
        userMissionId: 6,
        missionTitle: '공원에서 30분 산책하기',
        missionStatus: MissionStatus.assigned,
        missionCategory: CloverMissionCategory.health,
        missionDifficulty: CloverMissionDifficulty.easy,
        cloverType: CloverMissionType.timer,
      ),
    ];

    state = AsyncData([...currentState, ...newMission]);

    return newMission;
  }
}
