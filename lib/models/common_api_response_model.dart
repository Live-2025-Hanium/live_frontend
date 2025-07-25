import 'package:json_annotation/json_annotation.dart';

part 'common_api_response_model.g.dart';

// Error 모델
@JsonSerializable()
class ApiError {
  final String code;
  final String message;

  ApiError({required this.code, required this.message});

  factory ApiError.fromJson(Map<String, dynamic> json) =>
      _$ApiErrorFromJson(json);
  Map<String, dynamic> toJson() => _$ApiErrorToJson(this);
}

// 전체 API Response 모델
@JsonSerializable(genericArgumentFactories: true)
class ApiResponse<T> {
  final String timestamp;
  final bool success;
  final String message;
  final T? data;
  final ApiError? error;

  ApiResponse({
    required this.timestamp,
    required this.success,
    required this.message,
    this.data,
    this.error,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) => _$ApiResponseFromJson(json, fromJsonT);

  Map<String, dynamic> toJson(Object? Function(T value) toJsonT) =>
      _$ApiResponseToJson(this, toJsonT);
}
