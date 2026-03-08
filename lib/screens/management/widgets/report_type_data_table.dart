import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hooks_riverpod/legacy.dart';
import 'package:learnflow_backoffice/dto/report_types_response.dto.dart';
import 'package:learnflow_backoffice/models/report_type.dart';
import 'package:learnflow_backoffice/screens/management/widgets/entity_crud_panel.dart';
import 'package:learnflow_backoffice/screens/management/widgets/management_pagination_controls.dart';
import 'package:learnflow_backoffice/services/api/api_service.dart';
import 'package:learnflow_backoffice/services/authentication/secure_storage.dart';

final reportTypesPageProvider = StateProvider.autoDispose<int>((ref) => 1);
final reportTypesPageSizeProvider = StateProvider.autoDispose<int>((ref) => 10);
final reportTypesSearchProvider =
    StateProvider.autoDispose<String>((ref) => '');

final reportTypesResponseProvider = FutureProvider.autoDispose
    .family<ReportTypesResponse, ({int page, int pageSize, String search})>(
        (ref, params) async {
  final apiToken = await ref.watch(secureStorageProvider).getApiToken();
  final apiService = ref.read(apiServiceProvider(apiToken));
  return apiService.getReportTypes(
    page: params.page,
    limit: params.pageSize,
    search: params.search.isEmpty ? null : params.search,
  );
});

class ReportTypeDataTable extends ConsumerWidget {
  const ReportTypeDataTable({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final page = ref.watch(reportTypesPageProvider);
    final pageSize = ref.watch(reportTypesPageSizeProvider);
    final search = ref.watch(reportTypesSearchProvider);
    final responseAsync = ref.watch(
      reportTypesResponseProvider(
        (page: page, pageSize: pageSize, search: search),
      ),
    );

    return responseAsync.when(
      data: (response) {
        final items = response.data ?? const [];
        final meta = response.meta;
        final currentPage = meta?.page ?? page;
        final totalPages = (meta?.totalPages ?? 1) < 1 ? 1 : meta!.totalPages!;

        return Column(
          children: [
            EntityCrudPanel(
              entityLabel: 'Report Type',
              createTemplate: const {
                'name': '',
              },
              onCreate: (json) async {
                final apiToken =
                    await ref.read(secureStorageProvider).getApiToken();
                await ref
                    .read(apiServiceProvider(apiToken))
                    .createReportType(ReportType.fromJson(json));
              },
              onCompleted: () {
                ref.invalidate(
                  reportTypesResponseProvider(
                    (page: page, pageSize: pageSize, search: search),
                  ),
                );
              },
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView(
                children: [
                  DataTable(
                    columns: const [
                      DataColumn(label: Text('ID')),
                      DataColumn(label: Text('Name')),
                      DataColumn(label: Text('Actions')),
                    ],
                    rows: items
                        .map(
                          (item) => DataRow(
                            cells: [
                              DataCell(Text(item.id ?? '')),
                              DataCell(Text(item.name ?? '')),
                              DataCell(
                                EntityRowActionsMenu(
                                  entityLabel: 'Report Type',
                                  option: EntityUpdateOption(
                                    id: item.id ?? '',
                                    label:
                                        item.name ?? item.id ?? 'Report Type',
                                    values: item.toJson(),
                                  ),
                                  template: const {
                                    'name': '',
                                  },
                                  onUpdate: (id, json) async {
                                    final payload = <String, dynamic>{
                                      ...json,
                                      '_id': id
                                    };
                                    final apiToken = await ref
                                        .read(secureStorageProvider)
                                        .getApiToken();
                                    await ref
                                        .read(apiServiceProvider(apiToken))
                                        .updateReportType(
                                            id, ReportType.fromJson(payload));
                                  },
                                  onDelete: (id) async {
                                    final apiToken = await ref
                                        .read(secureStorageProvider)
                                        .getApiToken();
                                    await ref
                                        .read(apiServiceProvider(apiToken))
                                        .deleteReportType(id);
                                  },
                                  onCompleted: () {
                                    ref.invalidate(
                                      reportTypesResponseProvider(
                                        (
                                          page: page,
                                          pageSize: pageSize,
                                          search: search
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
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
                ref.read(reportTypesPageSizeProvider.notifier).state = value;
                ref.read(reportTypesPageProvider.notifier).state = 1;
              },
              onSearchChanged: (value) {
                ref.read(reportTypesSearchProvider.notifier).state =
                    value.trim();
                ref.read(reportTypesPageProvider.notifier).state = 1;
              },
              onPrevious: currentPage > 1
                  ? () => ref.read(reportTypesPageProvider.notifier).state =
                      currentPage - 1
                  : null,
              onNext: currentPage < totalPages
                  ? () => ref.read(reportTypesPageProvider.notifier).state =
                      currentPage + 1
                  : null,
            ),
          ],
        );
      },
      error: (error, stackTrace) => const Center(
        child: Text('Error while loading report types'),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }
}
