import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hooks_riverpod/legacy.dart';
import 'package:learnflow_backoffice/dto/managers_response.dto.dart';
import 'package:learnflow_backoffice/screens/management/widgets/management_pagination_controls.dart';
import 'package:learnflow_backoffice/services/api/api_service.dart';
import 'package:learnflow_backoffice/services/authentication/secure_storage.dart';

final managersPageProvider = StateProvider.autoDispose<int>((ref) => 1);
final managersPageSizeProvider = StateProvider.autoDispose<int>((ref) => 10);
final managersSearchProvider = StateProvider.autoDispose<String>((ref) => '');

final managersResponseProvider = FutureProvider.autoDispose
    .family<ManagersResponse, ({int page, int pageSize, String search})>(
        (ref, params) async {
  final apiToken = await ref.watch(secureStorageProvider).getApiToken();
  final apiService = ref.read(apiServiceProvider(apiToken));
  return apiService.getManagers(
    page: params.page,
    limit: params.pageSize,
    search: params.search.isEmpty ? null : params.search,
  );
});

class ManagerDataTable extends ConsumerWidget {
  const ManagerDataTable({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final page = ref.watch(managersPageProvider);
    final pageSize = ref.watch(managersPageSizeProvider);
    final search = ref.watch(managersSearchProvider);
    final responseAsync = ref.watch(
      managersResponseProvider(
          (page: page, pageSize: pageSize, search: search)),
    );

    return responseAsync.when(
      data: (response) {
        final items = response.data ?? const [];
        final meta = response.meta;
        final currentPage = meta?.page ?? page;
        final totalPages = (meta?.totalPages ?? 1) < 1 ? 1 : meta!.totalPages!;

        return Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  DataTable(
                    columns: const [
                      DataColumn(label: Text('First Name')),
                      DataColumn(label: Text('Last Name')),
                      DataColumn(label: Text('Email')),
                    ],
                    rows: items
                        .map(
                          (manager) => DataRow(
                            cells: [
                              DataCell(Text(manager.firstName ?? '')),
                              DataCell(Text(manager.lastName ?? '')),
                              DataCell(Text(manager.email ?? '')),
                            ],
                          ),
                        )
                        .toList(),
                  ),
                ],
              ),
            ),
            ManagementPaginationControls(
              page: currentPage,
              totalPages: totalPages,
              totalItems: meta?.total,
              pageSize: pageSize,
              searchText: search,
              onPageSizeChanged: (value) {
                ref.read(managersPageSizeProvider.notifier).state = value;
                ref.read(managersPageProvider.notifier).state = 1;
              },
              onSearchChanged: (value) {
                ref.read(managersSearchProvider.notifier).state = value.trim();
                ref.read(managersPageProvider.notifier).state = 1;
              },
              onPrevious: currentPage > 1
                  ? () => ref.read(managersPageProvider.notifier).state =
                      currentPage - 1
                  : null,
              onNext: currentPage < totalPages
                  ? () => ref.read(managersPageProvider.notifier).state =
                      currentPage + 1
                  : null,
            ),
          ],
        );
      },
      error: (error, stackTrace) => const Center(
        child: Text('Error while loading managers'),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }
}
