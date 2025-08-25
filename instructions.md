# Riverpod를 사용한 홈 화면 서버 연동 시뮬레이션 가이드

이 문서는 `lib/screens/home/home_screen.dart` 위젯이 실제 서버와 통신하는 것처럼 Riverpod를 사용하여 상태를 관리하는 방법을 안내합니다. 이 접근 방식은 UI와 비즈니스 로직을 분리하여 코드의 테스트 용이성과 유지보수성을 높입니다.

## 가이드 1: 비동기 데이터 가져오기 (GET 시뮬레이션)

### 목표

- `FutureProvider`를 사용하여 비동기 데이터(서버 응답)를 관리합니다.
- UI에서 Provider가 제공하는 데이터의 상태(`loading`, `data`, `error`)에 따라 적절한 위젯을 표시합니다.
- 실제 API 호출을 시뮬레이션하여 나중에 실제 네트워크 코드로 쉽게 교체할 수 있는 구조를 만듭니다.

---

### 단계별 지침

#### 1. 필요한 패키지 설치

Riverpod 관련 패키지가 설치되어 있는지 확인합니다. `pubspec.yaml` 파일에 다음 의존성이 추가되어 있어야 합니다. 코드 생성을 위해 `build_runner`도 필요합니다.

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_riverpod: ^2.5.1 # 버전은 프로젝트에 맞게 조정

dev_dependencies:
  build_runner: ^2.4.10 # 버전은 프로젝트에 맞게 조정
  riverpod_generator: ^2.4.0 # 버전은 프로젝트에 맞게 조정
```

터미널에서 아래 명령어를 실행하여 패키지를 설치하거나 업데이트할 수 있습니다.
```bash
flutter pub add flutter_riverpod
flutter pub add -d build_runner riverpod_generator
```

#### 2. Provider 생성

서버로부터 데이터를 가져오는 비동기 작업을 시뮬레이션하는 `FutureProvider`를 생성합니다.

1.  **`lib/providers/home_provider.dart`** 파일을 새로 만듭니다.
2.  아래 코드를 파일에 추가합니다.

    ```dart
    import 'package:riverpod_annotation/riverpod_annotation.dart';
    import 'package:live_frontend/models/my_mission_model.dart'; // 예시 모델

    part 'home_provider.g.dart';

    @riverpod
    Future<MyMission> homeData(HomeDataRef ref) async {
      // 서버 통신 시뮬레이션을 위해 1초 딜레이
      await Future.delayed(const Duration(seconds: 1));

      // 실제로는 여기서 http 요청으로 서버 데이터를 가져옵니다.
      // 지금은 가상의 데이터를 반환합니다.
      return MyMission(
        id: 1,
        missionId: 101,
        content: "오늘의 미션: 공원에서 30분 산책하기",
        isComplete: false,
      );
    }
    ```

3.  터미널에서 아래 명령어를 실행하여 `*.g.dart` 파일을 생성/업데이트합니다.

    ```bash
    dart run build_runner watch --delete-conflicting-outputs
    ```

#### 3. UI 위젯에서 Provider 사용

`home_screen.dart`에서 방금 만든 `homeDataProvider`를 사용하여 데이터를 화면에 표시합니다. `StatelessWidget`을 `ConsumerWidget`으로 변경하고 `ref.watch`를 사용합니다.

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:live_frontend/providers/home_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncHomeData = ref.watch(homeDataProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('홈')),
      body: asyncHomeData.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('에러 발생: $err')),
        data: (mission) {
          return Center(child: Text(mission.content));
        },
      ),
    );
  }
}
```

#### 4. `main.dart` 설정

애플리케이션 전체에서 Riverpod Provider를 사용하려면, 앱의 최상위 위젯을 `ProviderScope`로 감싸야 합니다.

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:live_frontend/app.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}
```

---
---

## 가이드 2: 사용자 액션으로 상태 변경하기 (POST/PATCH 시뮬레이션)

### 목표
- `CloverMissionList` 위젯에서 모달의 '시작' 버튼을 누르면, 특정 미션의 상태(`missionStatus`)를 `started`로 변경합니다.
- 이 변경은 서버에 요청을 보내는 것처럼 시뮬레이션되고, UI에 즉시 반영됩니다.
- 데이터를 가져오기만 하는 `FutureProvider`와 달리, 상태를 변경하는 로직을 포함하기 위해 `AsyncNotifier`를 사용합니다.

---

### 단계별 지침

#### 1. Provider를 `AsyncNotifier`로 전환

상태를 '변경'하는 메서드를 가지려면 `AsyncNotifier`가 필요합니다. `lib/providers/home_provider.dart`를 아래와 같이 수정하여 미션 목록 전체를 관리하고, 특정 미션의 상태를 변경하는 메서드를 추가합니다.

1.  **`lib/providers/home_provider.dart`** 파일의 내용을 아래 코드로 교체합니다.

    ```dart
    import 'package:riverpod_annotation/riverpod_annotation.dart';
    import 'package:live_frontend/models/clover_mission_model.dart';
    import 'package:live_frontend/models/mission_models.dart'; // MissionStatus enum

    part 'home_provider.g.dart';

    // AsyncNotifierProvider를 사용하도록 변경
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
              missionId: 101,
              missionTitle: '공원에서 30분 산책하기',
              missionStatus: MissionStatus.beforeStart,
              missionCategory: '건강',
              missionDifficulty: '쉬움',
              cloverType: CloverMissionType.timer),
          CloverMissionModel(
              userMissionId: 2,
              missionId: 102,
              missionTitle: '고양이 사진 찍기',
              missionStatus: MissionStatus.beforeStart,
              missionCategory: '재미',
              missionDifficulty: '보통',
              cloverType: CloverMissionType.photo),
        ];
      }

      // 미션 상태를 'started'로 변경하는 메서드 (PATCH 요청 시뮬레이션)
      Future<void> startMission(int userMissionId) async {
        // 현재 상태(미션 목록)를 가져옵니다.
        final currentState = state.valueOrNull;
        if (currentState == null) return;

        // 서버에 상태 변경을 요청하는 것처럼 0.5초 대기합니다.
        print('서버 요청: 미션 ID $userMissionId 를 "started"로 변경합니다.');
        await Future.delayed(const Duration(milliseconds: 500));
        print('서버 응답: 성공');

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
    }
    ```

2.  코드를 수정한 후, 터미널에서 **반드시 `build_runner`를 다시 실행**하여 `home_provider.g.dart` 파일을 업데이트합니다.

    ```bash
    dart run build_runner watch --delete-conflicting-outputs
    ```

#### 2. 위젯에서 상태 변경 액션 호출

`CloverMissionList` 위젯이 Provider로부터 직접 데이터를 받고, 모달의 `onConfirm` 액션이 `startMission` 메서드를 호출하도록 수정합니다.

1.  **`lib/screens/home/widgets/clover_mission_list.dart`** 파일을 `ConsumerWidget`으로 변경하고 아래와 같이 수정합니다.

    ```dart
    import 'package:flutter/material.dart';
    import 'package:flutter_riverpod/flutter_riverpod.dart'; // Riverpod import
    import 'package:live_frontend/models/clover_mission_model.dart';
    import 'package:live_frontend/providers/home_provider.dart'; // 수정한 Provider import
    // ... other imports

    // StatefulWidget/StatelessWidget -> ConsumerWidget 으로 변경
    class CloverMissionList extends ConsumerWidget {
      // 생성자에서 더 이상 missionList를 받지 않습니다.
      const CloverMissionList({super.key});

      @override
      Widget build(BuildContext context, WidgetRef ref) {
        // ref.watch로 Provider를 구독합니다. Provider의 상태가 바뀌면 위젯이 리빌드됩니다.
        final missionListAsync = ref.watch(cloverMissionNotifierProvider);

        // AsyncValue.when을 사용하여 로딩/에러/데이터 상태를 처리합니다.
        return missionListAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) => Center(child: Text('데이터 로딩 실패: $err')),
          data: (missions) {
            // 데이터가 성공적으로 로드되면 기존 UI 로직을 여기에 배치합니다.
            // ... (기존의 정렬 및 리스트 UI 구성 코드)
            // 예시:
            return ListView.builder(
              itemCount: missions.length,
              itemBuilder: (context, index) {
                final mission = missions[index];
                return MissionTile(
                  missionStatus: mission.missionStatus,
                  missionTitle: mission.missionTitle,
                  // ...
                  onTap: () => _onTap(context, ref, mission),
                  onCheckBoxTap: () => _onTap(context, ref, mission),
                );
              },
            );
          },
        );
      }

      void _onTap(BuildContext context, WidgetRef ref, CloverMissionModel mission) {
        showDialog(
          context: context,
          builder: (context) {
            return SaeipModal.image(
              title: mission.missionTitle,
              // ...
              onConfirm: () {
                // '시작' 버튼을 누르면 Provider의 메서드를 호출합니다.
                // ref.read는 버튼 클릭처럼 상태를 변경하는 액션을 트리거할 때 사용합니다.
                ref
                    .read(cloverMissionNotifierProvider.notifier)
                    .startMission(mission.userMissionId);

                Navigator.of(context).pop(); // 모달 닫기
                // 필요하다면 미션 화면으로 이동하는 로직을 여기에 추가
              },
              // ...
            );
          },
        );
      }
    }
    ```

### 최종 데이터 흐름

1.  **UI 액션**: 사용자가 `SaeipModal`의 '시작' 버튼을 누릅니다.
2.  **`ref.read`**: `onConfirm` 콜백이 `ref.read`를 통해 `CloverMissionNotifier`의 `startMission` 메서드를 호출합니다.
3.  **상태 변경 로직**: `startMission` 메서드가 실행되어 서버 요청을 시뮬레이션하고, 성공 시 내부 상태 `state`를 새로운 미션 목록(`AsyncData(...)`)으로 업데이트합니다.
4.  **`ref.watch`**: `CloverMissionList`의 `build` 메서드에 있는 `ref.watch`가 상태 변경을 감지합니다.
5.  **UI 리빌드**: `CloverMissionList` 위젯이 새로운 상태값(미션 목록)으로 리빌드되어, 변경된 미션의 `missionStatus`가 UI에 반영됩니다.