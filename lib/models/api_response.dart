import 'package:json_annotation/json_annotation.dart';
import 'package:live_frontend/models/api_error.dart';

part 'api_response.g.dart';

/// 백엔드 공통 응답 형태를 파싱할 수 있는 제네릭 클래스입니다.
/// 백엔드 공통 응답 형태: { success: bool, message: string, data: {...}, error: ... }
@JsonSerializable(genericArgumentFactories: true)
class ApiResponse<T> {
  final bool success;
  final String? message;
  final DateTime? timestamp;
  final T? data;
  final ApiError? error;

  ApiResponse({
    required this.success,
    this.message,
    this.timestamp,
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
