import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:live_frontend/providers/auth_provider.dart';

class ProfileImagePicker extends ConsumerWidget {
  const ProfileImagePicker({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final imageUrl = ref.watch(authProvider).socialUser?.profileImageUrl;
    return GestureDetector(
      onTap: () {
        // TODO: 이미지 변경 처리
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircleAvatar(
            radius: 44.w,
            backgroundColor: Colors.grey[200],
            backgroundImage: imageUrl != null ? NetworkImage(imageUrl!) : null,
            child:
                imageUrl == null
                    ? const Icon(Icons.person, size: 44, color: Colors.grey)
                    : null,
          ),
          // 검정색 그라데이션 오버레이
          Container(
            width: 88.w,
            height: 88.w,
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
