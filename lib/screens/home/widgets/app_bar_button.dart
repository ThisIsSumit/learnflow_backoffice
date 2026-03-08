import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class MyAppBarButton extends ConsumerWidget {
  const MyAppBarButton(
      {super.key, required this.onPressed, required this.icon, this.tooltip});

  final VoidCallback? onPressed;
  final Icon icon;
  final String? tooltip;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
        shape: BoxShape.circle,
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: icon,
        tooltip: tooltip,
      ),
    );
  }
}
