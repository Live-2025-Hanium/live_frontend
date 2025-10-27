import 'package:json_annotation/json_annotation.dart';

part 'presigned_url_model.g.dart';

@JsonSerializable()
class PresignedUrlPayloadModel {
  final String fileName;
  final String contentType;
  final String uploadType;

  PresignedUrlPayloadModel({
    required this.fileName,
    required this.contentType,
    required this.uploadType,
  });

  factory PresignedUrlPayloadModel.fromJson(Map<String, dynamic> json) =>
      _$PresignedUrlPayloadModelFromJson(json);

  Map<String, dynamic> toJson() => _$PresignedUrlPayloadModelToJson(this);
}

@JsonSerializable()
class PresignedUrlModel {
  final String uploadUrl;
  final String s3Key;
  final String accessUrl;

  PresignedUrlModel({
    required this.uploadUrl,
    required this.s3Key,
    required this.accessUrl,
  });

  factory PresignedUrlModel.fromJson(Map<String, dynamic> json) =>
      _$PresignedUrlModelFromJson(json);

  Map<String, dynamic> toJson() => _$PresignedUrlModelToJson(this);

  PresignedUrlModel copyWith({
    String? uploadUrl,
    String? s3Key,
    String? accessUrl,
  }) {
    return PresignedUrlModel(
      uploadUrl: uploadUrl ?? this.uploadUrl,
      s3Key: s3Key ?? this.s3Key,
      accessUrl: accessUrl ?? this.accessUrl,
    );
  }
}
