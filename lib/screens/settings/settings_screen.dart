import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:learnflow_backoffice/main.dart';
import 'package:learnflow_backoffice/screens/home/widgets/app_bar.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final isDarkMode = themeMode == ThemeMode.dark;

    return Column(
      children: [
        const MyAppBar(subScreen: 'Settings'),
        Expanded(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Card(
                margin: const EdgeInsets.all(16),
                child: SwitchListTile(
                  title: const Text('Dark Mode'),
                  value: isDarkMode,
                  onChanged: (enabled) {
                    ref.read(themeModeProvider.notifier).state =
                        enabled ? ThemeMode.dark : ThemeMode.light;
                  },
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
