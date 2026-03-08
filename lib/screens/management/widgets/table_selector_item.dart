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
    final colorScheme = Theme.of(context).colorScheme;
    final isSelected = ref.watch(dataTableIndexProvider) == id;

    return Material(
      borderRadius: BorderRadius.circular(20),
      child: Card(
        margin: EdgeInsets.zero,
        elevation: 2,
        color: colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color:
                isSelected ? colorScheme.primary : colorScheme.outlineVariant,
            width: isSelected ? 1.4 : 1,
          ),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            width: 160,
            height: 300,
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
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
