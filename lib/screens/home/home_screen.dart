import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:learnflow_backoffice/screens/home/widgets/navigation_rail.dart.dart';
import 'package:learnflow_backoffice/screens/management/management_screen.dart';

class HomeScreen extends HookConsumerWidget {
  const HomeScreen({super.key});

  static const subScreens = [
    ManagementScreen(),
    ManagementScreen(),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentSubScreenIndex = ref.watch(railIndexProvider);
    return Scaffold(
      body: Row(
        children: [
          const MyNavigationRail(),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(
            child: subScreens[currentSubScreenIndex],
          ),
        ],
      ),
    );
  }
}
