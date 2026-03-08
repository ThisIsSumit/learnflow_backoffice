import 'package:learnflow_backoffice/models/report.dart';

class ReportsResponse {
  const ReportsResponse({
    this.success,
    this.message,
    this.data,
    this.meta,
  });

  final bool? success;
  final String? message;
  final List<Report>? data;
  final ReportsMeta? meta;

  factory ReportsResponse.fromJson(Map<String, dynamic> json) {
    final dynamic rawData = json['data'];
    return ReportsResponse(
      success: json['success'] is bool ? json['success'] as bool : null,
      message: json['message']?.toString(),
      data: rawData is List
          ? rawData
              .whereType<Map<String, dynamic>>()
              .map(Report.fromJson)
              .toList()
          : null,
      meta: json['meta'] is Map<String, dynamic>
          ? ReportsMeta.fromJson(json['meta'] as Map<String, dynamic>)
          : null,
    );
  }
}

class ReportsMeta {
  const ReportsMeta({
    this.page,
    this.limit,
    this.total,
    this.totalPages,
  });

  final int? page;
  final int? limit;
  final int? total;
  final int? totalPages;

  factory ReportsMeta.fromJson(Map<String, dynamic> json) {
    return ReportsMeta(
      page: json['page'] is int ? json['page'] as int : null,
      limit: json['limit'] is int ? json['limit'] as int : null,
      total: json['total'] is int ? json['total'] as int : null,
      totalPages: json['totalPages'] is int ? json['totalPages'] as int : null,
    );
  }
}
