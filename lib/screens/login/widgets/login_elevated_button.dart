import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class MyLoginElevatedButton extends ConsumerWidget {
  const MyLoginElevatedButton({
    super.key,
    this.height = 50,
    this.onPressed,
    this.child,
  });
  final double height;
  final VoidCallback? onPressed;
  final Widget? child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        minimumSize: Size(400, height),
        textStyle: Theme.of(context).textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
        backgroundColor: Theme.of(context).colorScheme.background,
        foregroundColor: Theme.of(context).colorScheme.primary,
        elevation: 10,
      ),
      onPressed: onPressed,
      child: child,
    );
  }
}
