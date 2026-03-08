import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hooks_riverpod/legacy.dart';
import 'package:intl/intl.dart';
import 'package:learnflow_backoffice/dto/justificatives_response.dto.dart';
import 'package:learnflow_backoffice/models/justificative.dart';
import 'package:learnflow_backoffice/screens/management/widgets/entity_crud_panel.dart';
import 'package:learnflow_backoffice/screens/management/widgets/management_pagination_controls.dart';
import 'package:learnflow_backoffice/services/api/api_service.dart';
import 'package:learnflow_backoffice/services/authentication/secure_storage.dart';

final justificativesPageProvider = StateProvider.autoDispose<int>((ref) => 1);
final justificativesPageSizeProvider =
    StateProvider.autoDispose<int>((ref) => 10);
final justificativesSearchProvider =
    StateProvider.autoDispose<String>((ref) => '');

final justificativesResponseProvider = FutureProvider.autoDispose
    .family<JustificativesResponse, ({int page, int pageSize, String search})>(
        (ref, params) async {
  final apiToken = await ref.watch(secureStorageProvider).getApiToken();
  final apiService = ref.read(apiServiceProvider(apiToken));
  return apiService.getJustificatives(
    page: params.page,
    limit: params.pageSize,
    search: params.search.isEmpty ? null : params.search,
  );
});

class JustificativeDataTable extends ConsumerWidget {
  const JustificativeDataTable({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final page = ref.watch(justificativesPageProvider);
    final pageSize = ref.watch(justificativesPageSizeProvider);
    final search = ref.watch(justificativesSearchProvider);
    final responseAsync = ref.watch(
      justificativesResponseProvider(
        (page: page, pageSize: pageSize, search: search),
      ),
    );
    final formatter = DateFormat('yyyy-MM-dd');

    return responseAsync.when(
      data: (response) {
        final items = response.data ?? const [];
        final meta = response.meta;
        final currentPage = meta?.page ?? page;
        final totalPages = (meta?.totalPages ?? 1) < 1 ? 1 : meta!.totalPages!;

        return Column(
          children: [
            EntityCrudPanel(
              entityLabel: 'Justificative',
              createTemplate: const {
                'description': '',
                'isAccepted': false,
              },
              onCreate: (json) async {
                final apiToken =
                    await ref.read(secureStorageProvider).getApiToken();
                await ref
                    .read(apiServiceProvider(apiToken))
                    .createJustificative(Justificative.fromJson(json));
              },
              onCompleted: () {
                ref.invalidate(
                  justificativesResponseProvider(
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
                      DataColumn(label: Text('Start')),
                      DataColumn(label: Text('End')),
                      DataColumn(label: Text('Comment')),
                      DataColumn(label: Text('Upload URL')),
                      DataColumn(label: Text('Actions')),
                    ],
                    rows: items
                        .map(
                          (item) => DataRow(
                            cells: [
                              DataCell(Text(item.startDate == null
                                  ? ''
                                  : formatter
                                      .format(item.startDate!.toLocal()))),
                              DataCell(Text(item.endDate == null
                                  ? ''
                                  : formatter.format(item.endDate!.toLocal()))),
                              DataCell(Text(item.comment ?? '')),
                              DataCell(Text(item.uploadUrl ?? '')),
                              DataCell(
                                EntityRowActionsMenu(
                                  entityLabel: 'Justificative',
                                  option: EntityUpdateOption(
                                    id: item.id ?? '',
                                    label: item.id ?? 'Justificative',
                                    values: item.toJson(),
                                  ),
                                  template: const {
                                    'description': '',
                                    'isAccepted': false,
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
                                        .updateJustificative(id,
                                            Justificative.fromJson(payload));
                                  },
                                  onDelete: (id) async {
                                    final apiToken = await ref
                                        .read(secureStorageProvider)
                                        .getApiToken();
                                    await ref
                                        .read(apiServiceProvider(apiToken))
                                        .deleteJustificative(id);
                                  },
                                  onCompleted: () {
                                    ref.invalidate(
                                      justificativesResponseProvider(
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
                ref.read(justificativesPageSizeProvider.notifier).state = value;
                ref.read(justificativesPageProvider.notifier).state = 1;
              },
              onSearchChanged: (value) {
                ref.read(justificativesSearchProvider.notifier).state =
                    value.trim();
                ref.read(justificativesPageProvider.notifier).state = 1;
              },
              onPrevious: currentPage > 1
                  ? () => ref.read(justificativesPageProvider.notifier).state =
                      currentPage - 1
                  : null,
              onNext: currentPage < totalPages
                  ? () => ref.read(justificativesPageProvider.notifier).state =
                      currentPage + 1
                  : null,
            ),
          ],
        );
      },
      error: (error, stackTrace) => const Center(
        child: Text('Error while loading justificatives'),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }
}
