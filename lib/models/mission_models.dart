import 'package:json_annotation/json_annotation.dart';

// 기존 enum들
enum MissionStatus {
  @JsonValue('ASSIGNED')
  assigned,
  @JsonValue('STARTED')
  started,
  @JsonValue('PAUSED')
  paused,
  @JsonValue('COMPLETED')
  completed,
  @JsonValue('SKIPPED')
  skipped,
}

extension MissionStatusExtension on MissionStatus {
  String get label {
    switch (this) {
      case MissionStatus.assigned:
        return 'assign';
      case MissionStatus.started:
        return 'start';
      case MissionStatus.paused:
        return 'pause';
      case MissionStatus.completed:
        return 'complete';
      case MissionStatus.skipped:
        return 'skip';
    }
  }
}
