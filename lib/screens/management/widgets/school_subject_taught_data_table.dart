import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hooks_riverpod/legacy.dart';
import 'package:learnflow_backoffice/dto/school_subject_taughts_response.dto.dart';
import 'package:learnflow_backoffice/screens/management/widgets/management_pagination_controls.dart';
import 'package:learnflow_backoffice/services/api/api_service.dart';
import 'package:learnflow_backoffice/services/authentication/secure_storage.dart';

final subjectTaughtsPageProvider = StateProvider.autoDispose<int>((ref) => 1);
final subjectTaughtsPageSizeProvider =
    StateProvider.autoDispose<int>((ref) => 10);
final subjectTaughtsSearchProvider =
    StateProvider.autoDispose<String>((ref) => '');

final subjectTaughtsResponseProvider = FutureProvider.autoDispose.family<
    SchoolSubjectTaughtsResponse,
    ({int page, int pageSize, String search})>((ref, params) async {
  final apiToken = await ref.watch(secureStorageProvider).getApiToken();
  final apiService = ref.read(apiServiceProvider(apiToken));
  return apiService.getSchoolSubjectTaughts(
    page: params.page,
    limit: params.pageSize,
    search: params.search.isEmpty ? null : params.search,
  );
});

class SchoolSubjectTaughtDataTable extends ConsumerWidget {
  const SchoolSubjectTaughtDataTable({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final page = ref.watch(subjectTaughtsPageProvider);
    final pageSize = ref.watch(subjectTaughtsPageSizeProvider);
    final search = ref.watch(subjectTaughtsSearchProvider);
    final responseAsync = ref.watch(
      subjectTaughtsResponseProvider(
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
                      DataColumn(label: Text('Teacher')),
                      DataColumn(label: Text('Subject')),
                      DataColumn(label: Text('Years Of Experience')),
                    ],
                    rows: items
                        .map(
                          (item) => DataRow(
                            cells: [
                              DataCell(Text(
                                  '${item.teacher?.firstName ?? ''} ${item.teacher?.lastName ?? ''}'
                                      .trim())),
                              DataCell(Text(item.schoolSubject?.name ?? '')),
                              DataCell(Text(
                                  item.yearsOfExperience?.toString() ?? '')),
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
                ref.read(subjectTaughtsPageSizeProvider.notifier).state = value;
                ref.read(subjectTaughtsPageProvider.notifier).state = 1;
              },
              onSearchChanged: (value) {
                ref.read(subjectTaughtsSearchProvider.notifier).state =
                    value.trim();
                ref.read(subjectTaughtsPageProvider.notifier).state = 1;
              },
              onPrevious: currentPage > 1
                  ? () => ref.read(subjectTaughtsPageProvider.notifier).state =
                      currentPage - 1
                  : null,
              onNext: currentPage < totalPages
                  ? () => ref.read(subjectTaughtsPageProvider.notifier).state =
                      currentPage + 1
                  : null,
            ),
          ],
        );
      },
      error: (error, stackTrace) => const Center(
        child: Text('Error while loading school subject taughts'),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }
}
