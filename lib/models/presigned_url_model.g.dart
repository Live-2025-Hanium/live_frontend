// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'presigned_url_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PresignedUrlPayloadModel _$PresignedUrlPayloadModelFromJson(
  Map<String, dynamic> json,
) => PresignedUrlPayloadModel(
  fileName: json['fileName'] as String,
  contentType: json['contentType'] as String,
  uploadType: json['uploadType'] as String,
);

Map<String, dynamic> _$PresignedUrlPayloadModelToJson(
  PresignedUrlPayloadModel instance,
) => <String, dynamic>{
  'fileName': instance.fileName,
  'contentType': instance.contentType,
  'uploadType': instance.uploadType,
};

PresignedUrlModel _$PresignedUrlModelFromJson(Map<String, dynamic> json) =>
    PresignedUrlModel(
      uploadUrl: json['uploadUrl'] as String,
      s3Key: json['s3Key'] as String,
      accessUrl: json['accessUrl'] as String,
    );

Map<String, dynamic> _$PresignedUrlModelToJson(PresignedUrlModel instance) =>
    <String, dynamic>{
      'uploadUrl': instance.uploadUrl,
      's3Key': instance.s3Key,
      'accessUrl': instance.accessUrl,
    };
