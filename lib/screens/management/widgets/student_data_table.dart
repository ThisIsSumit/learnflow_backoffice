import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hooks_riverpod/legacy.dart';
import 'package:intl/intl.dart';
import 'package:learnflow_backoffice/screens/management/widgets/management_table_scaffold.dart';
import 'package:learnflow_backoffice/screens/management/widgets/entity_crud_panel.dart';
import 'package:learnflow_backoffice/dto/students_response.dto.dart';
import 'package:learnflow_backoffice/models/student.dart';
import 'package:learnflow_backoffice/services/api/api_service.dart';
import 'package:learnflow_backoffice/services/authentication/secure_storage.dart';

final studentsPageProvider = StateProvider.autoDispose<int>((ref) => 1);
final studentsPageSizeProvider = StateProvider.autoDispose<int>((ref) => 10);
final studentsSearchProvider = StateProvider.autoDispose<String>((ref) => '');

final studentsResponseProvider = FutureProvider.autoDispose
    .family<StudentsResponse, ({int page, int pageSize, String search})>(
        (ref, params) async {
  final apiToken = await ref.watch(secureStorageProvider).getApiToken();
  final apiService = ref.read(apiServiceProvider(apiToken));
  return apiService.getStudents(
    page: params.page,
    limit: params.pageSize,
    search: params.search.isEmpty ? null : params.search,
  );
});

class StudentDataTable extends ConsumerWidget {
  const StudentDataTable({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final page = ref.watch(studentsPageProvider);
    final pageSize = ref.watch(studentsPageSizeProvider);
    final search = ref.watch(studentsSearchProvider);
    final responseAsync = ref.watch(
      studentsResponseProvider(
        (page: page, pageSize: pageSize, search: search),
      ),
    );

    return responseAsync.when(
      data: (response) {
        final students = response.data ?? const [];
        final meta = response.meta;
        final currentPage = meta?.page ?? page;
        final totalPages = (meta?.totalPages ?? 1) < 1 ? 1 : meta!.totalPages!;

        return Column(
          children: [
            EntityCrudPanel(
              entityLabel: 'Student',
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
                    .createStudent(Student.fromJson(json));
              },
              onCompleted: () {
                ref.invalidate(
                  studentsResponseProvider(
                    (page: page, pageSize: pageSize, search: search),
                  ),
                );
              },
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ManagementTableScaffold(
                table: DataTable(
                  columns: const [
                    DataColumn(label: Text('First Name')),
                    DataColumn(label: Text('Last Name')),
                    DataColumn(label: Text('Birthdate')),
                    DataColumn(label: Text('Email')),
                    DataColumn(label: Text('Phone')),
                    DataColumn(label: Text('School Level')),
                    DataColumn(label: Text('City')),
                    DataColumn(label: Text('Actions')),
                  ],
                  rows: students
                      .map(
                        (student) => DataRow(
                          cells: [
                            DataCell(Text(student.firstName ?? '')),
                            DataCell(Text(student.lastName ?? '')),
                            DataCell(
                              Text(
                                student.birthdate == null
                                    ? ''
                                    : DateFormat('yyyy-MM-dd')
                                        .format(student.birthdate!.toLocal()),
                              ),
                            ),
                            DataCell(Text(student.email ?? '')),
                            DataCell(Text(student.phoneNumber ?? '')),
                            DataCell(Text(student.schoolLevel ?? '')),
                            DataCell(Text(student.address?.city ?? '')),
                            DataCell(
                              EntityRowActionsMenu(
                                entityLabel: 'Student',
                                option: EntityUpdateOption(
                                  id: student.id ?? '',
                                  label:
                                      student.email ?? student.id ?? 'Student',
                                  values: student.toJson(),
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
                                      .updateStudent(
                                          id, Student.fromJson(payload));
                                },
                                onDelete: (id) async {
                                  final apiToken = await ref
                                      .read(secureStorageProvider)
                                      .getApiToken();
                                  await ref
                                      .read(apiServiceProvider(apiToken))
                                      .deleteStudent(id);
                                },
                                onCompleted: () {
                                  ref.invalidate(
                                    studentsResponseProvider(
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
                page: currentPage,
                totalPages: totalPages,
                totalItems: meta?.total,
                pageSize: pageSize,
                searchText: search,
                onPageSizeChanged: (value) {
                  ref.read(studentsPageSizeProvider.notifier).state = value;
                  ref.read(studentsPageProvider.notifier).state = 1;
                },
                onSearchChanged: (value) {
                  ref.read(studentsSearchProvider.notifier).state =
                      value.trim();
                  ref.read(studentsPageProvider.notifier).state = 1;
                },
                onPrevious: currentPage > 1
                    ? () => ref.read(studentsPageProvider.notifier).state =
                        currentPage - 1
                    : null,
                onNext: currentPage < totalPages
                    ? () => ref.read(studentsPageProvider.notifier).state =
                        currentPage + 1
                    : null,
              ),
            ),
          ],
        );
      },
      error: (error, stackTrace) => const Center(
        child: Text('Error while loading students'),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }
}
