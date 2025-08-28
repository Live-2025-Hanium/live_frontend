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
