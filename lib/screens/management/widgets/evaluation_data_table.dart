import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hooks_riverpod/legacy.dart';
import 'package:learnflow_backoffice/dto/evaluations_response.dto.dart';
import 'package:learnflow_backoffice/models/evaluation.dart';
import 'package:learnflow_backoffice/screens/management/widgets/entity_crud_panel.dart';
import 'package:learnflow_backoffice/screens/management/widgets/management_pagination_controls.dart';
import 'package:learnflow_backoffice/services/api/api_service.dart';
import 'package:learnflow_backoffice/services/authentication/secure_storage.dart';

final evaluationsPageProvider = StateProvider.autoDispose<int>((ref) => 1);
final evaluationsPageSizeProvider = StateProvider.autoDispose<int>((ref) => 10);
final evaluationsSearchProvider =
    StateProvider.autoDispose<String>((ref) => '');

final evaluationsResponseProvider = FutureProvider.autoDispose
    .family<EvaluationsResponse, ({int page, int pageSize, String search})>(
        (ref, params) async {
  final apiToken = await ref.watch(secureStorageProvider).getApiToken();
  final apiService = ref.read(apiServiceProvider(apiToken));
  return apiService.getEvaluations(
    page: params.page,
    limit: params.pageSize,
    search: params.search.isEmpty ? null : params.search,
  );
});

class EvaluationDataTable extends ConsumerWidget {
  const EvaluationDataTable({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final page = ref.watch(evaluationsPageProvider);
    final pageSize = ref.watch(evaluationsPageSizeProvider);
    final search = ref.watch(evaluationsSearchProvider);
    final responseAsync = ref.watch(
      evaluationsResponseProvider(
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
              entityLabel: 'Evaluation',
              createTemplate: const {
                'description': '',
                'isValidated': false,
              },
              onCreate: (json) async {
                final apiToken =
                    await ref.read(secureStorageProvider).getApiToken();
                await ref
                    .read(apiServiceProvider(apiToken))
                    .createEvaluation(Evaluation.fromJson(json));
              },
              onCompleted: () {
                ref.invalidate(
                  evaluationsResponseProvider(
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
                      DataColumn(label: Text('Subject')),
                      DataColumn(label: Text('Student')),
                      DataColumn(label: Text('Teacher')),
                      DataColumn(label: Text('Note')),
                      DataColumn(label: Text('Actions')),
                    ],
                    rows: items
                        .map(
                          (evaluation) => DataRow(
                            cells: [
                              DataCell(Text(evaluation.subject?.name ?? '')),
                              DataCell(Text(
                                  '${evaluation.student?.firstName ?? ''} ${evaluation.student?.lastName ?? ''}'
                                      .trim())),
                              DataCell(Text(
                                  '${evaluation.teacher?.firstName ?? ''} ${evaluation.teacher?.lastName ?? ''}'
                                      .trim())),
                              DataCell(Text(evaluation.note ?? '')),
                              DataCell(
                                EntityRowActionsMenu(
                                  entityLabel: 'Evaluation',
                                  option: EntityUpdateOption(
                                    id: evaluation.id ?? '',
                                    label: evaluation.id ?? 'Evaluation',
                                    values: evaluation.toJson(),
                                  ),
                                  template: const {
                                    'description': '',
                                    'isValidated': false,
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
                                        .updateEvaluation(
                                            id, Evaluation.fromJson(payload));
                                  },
                                  onDelete: (id) async {
                                    final apiToken = await ref
                                        .read(secureStorageProvider)
                                        .getApiToken();
                                    await ref
                                        .read(apiServiceProvider(apiToken))
                                        .deleteEvaluation(id);
                                  },
                                  onCompleted: () {
                                    ref.invalidate(
                                      evaluationsResponseProvider(
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
                ref.read(evaluationsPageSizeProvider.notifier).state = value;
                ref.read(evaluationsPageProvider.notifier).state = 1;
              },
              onSearchChanged: (value) {
                ref.read(evaluationsSearchProvider.notifier).state =
                    value.trim();
                ref.read(evaluationsPageProvider.notifier).state = 1;
              },
              onPrevious: currentPage > 1
                  ? () => ref.read(evaluationsPageProvider.notifier).state =
                      currentPage - 1
                  : null,
              onNext: currentPage < totalPages
                  ? () => ref.read(evaluationsPageProvider.notifier).state =
                      currentPage + 1
                  : null,
            ),
          ],
        );
      },
      error: (error, stackTrace) => const Center(
        child: Text('Error while loading evaluations'),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }
}
