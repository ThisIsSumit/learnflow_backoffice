import 'package:learnflow_backoffice/models/booking.dart';

class BookingsResponse {
  const BookingsResponse({
    this.success,
    this.message,
    this.data,
    this.meta,
  });

  final bool? success;
  final String? message;
  final List<Booking>? data;
  final BookingsMeta? meta;

  factory BookingsResponse.fromJson(Map<String, dynamic> json) {
    final dynamic rawData = json['data'];
    return BookingsResponse(
      success: json['success'] is bool ? json['success'] as bool : null,
      message: json['message']?.toString(),
      data: rawData is List
          ? rawData
              .whereType<Map<String, dynamic>>()
              .map(Booking.fromJson)
              .toList()
          : null,
      meta: json['meta'] is Map<String, dynamic>
          ? BookingsMeta.fromJson(json['meta'] as Map<String, dynamic>)
          : null,
    );
  }
}

class BookingsMeta {
  const BookingsMeta({
    this.page,
    this.limit,
    this.total,
    this.totalPages,
  });

  final int? page;
  final int? limit;
  final int? total;
  final int? totalPages;

  factory BookingsMeta.fromJson(Map<String, dynamic> json) {
    return BookingsMeta(
      page: json['page'] is int ? json['page'] as int : null,
      limit: json['limit'] is int ? json['limit'] as int : null,
      total: json['total'] is int ? json['total'] as int : null,
      totalPages: json['totalPages'] is int ? json['totalPages'] as int : null,
    );
  }
}
