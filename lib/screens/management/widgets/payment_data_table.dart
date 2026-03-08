import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hooks_riverpod/legacy.dart';
import 'package:intl/intl.dart';
import 'package:learnflow_backoffice/dto/payments_response.dto.dart';
import 'package:learnflow_backoffice/models/payment.dart';
import 'package:learnflow_backoffice/screens/management/widgets/entity_crud_panel.dart';
import 'package:learnflow_backoffice/screens/management/widgets/management_pagination_controls.dart';
import 'package:learnflow_backoffice/services/api/api_service.dart';
import 'package:learnflow_backoffice/services/authentication/secure_storage.dart';

final paymentsPageProvider = StateProvider.autoDispose<int>((ref) => 1);
final paymentsPageSizeProvider = StateProvider.autoDispose<int>((ref) => 10);
final paymentsSearchProvider = StateProvider.autoDispose<String>((ref) => '');

final paymentsResponseProvider = FutureProvider.autoDispose
    .family<PaymentsResponse, ({int page, int pageSize, String search})>(
        (ref, params) async {
  final apiToken = await ref.watch(secureStorageProvider).getApiToken();
  final apiService = ref.read(apiServiceProvider(apiToken));
  return apiService.getPayments(
    page: params.page,
    limit: params.pageSize,
    search: params.search.isEmpty ? null : params.search,
  );
});

class PaymentDataTable extends ConsumerWidget {
  const PaymentDataTable({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final page = ref.watch(paymentsPageProvider);
    final pageSize = ref.watch(paymentsPageSizeProvider);
    final search = ref.watch(paymentsSearchProvider);
    final responseAsync = ref.watch(
      paymentsResponseProvider(
          (page: page, pageSize: pageSize, search: search)),
    );
    final formatter = DateFormat('yyyy-MM-dd');

    return responseAsync.when(
      data: (response) {
        final items = response.data ?? const [];
        final meta = response.meta;
        final currentPage = meta?.page ?? page;
        final totalPages = (meta?.totalPages ?? 1) < 1 ? 1 : meta!.totalPages!;

        return Column(
          children: [
            EntityCrudPanel(
              entityLabel: 'Payment',
              createTemplate: const {
                'amount': '0',
                'date': '',
                'isDue': false,
              },
              onCreate: (json) async {
                final apiToken =
                    await ref.read(secureStorageProvider).getApiToken();
                await ref
                    .read(apiServiceProvider(apiToken))
                    .createPayment(Payment.fromJson(json));
              },
              onCompleted: () {
                ref.invalidate(
                  paymentsResponseProvider(
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
                      DataColumn(label: Text('Amount')),
                      DataColumn(label: Text('Date')),
                      DataColumn(label: Text('Due')),
                      DataColumn(label: Text('Actions')),
                    ],
                    rows: items
                        .map(
                          (payment) => DataRow(
                            cells: [
                              DataCell(Text(payment.amount ?? '')),
                              DataCell(Text(payment.date == null
                                  ? ''
                                  : formatter.format(payment.date!.toLocal()))),
                              DataCell(Text(
                                  (payment.isDue ?? false) ? 'Yes' : 'No')),
                              DataCell(
                                EntityRowActionsMenu(
                                  entityLabel: 'Payment',
                                  option: EntityUpdateOption(
                                    id: payment.id ?? '',
                                    label: payment.id ?? 'Payment',
                                    values: payment.toJson(),
                                  ),
                                  template: const {
                                    'amount': '0',
                                    'date': '',
                                    'isDue': false,
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
                                        .updatePayment(
                                            id, Payment.fromJson(payload));
                                  },
                                  onDelete: (id) async {
                                    final apiToken = await ref
                                        .read(secureStorageProvider)
                                        .getApiToken();
                                    await ref
                                        .read(apiServiceProvider(apiToken))
                                        .deletePayment(id);
                                  },
                                  onCompleted: () {
                                    ref.invalidate(
                                      paymentsResponseProvider(
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
                ref.read(paymentsPageSizeProvider.notifier).state = value;
                ref.read(paymentsPageProvider.notifier).state = 1;
              },
              onSearchChanged: (value) {
                ref.read(paymentsSearchProvider.notifier).state = value.trim();
                ref.read(paymentsPageProvider.notifier).state = 1;
              },
              onPrevious: currentPage > 1
                  ? () => ref.read(paymentsPageProvider.notifier).state =
                      currentPage - 1
                  : null,
              onNext: currentPage < totalPages
                  ? () => ref.read(paymentsPageProvider.notifier).state =
                      currentPage + 1
                  : null,
            ),
          ],
        );
      },
      error: (error, stackTrace) => const Center(
        child: Text('Error while loading payments'),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }
}
