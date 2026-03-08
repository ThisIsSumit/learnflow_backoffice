import 'package:learnflow_backoffice/models/report_type.dart';

class ReportTypesResponse {
  const ReportTypesResponse({
    this.success,
    this.message,
    this.data,
    this.meta,
  });

  final bool? success;
  final String? message;
  final List<ReportType>? data;
  final ReportTypesMeta? meta;

  factory ReportTypesResponse.fromJson(Map<String, dynamic> json) {
    final dynamic rawData = json['data'];
    return ReportTypesResponse(
      success: json['success'] is bool ? json['success'] as bool : null,
      message: json['message']?.toString(),
      data: rawData is List
          ? rawData
              .whereType<Map<String, dynamic>>()
              .map(ReportType.fromJson)
              .toList()
          : null,
      meta: json['meta'] is Map<String, dynamic>
          ? ReportTypesMeta.fromJson(json['meta'] as Map<String, dynamic>)
          : null,
    );
  }
}

class ReportTypesMeta {
  const ReportTypesMeta({
    this.page,
    this.limit,
    this.total,
    this.totalPages,
  });

  final int? page;
  final int? limit;
  final int? total;
  final int? totalPages;

  factory ReportTypesMeta.fromJson(Map<String, dynamic> json) {
    return ReportTypesMeta(
      page: json['page'] is int ? json['page'] as int : null,
      limit: json['limit'] is int ? json['limit'] as int : null,
      total: json['total'] is int ? json['total'] as int : null,
      totalPages: json['totalPages'] is int ? json['totalPages'] as int : null,
    );
  }
}
