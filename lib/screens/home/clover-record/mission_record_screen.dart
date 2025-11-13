import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:live_frontend/models/clover_mission_model.dart';
import 'package:live_frontend/providers/clover_mission_provider.dart';
import 'package:live_frontend/providers/photo_mission_provider.dart';
import 'package:live_frontend/screens/home/clover-record/widget/bipolar_range_slider.dart';
import 'package:live_frontend/theme/app_colors.dart';
import 'package:live_frontend/theme/app_text_styles.dart';
import 'package:live_frontend/widgets/rating_bar.dart';
import 'package:live_frontend/widgets/saeip_app_bar.dart';
import 'package:live_frontend/widgets/saeip_button.dart';

import '../../../core/utils/s3_upload_util.dart';

// 나중에 extra로 미션 데이터 받아오기!
class MissionRecordScreen extends ConsumerStatefulWidget {
  final int id;

  const MissionRecordScreen({super.key, required this.id});

  @override
  ConsumerState<MissionRecordScreen> createState() =>
      _MissionRecordScreenState();
}

class _MissionRecordScreenState extends ConsumerState<MissionRecordScreen> {
  final TextEditingController _controller = TextEditingController();
  int _sliderCurrentValue = 3; // 초기값은 중립 상태
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> onSaveTap(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });

    final imageRecord = ref.read(photoMissionImageProvider);
    String? imageUrl;

    try {
      if (imageRecord != null) {
        final (imageBytes, imageExtension) = imageRecord;
        imageUrl = await uploadImageToS3(
          ref: ref,
          imageBytes: imageBytes,
          imageExtension: imageExtension,
          domain: 'PHOTO_MISSION',
        );
      }

      final feedback = CloverMissionFeedbackModel(
        userMissionId: widget.id,
        feedbackComment: _controller.text,
        feedbackDifficulty: CloverMissionDifficulty.fromValue(
          _sliderCurrentValue,
        ),
        imageUrl: imageUrl,
      );

      await ref.read(cloverMissionFeedbackProvider(feedback).future);
      if (mounted) {
        ref.read(photoMissionImageProvider.notifier).state = null;
        ref.invalidate(cloverMissionProvider);
        context.go('/home');
      }
    } catch (e) {
      // 에러 처리
      debugPrint(e.toString());
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final missionDetailAsync = ref.watch(
      cloverMissionDetailProvider(widget.id),
    );
    final imageRecord = ref.watch(photoMissionImageProvider);
    final Uint8List? imageFile = imageRecord?.$1;

    return Scaffold(
      appBar: SaeipAppBar(title: '미션 기록'),
      body: missionDetailAsync.when(
        data: (data) {
          if (data == null) {
            return const Center(child: Text('미션 정보를 불러올 수 없습니다.'));
          }
          return Container(
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 40),
            width: double.infinity,
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          TextButton(
                            onPressed: () {},
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: SizedBox(
                              width: 124,
                              height: 124,
                              child: imageFile != null
                                  ? Image.memory(imageFile, fit: BoxFit.cover)
                                  : Image.asset(
                                      'assets/images/clover_mission_complete.png',
                                      fit: BoxFit.cover,
                                    ),
                            ),
                          ),
                          if (data.cloverType == CloverMissionType.photo)
                            SizedBox(
                              height: 48,
                              child: TextButton(
                                onPressed: () {},
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: Text(
                                  '사진 촬영',
                                  style:
                                      AppTextStyles.smallMedium(
                                        context,
                                        color: AppColors.blackBlack4,
                                      ).copyWith(
                                        decoration: TextDecoration.underline,
                                      ),
                                ),
                              ),
                            ),
                          Text(
                            data.missionTitle,
                            style: AppTextStyles.titleMedium(
                              context,
                              color: Colors.black,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              RatingBar(rating: data.missionDifficulty.value),
                              const Gap(8),
                              Text(
                                data.missionCategory.koreanLabel,
                                style: AppTextStyles.bodyRegular(
                                  context,
                                  color: AppColors.blackBlack4,
                                ),
                              ),
                            ],
                          ),
                          BipolarRangeSlider(
                            key: const Key('bipolar_range_slider'),
                            onChanged: (values) {
                              setState(() {
                                // 슬라이더 값 변경 시 상태 업데이트
                                _sliderCurrentValue = values;
                              });
                            },
                          ),
                          const Gap(32),
                          TextField(
                            controller: _controller,
                            maxLines: 6,
                            maxLength: 200,
                            style: AppTextStyles.bodyRegular(
                              context,
                              color: Colors.black,
                            ),
                            decoration: InputDecoration(
                              counterStyle: AppTextStyles.smallMedium(
                                context,
                                color: AppColors.blackBlack4,
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 12,
                                horizontal: 16,
                              ),
                              fillColor: AppColors.blackBlack0,
                              filled: true,
                              hintText: '미션을 완료하고 기분이 어땠나요?',
                              hintStyle: AppTextStyles.bodyRegular(
                                context,
                                color: AppColors.blackBlack4,
                              ),
                              border: InputBorder.none,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: SaeipButton(
                      isLoading: _isLoading,
                      text: '저장',
                      onPressed: () => onSaveTap(context),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(child: Text('에러 발생')),
      ),
    );
  }
}
