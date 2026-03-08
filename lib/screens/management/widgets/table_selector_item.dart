import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:learnflow_backoffice/screens/management/management_screen.dart';

class TableSelectorItem extends ConsumerWidget {
  const TableSelectorItem({
    super.key,
    required this.id,
    required this.title,
    required this.icon,
    required this.onTap,
  });

  final int id;
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Material(
      borderRadius: BorderRadius.circular(20),
      child: Card(
        color: Colors.white,
        child: InkWell(
          onTap: onTap,
          child: Container(
            width: 160,
            height: 300,
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: ref.watch(dataTableIndexProvider) != id
                  ? null
                  : Border.all(
                      color: Theme.of(context).colorScheme.primary,
                    ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 32),
                const SizedBox(height: 4),
                Text(title)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
