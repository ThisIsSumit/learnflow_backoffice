import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hooks_riverpod/legacy.dart';
import 'package:learnflow_backoffice/dto/ratings_response.dto.dart';
import 'package:learnflow_backoffice/screens/management/widgets/management_pagination_controls.dart';
import 'package:learnflow_backoffice/services/api/api_service.dart';
import 'package:learnflow_backoffice/services/authentication/secure_storage.dart';

final ratingsPageProvider = StateProvider.autoDispose<int>((ref) => 1);
final ratingsPageSizeProvider = StateProvider.autoDispose<int>((ref) => 10);
final ratingsSearchProvider = StateProvider.autoDispose<String>((ref) => '');

final ratingsResponseProvider = FutureProvider.autoDispose
    .family<RatingsResponse, ({int page, int pageSize, String search})>(
        (ref, params) async {
  final apiToken = await ref.watch(secureStorageProvider).getApiToken();
  final apiService = ref.read(apiServiceProvider(apiToken));
  return apiService.getRatings(
    page: params.page,
    limit: params.pageSize,
    search: params.search.isEmpty ? null : params.search,
  );
});

class RatingDataTable extends ConsumerWidget {
  const RatingDataTable({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final page = ref.watch(ratingsPageProvider);
    final pageSize = ref.watch(ratingsPageSizeProvider);
    final search = ref.watch(ratingsSearchProvider);
    final responseAsync = ref.watch(
      ratingsResponseProvider((page: page, pageSize: pageSize, search: search)),
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
                      DataColumn(label: Text('Student')),
                      DataColumn(label: Text('Teacher')),
                      DataColumn(label: Text('Note')),
                    ],
                    rows: items
                        .map(
                          (rating) => DataRow(
                            cells: [
                              DataCell(Text(
                                  '${rating.student?.firstName ?? ''} ${rating.student?.lastName ?? ''}'
                                      .trim())),
                              DataCell(Text(
                                  '${rating.teacher?.firstName ?? ''} ${rating.teacher?.lastName ?? ''}'
                                      .trim())),
                              DataCell(Text(rating.note?.toString() ?? '')),
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
                ref.read(ratingsPageSizeProvider.notifier).state = value;
                ref.read(ratingsPageProvider.notifier).state = 1;
              },
              onSearchChanged: (value) {
                ref.read(ratingsSearchProvider.notifier).state = value.trim();
                ref.read(ratingsPageProvider.notifier).state = 1;
              },
              onPrevious: currentPage > 1
                  ? () => ref.read(ratingsPageProvider.notifier).state =
                      currentPage - 1
                  : null,
              onNext: currentPage < totalPages
                  ? () => ref.read(ratingsPageProvider.notifier).state =
                      currentPage + 1
                  : null,
            ),
          ],
        );
      },
      error: (error, stackTrace) => const Center(
        child: Text('Error while loading ratings'),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }
}
