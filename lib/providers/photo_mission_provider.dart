import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';

/// This provider holds the image data and extension as a record.
/// It is used to pass the image from ExecutePhotoMissionScreen
/// to MissionRecordScreen in a web-compatible way.
final photoMissionImageProvider = StateProvider<(Uint8List, String)?>((ref) => null);
