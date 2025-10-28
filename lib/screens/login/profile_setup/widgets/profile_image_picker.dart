import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:live_frontend/providers/auth_provider.dart';
import 'package:image_picker/image_picker.dart';

class ProfileImagePicker extends ConsumerStatefulWidget {
  const ProfileImagePicker({super.key, this.onImagePicked});

  final void Function(String path, String extension)? onImagePicked;

  @override
  ConsumerState<ProfileImagePicker> createState() => _ProfileImagePickerState();
}

class _ProfileImagePickerState extends ConsumerState<ProfileImagePicker> {
  late ImagePicker _imagePicker;
  String _pickedImagePath = "";

  @override
  void initState() {
    super.initState();
    _imagePicker = ImagePicker();
  }

  @override
  Widget build(BuildContext context) {
    final imageUrl = ref.watch(authProvider).socialUser?.profileImageUrl;

    return GestureDetector(
      onTap: () async {
        final pickedFile = await _imagePicker.pickImage(
          source: ImageSource.gallery,
        );

        if (pickedFile != null) {
          final path = pickedFile.path;
          final extension = path.split('.').last;
          setState(() {
            _pickedImagePath = path;
          });
          widget.onImagePicked?.call(path, extension);
        }
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircleAvatar(
            radius: 44,
            backgroundColor: Colors.grey[200],
            backgroundImage: _pickedImagePath == ""
                ? null
                : FileImage(File(_pickedImagePath)) as ImageProvider,
            child: _pickedImagePath == "" && imageUrl == null
                ? const Icon(Icons.person, size: 44, color: Colors.grey)
                : null,
          ),
          // 검정색 그라데이션 오버레이
          Container(
            width: 88,
            height: 88,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.5, 1.0],
                colors: [
                  Color.fromRGBO(0, 0, 0, 0.0),
                  Color.fromRGBO(0, 0, 0, 0.9),
                ],
              ),
            ),
          ),
          // 하단 중앙 '변경' 텍스트
          Positioned(
            bottom: 8,
            child: Text(
              '변경',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w500,
                shadows: [
                  Shadow(color: Colors.black.withOpacity(0.4), blurRadius: 2),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
