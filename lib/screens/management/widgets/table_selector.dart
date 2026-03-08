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
        // TableSelectorItem(
        //   id: 3,
        //   icon: ref.watch(dataTableIndexProvider) == 3
        //       ? Icons.report
        //       : Icons.report_outlined,
        //   title: "Signalements",
        //   onTap: () => ref.watch(dataTableIndexProvider.notifier).state = 3,
        // ),
        // TableSelectorItem(
        //   id: 4,
        //   icon: ref.watch(dataTableIndexProvider) == 4
        //       ? Icons.description
        //       : Icons.description_outlined,
        //   title: "Justificatifs",
        //   onTap: () => ref.watch(dataTableIndexProvider.notifier).state = 4,
        // ),
      ],
    );
  }
}
