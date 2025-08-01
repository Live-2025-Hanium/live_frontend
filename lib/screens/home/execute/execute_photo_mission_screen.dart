import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:live_frontend/screens/home/execute/widgets/execute_screen_template.dart';
import 'package:live_frontend/screens/home/execute/widgets/pause_modal.dart';

class ExecutePhotoMissionScreen extends StatefulWidget {
  const ExecutePhotoMissionScreen({super.key, required this.id});

  final int id;
  @override
  State<ExecutePhotoMissionScreen> createState() =>
      _ExecutePhotoMissionScreenState();
}

class _ExecutePhotoMissionScreenState extends State<ExecutePhotoMissionScreen> {
  final ImagePicker _picker = ImagePicker();
  File? _imageFile;

  Future<void> _takePhoto() async {
    final XFile? photo = await _picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 1024, // (선택) 리사이즈
      maxHeight: 1024, // (선택) 리사이즈
      imageQuality: 80, // (선택) 압축 퀄리티 (0-100)
    );

    if (photo != null) {
      setState(() {
        _imageFile = File(photo.path);
      });
      // 이후 백엔드에 이미지 전송
      // 예: await uploadImage(_imageFile);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_imageFile != null) {
      if (GoRouter.of(context).canPop()) {
        context.pop();
      }
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
