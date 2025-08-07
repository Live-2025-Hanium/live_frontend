import 'package:flutter/material.dart';
import 'package:live_frontend/theme/app_colors.dart';
import 'package:live_frontend/theme/app_text_styles.dart';

class BipolarRangeSlider extends StatefulWidget {
  const BipolarRangeSlider({super.key});

  @override
  State<BipolarRangeSlider> createState() => _BipolarRangeSliderState();
}

class _BipolarRangeSliderState extends State<BipolarRangeSlider> {
  // 슬라이더 범위: 0(어려움) … 4(쉬움), 중앙 값은 2
  static const double _min = 0;
  static const double _max = 4;
  static const double _center = 2;

  // 스타트·엔드 값: 둘 다 중앙(2)에서 시작 → 실제 보이는 thumb는 두 개가 겹쳐진 것처럼 보임
  RangeValues _range = const RangeValues(_center, _center);

  @override
  Widget build(BuildContext context) {
    // 현재 선택 쪽에 맞춰 색상도 바꿔줌
    Color activeColor; // _range.start < _center ? Colors.red : Colors.green;

    if (_range.start < _center) {
      activeColor = AppColors.errorError2;
    } else if (_range.end > _center) {
      activeColor = AppColors.greenLightActive;
    } else {
      activeColor = AppColors.blackBlack4; // 중립 상태
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        RangeSlider(
          min: _min,
          max: _max,
          divisions: 4,
          values: _range,
          activeColor: activeColor,
          inactiveColor: Colors.grey.shade300,
          onChanged: (values) {
            setState(() {
              // 1) start thumb 를 움직이는 경우 (쉬움→어려움)
              if (values.start != _range.start) {
                // 이전 상태가 '쉬움' 이었고, 지금 중앙에서 넘으려는 순간
                if (_range.start == _center && _range.end > _center) {
                  // 중립으로 한 번 찍고
                  _range = const RangeValues(_center, _center);
                } else {
                  // 실제 어려움 영역으로
                  final newStart = values.start.clamp(_min, _center);
                  _range = RangeValues(newStart, _center);
                }
              }
              // 2) end thumb 를 움직이는 경우 (어려움→쉬움)
              else {
                // 이전 상태가 '어려움' 이었고, 지금 중앙에서 넘으려는 순간
                if (_range.end == _center && _range.start < _center) {
                  // 중립으로 한 번 찍고
                  _range = const RangeValues(_center, _center);
                } else {
                  // 실제 쉬움 영역으로
                  final newEnd = values.end.clamp(_center, _max);
                  _range = RangeValues(_center, newEnd);
                }
              }
            });
          },
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '어려움',
                style: AppTextStyles.smallMedium(
                  context,
                  color: AppColors.blackBlack5,
                ),
              ),
              Text(
                '미션 난이도',
                style: AppTextStyles.bodyRegular(context, color: Colors.black),
              ),
              Text(
                '쉬움',
                style: AppTextStyles.smallMedium(
                  context,
                  color: AppColors.blackBlack5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
