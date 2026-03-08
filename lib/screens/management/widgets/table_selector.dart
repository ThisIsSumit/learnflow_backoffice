import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:learnflow_backoffice/screens/management/management_screen.dart';
import 'package:learnflow_backoffice/screens/management/widgets/table_selector_item.dart';

class TableSelector extends ConsumerWidget {
  const TableSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView(
      scrollDirection: Axis.horizontal,
      children: [
        TableSelectorItem(
          id: 0,
          icon: ref.watch(dataTableIndexProvider) == 0
              ? Icons.person
              : Icons.person_outline,
          title: "Students",
          onTap: () => ref.watch(dataTableIndexProvider.notifier).state = 0,
        ),
        TableSelectorItem(
          id: 1,
          icon: ref.watch(dataTableIndexProvider) == 1
              ? Icons.person
              : Icons.person_outline,
          title: "Teachers",
          onTap: () => ref.watch(dataTableIndexProvider.notifier).state = 1,
        ),
        TableSelectorItem(
          id: 2,
          icon: ref.watch(dataTableIndexProvider) == 2
              ? Icons.book
              : Icons.book_outlined,
          title: "Bookings",
          onTap: () => ref.watch(dataTableIndexProvider.notifier).state = 2,
        ),
        TableSelectorItem(
          id: 3,
          icon: ref.watch(dataTableIndexProvider) == 3
              ? Icons.menu_book
              : Icons.menu_book_outlined,
          title: "Subjects",
          onTap: () => ref.watch(dataTableIndexProvider.notifier).state = 3,
        ),
        TableSelectorItem(
          id: 4,
          icon: ref.watch(dataTableIndexProvider) == 4
              ? Icons.rule
              : Icons.rule_outlined,
          title: "Evaluations",
          onTap: () => ref.watch(dataTableIndexProvider.notifier).state = 4,
        ),
        TableSelectorItem(
          id: 5,
          icon: ref.watch(dataTableIndexProvider) == 5
              ? Icons.star
              : Icons.star_outline,
          title: "Ratings",
          onTap: () => ref.watch(dataTableIndexProvider.notifier).state = 5,
        ),
        TableSelectorItem(
          id: 6,
          icon: ref.watch(dataTableIndexProvider) == 6
              ? Icons.description
              : Icons.description_outlined,
          title: "Justificatives",
          onTap: () => ref.watch(dataTableIndexProvider.notifier).state = 6,
        ),
        TableSelectorItem(
          id: 7,
          icon: ref.watch(dataTableIndexProvider) == 7
              ? Icons.file_present
              : Icons.file_present_outlined,
          title: "Documents",
          onTap: () => ref.watch(dataTableIndexProvider.notifier).state = 7,
        ),
        TableSelectorItem(
          id: 8,
          icon: ref.watch(dataTableIndexProvider) == 8
              ? Icons.security
              : Icons.security_outlined,
          title: "Moderators",
          onTap: () => ref.watch(dataTableIndexProvider.notifier).state = 8,
        ),
        TableSelectorItem(
          id: 9,
          icon: ref.watch(dataTableIndexProvider) == 9
              ? Icons.report
              : Icons.report_outlined,
          title: "Reports",
          onTap: () => ref.watch(dataTableIndexProvider.notifier).state = 9,
        ),
        TableSelectorItem(
          id: 10,
          icon: ref.watch(dataTableIndexProvider) == 10
              ? Icons.payments
              : Icons.payments_outlined,
          title: "Payments",
          onTap: () => ref.watch(dataTableIndexProvider.notifier).state = 10,
        ),
        TableSelectorItem(
          id: 11,
          icon: ref.watch(dataTableIndexProvider) == 11
              ? Icons.manage_accounts
              : Icons.manage_accounts_outlined,
          title: "Managers",
          onTap: () => ref.watch(dataTableIndexProvider.notifier).state = 11,
        ),
        TableSelectorItem(
          id: 12,
          icon: ref.watch(dataTableIndexProvider) == 12
              ? Icons.category
              : Icons.category_outlined,
          title: "Report Types",
          onTap: () => ref.watch(dataTableIndexProvider.notifier).state = 12,
        ),
        TableSelectorItem(
          id: 13,
          icon: ref.watch(dataTableIndexProvider) == 13
              ? Icons.school
              : Icons.school_outlined,
          title: "Subject Taughts",
          onTap: () => ref.watch(dataTableIndexProvider.notifier).state = 13,
        ),
      ],
    );
  }
}
