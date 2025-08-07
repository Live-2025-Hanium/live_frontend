import 'package:flutter/material.dart';

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

  String get _label {
    if (_range.start < _center)
      return '어려움 ${(_center - _range.start).round()}';
    if (_range.end > _center) return '쉬움 ${(_range.end - _center).round()}';
    return '보통';
  }

  @override
  Widget build(BuildContext context) {
    // 현재 선택 쪽에 맞춰 색상도 바꿔줌
    final activeColor = _range.start < _center ? Colors.red : Colors.green;

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
              // start 값이 변했으면 음수(어려움) 쪽을 건드린 것
              if (values.start != _range.start) {
                final newStart = values.start.clamp(_min, _center);
                _range = RangeValues(newStart, _center);
              }
              // 그렇지 않으면 end 값을 건드린 것 (쉬움 쪽)
              else {
                final newEnd = values.end.clamp(_center, _max);
                _range = RangeValues(_center, newEnd);
              }
            });
          },
        ),

        // 눈금 라벨 (원하는 대로 수정)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: const [
              Text('어려움'),
              Spacer(),
              Text('보통'),
              Spacer(),
              Text('쉬움'),
            ],
          ),
        ),

        const SizedBox(height: 8),
        Text('현재 난이도: $_label'),
      ],
    );
  }
}
