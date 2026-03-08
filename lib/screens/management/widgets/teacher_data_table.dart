import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hooks_riverpod/legacy.dart';
import 'package:intl/intl.dart';
import 'package:learnflow_backoffice/dto/teachers_response.dto.dart';
import 'package:learnflow_backoffice/models/teacher.dart';
import 'package:learnflow_backoffice/screens/management/widgets/entity_crud_panel.dart';
import 'package:learnflow_backoffice/screens/management/widgets/management_pagination_controls.dart';
import 'package:learnflow_backoffice/services/api/api_service.dart';
import 'package:learnflow_backoffice/services/authentication/secure_storage.dart';

final teachersPageProvider = StateProvider.autoDispose<int>((ref) => 1);
final teachersPageSizeProvider = StateProvider.autoDispose<int>((ref) => 10);
final teachersSearchProvider = StateProvider.autoDispose<String>((ref) => '');

final teachersResponseProvider = FutureProvider.autoDispose
    .family<TeachersResponse, ({int page, int pageSize, String search})>(
        (ref, params) async {
  final apiToken = await ref.watch(secureStorageProvider).getApiToken();
  final apiService = ref.read(apiServiceProvider(apiToken));
  return apiService.getTeachers(
    page: params.page,
    limit: params.pageSize,
    search: params.search.isEmpty ? null : params.search,
  );
});

class TeacherDataTable extends ConsumerWidget {
  const TeacherDataTable({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final page = ref.watch(teachersPageProvider);
    final pageSize = ref.watch(teachersPageSizeProvider);
    final search = ref.watch(teachersSearchProvider);
    final responseAsync = ref.watch(
      teachersResponseProvider(
        (page: page, pageSize: pageSize, search: search),
      ),
    );

    return responseAsync.when(
      data: (response) {
        final teachers = response.data ?? const [];
        final meta = response.meta;
        final currentPage = meta?.page ?? page;
        final totalPages = meta?.totalPages == null || meta!.totalPages! < 1
            ? 1
            : meta.totalPages!;

        return Column(
          children: [
            EntityCrudPanel(
              entityLabel: 'Teacher',
              createTemplate: const {
                'firstName': '',
                'lastName': '',
                'email': '',
                'isValidated': false,
              },
              onCreate: (json) async {
                final apiToken =
                    await ref.read(secureStorageProvider).getApiToken();
                await ref
                    .read(apiServiceProvider(apiToken))
                    .createTeacher(Teacher.fromJson(json));
              },
              onCompleted: () {
                ref.invalidate(
                  teachersResponseProvider(
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
                      DataColumn(label: Text('Birthdate')),
                      DataColumn(label: Text('Email')),
                      DataColumn(label: Text('Phone')),
                      DataColumn(label: Text('Validated')),
                      DataColumn(label: Text('City')),
                      DataColumn(label: Text('Actions')),
                    ],
                    rows: teachers
                        .map(
                          (teacher) => DataRow(
                            cells: [
                              DataCell(Text(teacher.firstName ?? '')),
                              DataCell(Text(teacher.lastName ?? '')),
                              DataCell(
                                Text(
                                  teacher.birthdate == null
                                      ? ''
                                      : DateFormat('yyyy-MM-dd')
                                          .format(teacher.birthdate!.toLocal()),
                                ),
                              ),
                              DataCell(Text(teacher.email ?? '')),
                              DataCell(Text(teacher.phoneNumber ?? '')),
                              DataCell(Text((teacher.isValidated ?? false)
                                  ? 'Yes'
                                  : 'No')),
                              DataCell(Text(teacher.address?.city ?? '')),
                              DataCell(
                                EntityRowActionsMenu(
                                  entityLabel: 'Teacher',
                                  option: EntityUpdateOption(
                                    id: teacher.id ?? '',
                                    label: teacher.email ??
                                        teacher.id ??
                                        'Teacher',
                                    values: teacher.toJson(),
                                  ),
                                  template: const {
                                    'firstName': '',
                                    'lastName': '',
                                    'email': '',
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
                                        .updateTeacher(
                                            id, Teacher.fromJson(payload));
                                  },
                                  onDelete: (id) async {
                                    final apiToken = await ref
                                        .read(secureStorageProvider)
                                        .getApiToken();
                                    await ref
                                        .read(apiServiceProvider(apiToken))
                                        .deleteTeacher(id);
                                  },
                                  onCompleted: () {
                                    ref.invalidate(
                                      teachersResponseProvider(
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
                ref.read(teachersPageSizeProvider.notifier).state = value;
                ref.read(teachersPageProvider.notifier).state = 1;
              },
              onSearchChanged: (value) {
                ref.read(teachersSearchProvider.notifier).state = value.trim();
                ref.read(teachersPageProvider.notifier).state = 1;
              },
              onPrevious: currentPage > 1
                  ? () => ref.read(teachersPageProvider.notifier).state =
                      currentPage - 1
                  : null,
              onNext: currentPage < totalPages
                  ? () => ref.read(teachersPageProvider.notifier).state =
                      currentPage + 1
                  : null,
            ),
          ],
        );
      },
      error: (error, stackTrace) => const Center(
        child: Text('Error while loading teachers'),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }
}
