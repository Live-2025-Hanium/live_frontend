import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:live_frontend/theme/app_colors.dart';
import 'package:live_frontend/widgets/saeip_search_bar.dart';
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, TargetPlatform;

class MapAppBar extends StatelessWidget implements PreferredSizeWidget {
  final TextEditingController externalController;
  final String hintText;
  final void Function(String)? onSubmit;

  const MapAppBar({
    super.key,
    required this.externalController,
    required this.hintText,
    this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    final bool isIOS = defaultTargetPlatform == TargetPlatform.iOS;

    return AppBar(
      shape: const Border(
        bottom: BorderSide(color: AppColors.blackBlack3, width: 0.5),
      ),
      title: SaeipSearchBar.map(
        controller: externalController,
        hintText: hintText,
        onSubmit: (String query) {
          if (onSubmit != null) {
            onSubmit!(query);
          }
        },
      ),
      titleSpacing: 0,
      centerTitle: isIOS,
      leading: IconButton(
        icon: Icon(isIOS ? Icons.chevron_left : Icons.arrow_back, size: 20),
        onPressed: () => context.pop(),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
