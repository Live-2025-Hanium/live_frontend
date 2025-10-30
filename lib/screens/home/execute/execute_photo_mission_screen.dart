import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:live_frontend/screens/home/execute/widgets/complete_modal.dart';
import 'package:live_frontend/screens/home/execute/widgets/execute_screen_template.dart';
import 'package:live_frontend/screens/home/execute/widgets/pause_modal.dart';

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
  File? _imageFile;
  bool _shown = false;

  Future<void> _takePhoto() async {
    final XFile? photo = await _picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 1024,
      maxHeight: 1024,
      imageQuality: 80,
    );

    if (photo != null) {
      setState(() {
        _imageFile = File(photo.path);
        _shown = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_imageFile != null && !_shown) {
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
    return ExecuteScreenTemplate(
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
    );
  }
}
