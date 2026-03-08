import 'package:learnflow_backoffice/models/justificative.dart';

class JustificativesResponse {
  const JustificativesResponse({
    this.success,
    this.message,
    this.data,
    this.meta,
  });

  final bool? success;
  final String? message;
  final List<Justificative>? data;
  final JustificativesMeta? meta;

  factory JustificativesResponse.fromJson(Map<String, dynamic> json) {
    final dynamic rawData = json['data'];
    return JustificativesResponse(
      success: json['success'] is bool ? json['success'] as bool : null,
      message: json['message']?.toString(),
      data: rawData is List
          ? rawData
              .whereType<Map<String, dynamic>>()
              .map(Justificative.fromJson)
              .toList()
          : null,
      meta: json['meta'] is Map<String, dynamic>
          ? JustificativesMeta.fromJson(json['meta'] as Map<String, dynamic>)
          : null,
    );
  }
}

class JustificativesMeta {
  const JustificativesMeta({
    this.page,
    this.limit,
    this.total,
    this.totalPages,
  });

  final int? page;
  final int? limit;
  final int? total;
  final int? totalPages;

  factory JustificativesMeta.fromJson(Map<String, dynamic> json) {
    return JustificativesMeta(
      page: json['page'] is int ? json['page'] as int : null,
      limit: json['limit'] is int ? json['limit'] as int : null,
      total: json['total'] is int ? json['total'] as int : null,
      totalPages: json['totalPages'] is int ? json['totalPages'] as int : null,
    );
  }
}
