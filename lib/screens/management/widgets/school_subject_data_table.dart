import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hooks_riverpod/legacy.dart';
import 'package:learnflow_backoffice/dto/school_subjects_response.dto.dart';
import 'package:learnflow_backoffice/screens/management/widgets/management_pagination_controls.dart';
import 'package:learnflow_backoffice/services/api/api_service.dart';
import 'package:learnflow_backoffice/services/authentication/secure_storage.dart';

final schoolSubjectsPageProvider = StateProvider.autoDispose<int>((ref) => 1);
final schoolSubjectsPageSizeProvider =
    StateProvider.autoDispose<int>((ref) => 10);
final schoolSubjectsSearchProvider =
    StateProvider.autoDispose<String>((ref) => '');

final schoolSubjectsResponseProvider = FutureProvider.autoDispose
    .family<SchoolSubjectsResponse, ({int page, int pageSize, String search})>(
        (ref, params) async {
  final apiToken = await ref.watch(secureStorageProvider).getApiToken();
  final apiService = ref.read(apiServiceProvider(apiToken));
  return apiService.getSchoolSubjects(
    page: params.page,
    limit: params.pageSize,
    search: params.search.isEmpty ? null : params.search,
  );
});

class SchoolSubjectDataTable extends ConsumerWidget {
  const SchoolSubjectDataTable({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final page = ref.watch(schoolSubjectsPageProvider);
    final pageSize = ref.watch(schoolSubjectsPageSizeProvider);
    final search = ref.watch(schoolSubjectsSearchProvider);
    final responseAsync = ref.watch(
      schoolSubjectsResponseProvider(
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
            Expanded(
              child: ListView(
                children: [
                  DataTable(
                    columns: const [
                      DataColumn(label: Text('ID')),
                      DataColumn(label: Text('Name')),
                    ],
                    rows: items
                        .map(
                          (subject) => DataRow(
                            cells: [
                              DataCell(Text(subject.id ?? '')),
                              DataCell(Text(subject.name ?? '')),
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
                ref.read(schoolSubjectsPageSizeProvider.notifier).state = value;
                ref.read(schoolSubjectsPageProvider.notifier).state = 1;
              },
              onSearchChanged: (value) {
                ref.read(schoolSubjectsSearchProvider.notifier).state =
                    value.trim();
                ref.read(schoolSubjectsPageProvider.notifier).state = 1;
              },
              onPrevious: currentPage > 1
                  ? () => ref.read(schoolSubjectsPageProvider.notifier).state =
                      currentPage - 1
                  : null,
              onNext: currentPage < totalPages
                  ? () => ref.read(schoolSubjectsPageProvider.notifier).state =
                      currentPage + 1
                  : null,
            ),
          ],
        );
      },
      error: (error, stackTrace) => const Center(
        child: Text('Error while loading school subjects'),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }
}
