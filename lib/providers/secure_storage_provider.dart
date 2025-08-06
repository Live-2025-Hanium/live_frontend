import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/storage/secure_storage.dart';

final secureStorageProvider = Provider((_) => SecureStorage());
