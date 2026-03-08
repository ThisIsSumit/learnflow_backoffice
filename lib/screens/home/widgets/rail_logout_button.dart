import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:learnflow_backoffice/screens/home/widgets/logout_alert_dialog.dart';

class RailLogoutButton extends ConsumerWidget {
  const RailLogoutButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final color = Theme.of(context).colorScheme.onSurfaceVariant;

    return InkWell(
      borderRadius: BorderRadius.circular(30),
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => const LogoutAlertDialog(),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Icon(Icons.logout, color: color),
            Text(
              "Logout",
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: color,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
