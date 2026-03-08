import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:learnflow_backoffice/screens/management/management_screen.dart';
import 'package:learnflow_backoffice/screens/management/widgets/table_selector_item.dart';

class TableSelector extends ConsumerWidget {
  const TableSelector({super.key});

  static const _items = [
    _SelectorConfig('Students', Icons.person_outline, Icons.person),
    _SelectorConfig('Teachers', Icons.person_outline, Icons.person),
    _SelectorConfig('Bookings', Icons.book_outlined, Icons.book),
    _SelectorConfig('Subjects', Icons.menu_book_outlined, Icons.menu_book),
    _SelectorConfig('Evaluations', Icons.rule_outlined, Icons.rule),
    _SelectorConfig('Ratings', Icons.star_outline, Icons.star),
    _SelectorConfig(
        'Justificatives', Icons.description_outlined, Icons.description),
    _SelectorConfig(
        'Documents', Icons.file_present_outlined, Icons.file_present),
    _SelectorConfig('Moderators', Icons.security_outlined, Icons.security),
    _SelectorConfig('Reports', Icons.report_outlined, Icons.report),
    _SelectorConfig('Payments', Icons.payments_outlined, Icons.payments),
    _SelectorConfig(
        'Managers', Icons.manage_accounts_outlined, Icons.manage_accounts),
    _SelectorConfig('Report Types', Icons.category_outlined, Icons.category),
    _SelectorConfig('Subject Taughts', Icons.school_outlined, Icons.school),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(dataTableIndexProvider);

    return ListView.separated(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: _items.length,
      separatorBuilder: (_, __) => const SizedBox(width: 12),
      itemBuilder: (context, index) {
        final item = _items[index];
        return TableSelectorItem(
          id: index,
          icon: selectedIndex == index ? item.selectedIcon : item.icon,
          title: item.title,
          onTap: () => ref.read(dataTableIndexProvider.notifier).state = index,
        );
      },
    );
  }
}

class _SelectorConfig {
  const _SelectorConfig(this.title, this.icon, this.selectedIcon);

  final String title;
  final IconData icon;
  final IconData selectedIcon;
}
