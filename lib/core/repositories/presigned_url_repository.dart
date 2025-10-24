import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:live_frontend/models/common_api_response_model.dart';
import 'package:live_frontend/models/presigned_url_model.dart';

class PresignedUrlRepository {
  final Dio _dio;

  PresignedUrlRepository(this._dio);

  Future<PresignedUrlModel?> createPresignedUrl(
    String fileName,
    String contentType,
    String uploadType,
  ) async {
    // Implement the logic to create a presigned URL
    try {
      final body = {
        'fileName': fileName,
        'contentType': contentType,
        'uploadType': uploadType,
      };
      debugPrint('PresignedUrlRepository - createPresignedUrl - body: $body');
      final response = await _dio.post(
        '/api/storage/presigned-url',
        data: body,
      );

      final apiResponse = ApiResponseModel<PresignedUrlModel>.fromJson(
        response.data as Map<String, dynamic>,
        (json) => PresignedUrlModel.fromJson(json as Map<String, dynamic>),
      );
      return apiResponse.data;
    } catch (e) {
      return null;
    }
  }

  Future<void> uploadImage(
    String filePath,
    String fileType,
    PresignedUrlModel presigned,
  ) async {
    try {
      final dio = Dio();
      final fileBytes = await MultipartFile.fromFile(filePath);
      await dio.put(
        presigned.uploadUrl,
        data: fileBytes,
        options: Options(headers: {'Content-Type': 'image/$fileType'}),
      );
    } catch (e) {
      rethrow;
    }
  }
}
