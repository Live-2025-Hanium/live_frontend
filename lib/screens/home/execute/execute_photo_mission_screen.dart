import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:live_frontend/providers/photo_mission_provider.dart';
import 'package:live_frontend/screens/home/execute/widgets/complete_modal.dart';
import 'package:live_frontend/screens/home/execute/widgets/execute_screen_template.dart';
import 'package:live_frontend/screens/home/execute/widgets/pause_modal.dart';
import 'package:live_frontend/widgets/saeip_app_bar.dart';
import 'package:path/path.dart' as p;

class ExecutePhotoMissionScreen extends ConsumerStatefulWidget {
  const ExecutePhotoMissionScreen({super.key, required this.id});

  final int id;
  @override
  ConsumerState<ExecutePhotoMissionScreen> createState() =>
      _ExecutePhotoMissionScreenState();
}

class _ExecutePhotoMissionScreenState
    extends ConsumerState<ExecutePhotoMissionScreen> {
  final ImagePicker _picker = ImagePicker();
  Uint8List? _imageBytes;
  bool _shown = false;

  Future<void> _takePhoto() async {
    final XFile? photo = await _picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 1024,
      maxHeight: 1024,
      imageQuality: 80,
    );

    if (photo != null) {
      final imageBytes = await photo.readAsBytes();
      final imageExtension = p.extension(photo.name).replaceAll('.', '');
      ref.read(photoMissionImageProvider.notifier).state = (
        imageBytes,
        imageExtension
      );
      setState(() {
        _imageBytes = imageBytes;
        _shown = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_imageBytes != null && !_shown) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _shown = true;
        showDialog(
          context: context,
          builder: (context) {
            return CompleteModal(userMissionId: widget.id);
          },
        );
      });
    }
    return Scaffold(
      appBar: SaeipAppBar(title: '미션 수행'),
      body: ExecuteScreenTemplate(
        imagePath: 'assets/images/clover_mission/photo.png',
        onLeftPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return PauseModal(userMissionId: widget.id);
            },
          );
        },
        rightLabel: '인증샷 촬영',
        onRightPressed: _takePhoto,
        missionTitle: '사진 미션',
      ),
    );
  }
}
