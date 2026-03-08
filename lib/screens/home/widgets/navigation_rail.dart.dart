import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hooks_riverpod/legacy.dart';
import 'package:learnflow_backoffice/screens/home/widgets/rail_logout_button.dart';

final railIndexProvider = StateProvider.autoDispose<int>((ref) {
  return 0;
});

class MyNavigationRail extends ConsumerWidget {
  const MyNavigationRail({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;

    return NavigationRail(
      backgroundColor: colorScheme.surface,
      leading: const Padding(
        padding: EdgeInsets.only(top: 10, bottom: 30),
        child: Image(
          image: AssetImage("assets/images/logo-1-transparent.png"),
          width: 100,
          filterQuality: FilterQuality.high,
          isAntiAlias: true,
        ),
      ),
      useIndicator: true,
      labelType: NavigationRailLabelType.all,
      selectedIndex: ref.watch(railIndexProvider),
      onDestinationSelected: (value) {
        ref.watch(railIndexProvider.notifier).state = value;
      },
      destinations: const <NavigationRailDestination>[
        NavigationRailDestination(
          icon: Icon(Icons.dashboard_outlined),
          selectedIcon: Icon(Icons.dashboard),
          label: Text('Dashboard'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.table_view),
          selectedIcon: Icon(Icons.table_view_outlined),
          label: Text('Management'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.settings_outlined),
          selectedIcon: Icon(Icons.settings),
          label: Text('Settings'),
        ),
      ],
      trailing: const Expanded(
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: EdgeInsets.only(bottom: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                RailLogoutButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
