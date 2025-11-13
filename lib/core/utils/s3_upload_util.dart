import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:live_frontend/core/controllers/presigned_url_controller.dart';
import 'package:live_frontend/core/repositories/presigned_url_repository.dart';
import 'package:live_frontend/providers/dio_provider.dart';
import 'package:uuid/uuid.dart';

/// Uploads image bytes to S3 by getting a presigned URL and then putting the data.
///
/// Returns the final access URL of the uploaded image, or null on failure.
Future<String?> uploadImageToS3({
  required WidgetRef ref,
  required Uint8List imageBytes,
  required String imageExtension, // e.g. 'jpg', 'png'
  required String domain, // e.g., 'PROFILE', 'PHOTO_MISSION'
}) async {
  try {
    // Manually instantiate repository and controller
    final presignedUrlRepository = PresignedUrlRepository(
      ref.read(dioProvider),
    );

    final presignedUrlController = PresignedUrlController(
      presignedUrlRepository,
    );

    // 1. Create a unique filename
    final fileName = '${const Uuid().v4()}.$imageExtension';

    // 2. Create presigned URL
    final presigned = await presignedUrlController.createPresignedUrl(
      fileName,
      'image/$imageExtension',
      domain,
    );

    if (presigned == null) {
      throw Exception('Failed to create presigned URL');
    }

    // 3. Upload image bytes using a new Dio instance with timeouts
    final dio = Dio(BaseOptions(
      connectTimeout: const Duration(seconds: 60),
      receiveTimeout: const Duration(seconds: 60),
      sendTimeout: const Duration(seconds: 60),
    ));
    await dio.put(
      presigned.uploadUrl,
      data: imageBytes,
      options: Options(
        headers: {
          Headers.contentLengthHeader: imageBytes.length,
          Headers.contentTypeHeader: 'image/$imageExtension',
        },
      ),
    );

    // 4. Return the access URL
    return presigned.accessUrl;
  } catch (e) {
    debugPrint('S3 Upload Error: $e');
    return null; // Return null on failure
  }
}
