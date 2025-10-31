import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:live_frontend/providers/auth_provider.dart';
import 'package:live_frontend/theme/app_colors.dart';
import 'package:live_frontend/theme/app_text_styles.dart';

class ProfileWidget extends ConsumerWidget {
  const ProfileWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileImageSrc = ref.watch(authProvider).pickedImagePath ?? '';
    return Container(
      color: Colors.white,
      constraints: BoxConstraints(minHeight: 116),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ClipOval(
            child: SizedBox(
              width: 84,
              height: 84,
              child: CachedNetworkImage(
                imageUrl: profileImageSrc,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: Colors.grey.shade200,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                errorWidget: (context, url, error) {
                  //  debugPrint('Avatar load error');
                  return Container(
                    color: Colors.grey.shade200,
                    child: Icon(
                      Icons.person,
                      size: 42,
                      color: Colors.grey.shade400,
                    ),
                  );
                },
              ),
            ),
          ),
          Gap(20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                ref.watch(authProvider).nickname ?? '',
                style: AppTextStyles.subtitleMedium(context),
              ),
              Text(
                '추가 정보',
                style: AppTextStyles.smallMedium(
                  context,
                  color: AppColors.blackBlack4,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
