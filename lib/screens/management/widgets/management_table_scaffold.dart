import 'package:flutter/material.dart';
import 'package:learnflow_backoffice/screens/management/widgets/management_pagination_controls.dart';

class ManagementTableScaffold extends StatelessWidget {
  const ManagementTableScaffold({
    super.key,
    required this.table,
    required this.page,
    required this.totalPages,
    required this.totalItems,
    required this.pageSize,
    required this.searchText,
    required this.onPageSizeChanged,
    required this.onSearchChanged,
    required this.onPrevious,
    required this.onNext,
  });

  final Widget table;
  final int page;
  final int totalPages;
  final int? totalItems;
  final int pageSize;
  final String searchText;
  final ValueChanged<int> onPageSizeChanged;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView(
            children: [table],
          ),
        ),
        ManagementPaginationControls(
          page: page,
          totalPages: totalPages,
          totalItems: totalItems,
          pageSize: pageSize,
          searchText: searchText,
          onPageSizeChanged: onPageSizeChanged,
          onSearchChanged: onSearchChanged,
          onPrevious: onPrevious,
          onNext: onNext,
        ),
      ],
    );
  }
}
