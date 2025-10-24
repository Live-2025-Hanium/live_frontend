import 'package:live_frontend/core/repositories/presigned_url_repository.dart';
import 'package:live_frontend/models/presigned_url_model.dart';

class PresignedUrlController {
  final PresignedUrlRepository _presignedUrlRepository;

  PresignedUrlController(this._presignedUrlRepository);

  Future<PresignedUrlModel?> createPresignedUrl(
    String fileName,
    String contentType,
    String uploadType,
  ) async {
    try {
      final presignedUrl = await _presignedUrlRepository.createPresignedUrl(
        fileName,
        contentType,
        uploadType,
      );
      return presignedUrl;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> uploadImage(String filePath, PresignedUrlModel presigned) async {
    try {
      await _presignedUrlRepository.uploadImage(filePath, presigned);
    } catch (e) {
      rethrow;
    }
  }
}
