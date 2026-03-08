import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hooks_riverpod/legacy.dart';
import 'package:learnflow_backoffice/dto/documents_response.dto.dart';
import 'package:learnflow_backoffice/models/document.dart';
import 'package:learnflow_backoffice/screens/management/widgets/entity_crud_panel.dart';
import 'package:learnflow_backoffice/screens/management/widgets/management_pagination_controls.dart';
import 'package:learnflow_backoffice/services/api/api_service.dart';
import 'package:learnflow_backoffice/services/authentication/secure_storage.dart';

final documentsPageProvider = StateProvider.autoDispose<int>((ref) => 1);
final documentsPageSizeProvider = StateProvider.autoDispose<int>((ref) => 10);
final documentsSearchProvider = StateProvider.autoDispose<String>((ref) => '');

final documentsResponseProvider = FutureProvider.autoDispose
    .family<DocumentsResponse, ({int page, int pageSize, String search})>(
        (ref, params) async {
  final apiToken = await ref.watch(secureStorageProvider).getApiToken();
  final apiService = ref.read(apiServiceProvider(apiToken));
  return apiService.getDocuments(
    page: params.page,
    limit: params.pageSize,
    search: params.search.isEmpty ? null : params.search,
  );
});

class DocumentDataTable extends ConsumerWidget {
  const DocumentDataTable({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final page = ref.watch(documentsPageProvider);
    final pageSize = ref.watch(documentsPageSizeProvider);
    final search = ref.watch(documentsSearchProvider);
    final responseAsync = ref.watch(
      documentsResponseProvider(
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
              entityLabel: 'Document',
              createTemplate: const {
                'name': '',
                'description': '',
              },
              onCreate: (json) async {
                final apiToken =
                    await ref.read(secureStorageProvider).getApiToken();
                await ref
                    .read(apiServiceProvider(apiToken))
                    .createDocument(Document.fromJson(json));
              },
              onCompleted: () {
                ref.invalidate(
                  documentsResponseProvider(
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
                      DataColumn(label: Text('Upload URL')),
                      DataColumn(label: Text('Type')),
                      DataColumn(label: Text('Actions')),
                    ],
                    rows: items
                        .map(
                          (document) => DataRow(
                            cells: [
                              DataCell(Text(document.id ?? '')),
                              DataCell(Text(document.uploadUrl ?? '')),
                              DataCell(Text(document.documentType?.name ?? '')),
                              DataCell(
                                EntityRowActionsMenu(
                                  entityLabel: 'Document',
                                  option: EntityUpdateOption(
                                    id: document.id ?? '',
                                    label: document.id ?? 'Document',
                                    values: document.toJson(),
                                  ),
                                  template: const {
                                    'name': '',
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
                                        .updateDocument(
                                            id, Document.fromJson(payload));
                                  },
                                  onDelete: (id) async {
                                    final apiToken = await ref
                                        .read(secureStorageProvider)
                                        .getApiToken();
                                    await ref
                                        .read(apiServiceProvider(apiToken))
                                        .deleteDocument(id);
                                  },
                                  onCompleted: () {
                                    ref.invalidate(
                                      documentsResponseProvider(
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
                ref.read(documentsPageSizeProvider.notifier).state = value;
                ref.read(documentsPageProvider.notifier).state = 1;
              },
              onSearchChanged: (value) {
                ref.read(documentsSearchProvider.notifier).state = value.trim();
                ref.read(documentsPageProvider.notifier).state = 1;
              },
              onPrevious: currentPage > 1
                  ? () => ref.read(documentsPageProvider.notifier).state =
                      currentPage - 1
                  : null,
              onNext: currentPage < totalPages
                  ? () => ref.read(documentsPageProvider.notifier).state =
                      currentPage + 1
                  : null,
            ),
          ],
        );
      },
      error: (error, stackTrace) => const Center(
        child: Text('Error while loading documents'),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }
}
