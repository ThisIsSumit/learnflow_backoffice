import 'package:learnflow_backoffice/models/payment.dart';

class PaymentsResponse {
  const PaymentsResponse({
    this.success,
    this.message,
    this.data,
    this.meta,
  });

  final bool? success;
  final String? message;
  final List<Payment>? data;
  final PaymentsMeta? meta;

  factory PaymentsResponse.fromJson(Map<String, dynamic> json) {
    final dynamic rawData = json['data'];
    return PaymentsResponse(
      success: json['success'] is bool ? json['success'] as bool : null,
      message: json['message']?.toString(),
      data: rawData is List
          ? rawData
              .whereType<Map<String, dynamic>>()
              .map(Payment.fromJson)
              .toList()
          : null,
      meta: json['meta'] is Map<String, dynamic>
          ? PaymentsMeta.fromJson(json['meta'] as Map<String, dynamic>)
          : null,
    );
  }
}

class PaymentsMeta {
  const PaymentsMeta({
    this.page,
    this.limit,
    this.total,
    this.totalPages,
  });

  final int? page;
  final int? limit;
  final int? total;
  final int? totalPages;

  factory PaymentsMeta.fromJson(Map<String, dynamic> json) {
    return PaymentsMeta(
      page: json['page'] is int ? json['page'] as int : null,
      limit: json['limit'] is int ? json['limit'] as int : null,
      total: json['total'] is int ? json['total'] as int : null,
      totalPages: json['totalPages'] is int ? json['totalPages'] as int : null,
    );
  }
}
