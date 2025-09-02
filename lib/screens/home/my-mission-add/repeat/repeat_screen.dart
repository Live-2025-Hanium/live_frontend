import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:live_frontend/theme/app_colors.dart';
import 'package:live_frontend/theme/app_text_styles.dart';
import 'package:live_frontend/widgets/saeip_app_bar.dart';
import 'package:live_frontend/models/my_mission_model.dart';

class RepeatScreen extends StatefulWidget {
  final RepeatDay? initial;

  const RepeatScreen({super.key, this.initial});

  @override
  State<RepeatScreen> createState() => _RepeatScreenState();
}

class _RepeatScreenState extends State<RepeatScreen> {
  late RepeatDay? _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.initial;
  }

  void _onDone() => Navigator.of(context).pop(_selected);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SaeipAppBar(
        title: '반복',
        actions: [
          TextButton(
            onPressed: _onDone,
            style: TextButton.styleFrom(
              minimumSize: Size(50.w, 40.h),
              padding: EdgeInsets.symmetric(horizontal: 12.w),
            ),
            child: Text(
              '완료',
              style: AppTextStyles.bodyMedium(
                context,
                color: AppColors.greenNormal,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView.separated(
          itemCount: RepeatDay.values.length,
          separatorBuilder: (_, __) => const SizedBox.shrink(), // 구분선 제거
          itemBuilder: (context, index) {
            final day = RepeatDay.values[index];
            final label = day.label;
            final selected = _selected == day;
            return ListTile(
              title: Text(label),
              tileColor: Colors.white,
              shape: const RoundedRectangleBorder(side: BorderSide.none),
              trailing: selected
                  ? const Icon(Icons.check, color: AppColors.greenNormal)
                  : const SizedBox.shrink(),
              onTap: () => setState(() => _selected = day),
            );
          },
        ),
      ),
    );
  }
}
