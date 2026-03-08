import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hooks_riverpod/legacy.dart';
import 'package:intl/intl.dart';
import 'package:learnflow_backoffice/dto/reports_response.dto.dart';
import 'package:learnflow_backoffice/models/report.dart';
import 'package:learnflow_backoffice/screens/management/widgets/entity_crud_panel.dart';
import 'package:learnflow_backoffice/screens/management/widgets/management_pagination_controls.dart';
import 'package:learnflow_backoffice/services/api/api_service.dart';
import 'package:learnflow_backoffice/services/authentication/secure_storage.dart';

final reportsPageProvider = StateProvider.autoDispose<int>((ref) => 1);
final reportsPageSizeProvider = StateProvider.autoDispose<int>((ref) => 10);
final reportsSearchProvider = StateProvider.autoDispose<String>((ref) => '');

final reportsResponseProvider = FutureProvider.autoDispose
    .family<ReportsResponse, ({int page, int pageSize, String search})>(
        (ref, params) async {
  final apiToken = await ref.watch(secureStorageProvider).getApiToken();
  final apiService = ref.read(apiServiceProvider(apiToken));
  return apiService.getReports(
    page: params.page,
    limit: params.pageSize,
    search: params.search.isEmpty ? null : params.search,
  );
});

class ReportDataTable extends ConsumerWidget {
  const ReportDataTable({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final page = ref.watch(reportsPageProvider);
    final pageSize = ref.watch(reportsPageSizeProvider);
    final search = ref.watch(reportsSearchProvider);
    final responseAsync = ref.watch(
      reportsResponseProvider((page: page, pageSize: pageSize, search: search)),
    );
    final formatter = DateFormat('yyyy-MM-dd HH:mm');

    return responseAsync.when(
      data: (response) {
        final items = response.data ?? const [];
        final meta = response.meta;
        final currentPage = meta?.page ?? page;
        final totalPages = (meta?.totalPages ?? 1) < 1 ? 1 : meta!.totalPages!;

        return Column(
          children: [
            EntityCrudPanel(
              entityLabel: 'Report',
              createTemplate: const {
                'description': '',
              },
              onCreate: (json) async {
                final apiToken =
                    await ref.read(secureStorageProvider).getApiToken();
                await ref
                    .read(apiServiceProvider(apiToken))
                    .createReport(Report.fromJson(json));
              },
              onCompleted: () {
                ref.invalidate(
                  reportsResponseProvider(
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
                      DataColumn(label: Text('Date')),
                      DataColumn(label: Text('Type')),
                      DataColumn(label: Text('Moderator')),
                      DataColumn(label: Text('Student')),
                      DataColumn(label: Text('Teacher')),
                      DataColumn(label: Text('Reason')),
                      DataColumn(label: Text('Actions')),
                    ],
                    rows: items
                        .map(
                          (report) => DataRow(
                            cells: [
                              DataCell(Text(report.date == null
                                  ? ''
                                  : formatter.format(report.date!.toLocal()))),
                              DataCell(Text(report.reportType?.name ?? '')),
                              DataCell(Text(report.moderator?.email ?? '')),
                              DataCell(Text(report.student?.email ?? '')),
                              DataCell(Text(report.teacher?.email ?? '')),
                              DataCell(Text(report.reason?.toString() ?? '')),
                              DataCell(
                                EntityRowActionsMenu(
                                  entityLabel: 'Report',
                                  option: EntityUpdateOption(
                                    id: report.id ?? '',
                                    label: report.id ?? 'Report',
                                    values: report.toJson(),
                                  ),
                                  template: const {
                                    'description': '',
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
                                        .updateReport(
                                            id, Report.fromJson(payload));
                                  },
                                  onDelete: (id) async {
                                    final apiToken = await ref
                                        .read(secureStorageProvider)
                                        .getApiToken();
                                    await ref
                                        .read(apiServiceProvider(apiToken))
                                        .deleteReport(id);
                                  },
                                  onCompleted: () {
                                    ref.invalidate(
                                      reportsResponseProvider(
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
                ref.read(reportsPageSizeProvider.notifier).state = value;
                ref.read(reportsPageProvider.notifier).state = 1;
              },
              onSearchChanged: (value) {
                ref.read(reportsSearchProvider.notifier).state = value.trim();
                ref.read(reportsPageProvider.notifier).state = 1;
              },
              onPrevious: currentPage > 1
                  ? () => ref.read(reportsPageProvider.notifier).state =
                      currentPage - 1
                  : null,
              onNext: currentPage < totalPages
                  ? () => ref.read(reportsPageProvider.notifier).state =
                      currentPage + 1
                  : null,
            ),
          ],
        );
      },
      error: (error, stackTrace) => const Center(
        child: Text('Error while loading reports'),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }
}
