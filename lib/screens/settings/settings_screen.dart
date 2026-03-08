import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:learnflow_backoffice/screens/home/widgets/app_bar.dart';
import 'package:learnflow_backoffice/services/env/env.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        const MyAppBar(subScreen: 'Settings'),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Card(
                child: ListTile(
                  title: const Text('API Base URL'),
                  subtitle: Text(Env.apiBaseUrl),
                ),
              ),
              const Card(
                child: ListTile(
                  title: Text('Environment Notes'),
                  subtitle: Text(
                    'Use --dart-define-from-file=.env.dev when running locally to load API_BASE_URL correctly.',
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
