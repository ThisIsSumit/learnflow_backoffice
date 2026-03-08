import 'package:flutter/material.dart';

class ManagementPaginationControls extends StatelessWidget {
  const ManagementPaginationControls({
    super.key,
    required this.page,
    required this.totalPages,
    required this.onPrevious,
    required this.onNext,
    required this.pageSize,
    required this.onPageSizeChanged,
    required this.searchText,
    required this.onSearchChanged,
    this.totalItems,
    this.pageSizeOptions = const [10, 25, 50],
  });

  final int page;
  final int totalPages;
  final int? totalItems;
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;
  final int pageSize;
  final ValueChanged<int> onPageSizeChanged;
  final String searchText;
  final ValueChanged<String> onSearchChanged;
  final List<int> pageSizeOptions;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Row(
            children: [
              SizedBox(
                width: 240,
                child: TextFormField(
                  initialValue: searchText,
                  decoration: const InputDecoration(
                    isDense: true,
                    hintText: 'Search',
                    prefixIcon: Icon(Icons.search),
                  ),
                  onFieldSubmitted: onSearchChanged,
                ),
              ),
              const SizedBox(width: 12),
              const Text('Rows'),
              const SizedBox(width: 8),
              DropdownButton<int>(
                value: pageSize,
                items: pageSizeOptions
                    .map(
                      (size) => DropdownMenuItem<int>(
                        value: size,
                        child: Text(size.toString()),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    onPageSizeChanged(value);
                  }
                },
              ),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if (totalItems != null)
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: Text('Total: $totalItems'),
              ),
            Text('Page $page / $totalPages'),
            const SizedBox(width: 8),
            IconButton(
              onPressed: onPrevious,
              icon: const Icon(Icons.chevron_left),
              tooltip: 'Previous page',
            ),
            IconButton(
              onPressed: onNext,
              icon: const Icon(Icons.chevron_right),
              tooltip: 'Next page',
            ),
          ],
        ),
      ],
    );
  }
}
