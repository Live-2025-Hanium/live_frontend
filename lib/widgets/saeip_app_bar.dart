import 'dart:io';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:live_frontend/theme/app_text_styles.dart';

enum AppBarStyle { common, detail }

class SaeipAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final String? lastPage;
  final VoidCallback? leadingAction;
  final AppBarStyle appBarStyle;
  final void Function()? onBack;

  const SaeipAppBar({
    super.key,
    this.title = '',
    this.actions,
    this.lastPage,
    this.leadingAction,
    this.appBarStyle = AppBarStyle.detail,
    this.onBack,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    void goBack() {
      if (onBack != null) {
        onBack!();
      } else if (GoRouter.of(context).canPop()) {
        context.pop();
      } else {
        context.push(lastPage ?? '/home');
      }
    }

    final bool isIOS = Platform.isIOS;

    if (appBarStyle == AppBarStyle.common) {
      return AppBar(
        automaticallyImplyLeading: false,
        title: SvgPicture.asset('assets/logo/logo.svg', width: 73, height: 20),
        centerTitle: false,
        actions: [
          IconButton(
            icon: Icon(Icons.notifications_none),
            onPressed: () {
              /* 알림 화면으로 */
            },
          ),
        ],
      );
    }

    return AppBar(
      title: Text(
        title,
        style: AppTextStyles.bodyMedium(context, color: Colors.black),
      ),
      titleSpacing: 0,
      centerTitle: isIOS,
      actions: actions,
      leading: IconButton(
        icon: Icon(isIOS ? Icons.chevron_left : Icons.arrow_back, size: 20),
        onPressed: leadingAction ?? goBack,
      ),
    );
  }
}
