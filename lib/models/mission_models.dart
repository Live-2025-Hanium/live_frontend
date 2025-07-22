import 'package:json_annotation/json_annotation.dart';

// TODO : 실제 api 연결시 모델 추가 필요

// ASSIGNED~PAUSED : 녹색
// COMPLETED : 회색
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

@JsonEnum(alwaysCreate: true)
enum MissionDifficulty {
  @JsonValue('VERY_EASY')
  veryEasy(1),

  @JsonValue('EASY')
  easy(2),

  @JsonValue('NORMAL')
  normal(3),

  @JsonValue('HARD')
  hard(4),

  @JsonValue('VERY_HARD')
  veryHard(5);

  final int value;
  const MissionDifficulty(this.value);
}
