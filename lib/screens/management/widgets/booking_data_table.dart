import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:learnflow_backoffice/models/booking.dart';
import 'package:learnflow_backoffice/services/api/api_service.dart';
import 'package:learnflow_backoffice/services/authentication/secure_storage.dart';
import 'package:pluto_grid/pluto_grid.dart';

final bookingsProvider = FutureProvider<List<Booking>>((ref) async {
  final apiToken = await ref.watch(secureStorageProvider).getApiToken();
  final apiService = ref.read(apiServiceProvider(apiToken));
  final response = await apiService.getBookings();
  return response.data ?? <Booking>[];
});

class BookingDataTable extends ConsumerStatefulWidget {
  const BookingDataTable({super.key});

  @override
  ConsumerState<BookingDataTable> createState() => _BookingDataTableState();
}

class _BookingDataTableState extends ConsumerState<BookingDataTable> {
  late final PlutoGridStateManager stateManager;

  @override
  Widget build(BuildContext context) {
    final List<PlutoColumn> columns = <PlutoColumn>[
      PlutoColumn(
        title: 'Start',
        field: 'startDate',
        type: PlutoColumnType.date(),
      ),
      PlutoColumn(
        title: 'End',
        field: 'endDate',
        type: PlutoColumnType.date(),
      ),
      PlutoColumn(
        title: 'Accepted',
        field: 'isAccepted',
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(
        title: 'Subject',
        field: 'schoolSubject',
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(
        title: 'Student',
        field: 'student',
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(
        title: 'Teacher',
        field: 'teacher',
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(
        title: 'Paiement',
        field: 'payment',
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(
        title: 'School Level',
        field: 'schoolLevel',
        type: PlutoColumnType.text(),
      ),
    ];

    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(15),
        child: ref.watch(bookingsProvider).when(
          data: (bookings) {
            return PlutoGrid(
              columns: columns,
              rows: bookings.map((booking) {
                return PlutoRow(
                  cells: {
                    '_id': PlutoCell(value: booking.id ?? ""),
                    'startDate': PlutoCell(value: booking.startDate),
                    'endDate': PlutoCell(value: booking.endDate),
                    'isAccepted': PlutoCell(value: booking.isAccepted ?? ""),
                    'schoolSubject': PlutoCell(
                      value: booking.schoolSubject?.name ?? "",
                    ),
                    'student': PlutoCell(
                      value:
                          '${booking.student?.firstName ?? ''} ${booking.student?.lastName ?? ''}'
                              .trim(),
                    ),
                    'teacher': PlutoCell(
                      value:
                          '${booking.teacher?.firstName ?? ''} ${booking.teacher?.lastName ?? ''}'
                              .trim(),
                    ),
                    'payment': PlutoCell(value: booking.payment?.amount ?? ""),
                    'schoolLevel': PlutoCell(
                      value: booking.student?.schoolLevel ?? "",
                    ),
                  },
                );
              }).toList(),
              onLoaded: (PlutoGridOnLoadedEvent event) {
                stateManager = event.stateManager;
                stateManager.setShowColumnFilter(true);
              },
              onChanged: (PlutoGridOnChangedEvent event) async {
                try {
                  final cell =
                      event.row.cells.map<String, dynamic>((key, cell) {
                    final json = MapEntry(key, cell.value);
                    return json;
                  });
                  final booking = Booking.fromJson(cell);
                  final apiToken =
                      await ref.read(secureStorageProvider).getApiToken();
                  print(booking.id);
                  final response = await ref
                      .read(apiServiceProvider(apiToken))
                      .updateBooking(
                        booking.id!,
                        booking,
                      );
                  print(response);
                  print("Success update");
                } catch (e) {
                  if (!mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Changes were not saved"),
                    ),
                  );
                }
              },
              createHeader: (stateManager) {
                return _Header(stateManager: stateManager);
              },
            );
          },
          error: (error, stackTrace) {
            return const Center(
              child: Text('Error while loading data'),
            );
          },
          loading: () {
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }
}

class _Header extends ConsumerStatefulWidget {
  const _Header({
    required this.stateManager,
    Key? key,
  }) : super(key: key);
  final PlutoGridStateManager stateManager;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HeaderState();
}

class _HeaderState extends ConsumerState<_Header> {
  int addCount = 1;
  int addedCount = 0;
  PlutoGridSelectingMode gridSelectingMode = PlutoGridSelectingMode.row;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      widget.stateManager.setSelectingMode(gridSelectingMode);
    });
  }

  void handleAddRows() {
    final newRows = widget.stateManager.getNewRows(count: addCount);
    widget.stateManager.appendRows(newRows);
    widget.stateManager.setCurrentCell(
      newRows.first.cells.entries.first.value,
      widget.stateManager.refRows.length - 1,
    );
    widget.stateManager.moveScrollByRow(
      PlutoMoveDirection.down,
      widget.stateManager.refRows.length - 2,
    );
    widget.stateManager.setKeepFocus(true);
  }

  void handleRemoveCurrentRowButton() async {
    try {
      final json = widget.stateManager.currentRow!.cells
          .map<String, dynamic>((key, cell) {
        final json = MapEntry(key, cell.value);
        return json;
      });
      final booking = Booking.fromJson(json);
      final apiToken = await ref.read(secureStorageProvider).getApiToken();
      print(booking.id);
      widget.stateManager.removeCurrentRow();
      final response =
          await ref.read(apiServiceProvider(apiToken)).deleteBooking(
                booking.id!,
              );
      print(response);
      print("Success update");
    } catch (e) {
      print(e);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Changes were not saved"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Wrap(
          spacing: 10,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            // ElevatedButton(
            //   onPressed: handleAddRows,
            //   child: const Text('Add a student'),
            // ),
            ElevatedButton(
              onPressed: handleRemoveCurrentRowButton,
              child: const Text("Delete booking"),
            ),
          ],
        ),
      ),
    );
  }
}
