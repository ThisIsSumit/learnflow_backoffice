import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hooks_riverpod/legacy.dart';
import 'package:learnflow_backoffice/dto/moderators_response.dto.dart';
import 'package:learnflow_backoffice/models/moderator.dart';
import 'package:learnflow_backoffice/screens/management/widgets/entity_crud_panel.dart';
import 'package:learnflow_backoffice/screens/management/widgets/management_pagination_controls.dart';
import 'package:learnflow_backoffice/services/api/api_service.dart';
import 'package:learnflow_backoffice/services/authentication/secure_storage.dart';

final moderatorsPageProvider = StateProvider.autoDispose<int>((ref) => 1);
final moderatorsPageSizeProvider = StateProvider.autoDispose<int>((ref) => 10);
final moderatorsSearchProvider = StateProvider.autoDispose<String>((ref) => '');

final moderatorsResponseProvider = FutureProvider.autoDispose
    .family<ModeratorsResponse, ({int page, int pageSize, String search})>(
        (ref, params) async {
  final apiToken = await ref.watch(secureStorageProvider).getApiToken();
  final apiService = ref.read(apiServiceProvider(apiToken));
  return apiService.getModerators(
    page: params.page,
    limit: params.pageSize,
    search: params.search.isEmpty ? null : params.search,
  );
});

class ModeratorDataTable extends ConsumerWidget {
  const ModeratorDataTable({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final page = ref.watch(moderatorsPageProvider);
    final pageSize = ref.watch(moderatorsPageSizeProvider);
    final search = ref.watch(moderatorsSearchProvider);
    final responseAsync = ref.watch(
      moderatorsResponseProvider(
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
              entityLabel: 'Moderator',
              createTemplate: const {
                'firstName': '',
                'lastName': '',
                'email': '',
              },
              onCreate: (json) async {
                final apiToken =
                    await ref.read(secureStorageProvider).getApiToken();
                await ref
                    .read(apiServiceProvider(apiToken))
                    .createModerator(Moderator.fromJson(json));
              },
              onCompleted: () {
                ref.invalidate(
                  moderatorsResponseProvider(
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
                      DataColumn(label: Text('First Name')),
                      DataColumn(label: Text('Last Name')),
                      DataColumn(label: Text('Email')),
                      DataColumn(label: Text('Actions')),
                    ],
                    rows: items
                        .map(
                          (moderator) => DataRow(
                            cells: [
                              DataCell(Text(moderator.firstName ?? '')),
                              DataCell(Text(moderator.lastName ?? '')),
                              DataCell(Text(moderator.email ?? '')),
                              DataCell(
                                EntityRowActionsMenu(
                                  entityLabel: 'Moderator',
                                  option: EntityUpdateOption(
                                    id: moderator.id ?? '',
                                    label: moderator.email ??
                                        moderator.id ??
                                        'Moderator',
                                    values: moderator.toJson(),
                                  ),
                                  template: const {
                                    'firstName': '',
                                    'lastName': '',
                                    'email': '',
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
                                        .updateModerator(
                                            id, Moderator.fromJson(payload));
                                  },
                                  onDelete: (id) async {
                                    final apiToken = await ref
                                        .read(secureStorageProvider)
                                        .getApiToken();
                                    await ref
                                        .read(apiServiceProvider(apiToken))
                                        .deleteModerator(id);
                                  },
                                  onCompleted: () {
                                    ref.invalidate(
                                      moderatorsResponseProvider(
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
                ref.read(moderatorsPageSizeProvider.notifier).state = value;
                ref.read(moderatorsPageProvider.notifier).state = 1;
              },
              onSearchChanged: (value) {
                ref.read(moderatorsSearchProvider.notifier).state =
                    value.trim();
                ref.read(moderatorsPageProvider.notifier).state = 1;
              },
              onPrevious: currentPage > 1
                  ? () => ref.read(moderatorsPageProvider.notifier).state =
                      currentPage - 1
                  : null,
              onNext: currentPage < totalPages
                  ? () => ref.read(moderatorsPageProvider.notifier).state =
                      currentPage + 1
                  : null,
            ),
          ],
        );
      },
      error: (error, stackTrace) => const Center(
        child: Text('Error while loading moderators'),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }
}
