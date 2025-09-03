import 'package:json_annotation/json_annotation.dart';

part 'common_api_response_model.g.dart';

// Error 모델
@JsonSerializable()
class ApiErrorModel {
  final String code;
  final String message;

  ApiErrorModel({required this.code, required this.message});

  factory ApiErrorModel.fromJson(Map<String, dynamic> json) =>
      _$ApiErrorModelFromJson(json);
  Map<String, dynamic> toJson() => _$ApiErrorModelToJson(this);
}

// 전체 API Response 모델
@JsonSerializable(genericArgumentFactories: true)
class ApiResponseModel<T> {
  final String timestamp;
  final bool success;
  final String message;
  final T? data;
  final ApiErrorModel? error;

  ApiResponseModel({
    required this.timestamp,
    required this.success,
    required this.message,
    this.data,
    this.error,
  });

  factory ApiResponseModel.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) => _$ApiResponseModelFromJson(json, fromJsonT);

  Map<String, dynamic> toJson(Object? Function(T value) toJsonT) =>
      _$ApiResponseModelToJson(this, toJsonT);
}
