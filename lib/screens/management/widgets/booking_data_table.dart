import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hooks_riverpod/legacy.dart';
import 'package:intl/intl.dart';
import 'package:learnflow_backoffice/dto/bookings_response.dto.dart';
import 'package:learnflow_backoffice/models/booking.dart';
import 'package:learnflow_backoffice/screens/management/widgets/entity_crud_panel.dart';
import 'package:learnflow_backoffice/screens/management/widgets/management_pagination_controls.dart';
import 'package:learnflow_backoffice/services/api/api_service.dart';
import 'package:learnflow_backoffice/services/authentication/secure_storage.dart';

final bookingsPageProvider = StateProvider.autoDispose<int>((ref) => 1);
final bookingsPageSizeProvider = StateProvider.autoDispose<int>((ref) => 10);
final bookingsSearchProvider = StateProvider.autoDispose<String>((ref) => '');

final bookingsResponseProvider = FutureProvider.autoDispose
    .family<BookingsResponse, ({int page, int pageSize, String search})>(
        (ref, params) async {
  final apiToken = await ref.watch(secureStorageProvider).getApiToken();
  final apiService = ref.read(apiServiceProvider(apiToken));
  return apiService.getBookings(
    page: params.page,
    limit: params.pageSize,
    search: params.search.isEmpty ? null : params.search,
  );
});

class BookingDataTable extends ConsumerWidget {
  const BookingDataTable({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final page = ref.watch(bookingsPageProvider);
    final pageSize = ref.watch(bookingsPageSizeProvider);
    final search = ref.watch(bookingsSearchProvider);
    final responseAsync = ref.watch(
      bookingsResponseProvider(
          (page: page, pageSize: pageSize, search: search)),
    );

    return responseAsync.when(
      data: (response) {
        final bookings = response.data ?? const [];
        final meta = response.meta;
        final currentPage = meta?.page ?? page;
        final totalPages = meta?.totalPages == null || meta!.totalPages! < 1
            ? 1
            : meta.totalPages!;
        final formatter = DateFormat('yyyy-MM-dd HH:mm');

        return Column(
          children: [
            EntityCrudPanel(
              entityLabel: 'Booking',
              createTemplate: const {
                'startDate': '',
                'endDate': '',
                'isAccepted': false,
              },
              onCreate: (json) async {
                final apiToken =
                    await ref.read(secureStorageProvider).getApiToken();
                await ref
                    .read(apiServiceProvider(apiToken))
                    .createBooking(Booking.fromJson(json));
              },
              onCompleted: () {
                ref.invalidate(
                  bookingsResponseProvider(
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
                      DataColumn(label: Text('Accepted')),
                      DataColumn(label: Text('Subject')),
                      DataColumn(label: Text('Student')),
                      DataColumn(label: Text('Teacher')),
                      DataColumn(label: Text('Payment')),
                      DataColumn(label: Text('Actions')),
                    ],
                    rows: bookings
                        .map(
                          (booking) => DataRow(
                            cells: [
                              DataCell(Text(booking.startDate == null
                                  ? ''
                                  : formatter
                                      .format(booking.startDate!.toLocal()))),
                              DataCell(Text(booking.endDate == null
                                  ? ''
                                  : formatter
                                      .format(booking.endDate!.toLocal()))),
                              DataCell(Text((booking.isAccepted ?? false)
                                  ? 'Yes'
                                  : 'No')),
                              DataCell(Text(booking.schoolSubject?.name ?? '')),
                              DataCell(Text(
                                  '${booking.student?.firstName ?? ''} ${booking.student?.lastName ?? ''}'
                                      .trim())),
                              DataCell(Text(
                                  '${booking.teacher?.firstName ?? ''} ${booking.teacher?.lastName ?? ''}'
                                      .trim())),
                              DataCell(Text(booking.payment?.amount ?? '')),
                              DataCell(
                                EntityRowActionsMenu(
                                  entityLabel: 'Booking',
                                  option: EntityUpdateOption(
                                    id: booking.id ?? '',
                                    label: booking.id ?? 'Booking',
                                    values: booking.toJson(),
                                  ),
                                  template: const {
                                    'startDate': '',
                                    'endDate': '',
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
                                        .updateBooking(
                                            id, Booking.fromJson(payload));
                                  },
                                  onDelete: (id) async {
                                    final apiToken = await ref
                                        .read(secureStorageProvider)
                                        .getApiToken();
                                    await ref
                                        .read(apiServiceProvider(apiToken))
                                        .deleteBooking(id);
                                  },
                                  onCompleted: () {
                                    ref.invalidate(
                                      bookingsResponseProvider(
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
                ref.read(bookingsPageSizeProvider.notifier).state = value;
                ref.read(bookingsPageProvider.notifier).state = 1;
              },
              onSearchChanged: (value) {
                ref.read(bookingsSearchProvider.notifier).state = value.trim();
                ref.read(bookingsPageProvider.notifier).state = 1;
              },
              onPrevious: currentPage > 1
                  ? () => ref.read(bookingsPageProvider.notifier).state =
                      currentPage - 1
                  : null,
              onNext: currentPage < totalPages
                  ? () => ref.read(bookingsPageProvider.notifier).state =
                      currentPage + 1
                  : null,
            ),
          ],
        );
      },
      error: (error, stackTrace) => const Center(
        child: Text('Error while loading bookings'),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }
}
