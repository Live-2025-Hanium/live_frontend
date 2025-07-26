import 'package:json_annotation/json_annotation.dart';

// TODO : 이후 클로버미션, 마이미션 분리 필요

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
