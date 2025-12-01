import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:live_frontend/providers/map_location_provider.dart';

class LocateButton extends ConsumerWidget {
  const LocateButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mapLocationController = ref.read(mapLocationProvider.notifier);
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: const CircleBorder(),
        padding: const EdgeInsets.all(8),
      ),
      onPressed: () {
        mapLocationController.moveCenterToCurrentLocation();
      },
      child: SizedBox(
        width: 24,
        height: 24,
        child: SvgPicture.asset('assets/icons/reset_location.svg'),
      ),
    );
  }
}
