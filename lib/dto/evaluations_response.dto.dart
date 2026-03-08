import 'package:learnflow_backoffice/models/evaluation.dart';

class EvaluationsResponse {
  const EvaluationsResponse({
    this.success,
    this.message,
    this.data,
    this.meta,
  });

  final bool? success;
  final String? message;
  final List<Evaluation>? data;
  final EvaluationsMeta? meta;

  factory EvaluationsResponse.fromJson(Map<String, dynamic> json) {
    final dynamic rawData = json['data'];
    return EvaluationsResponse(
      success: json['success'] is bool ? json['success'] as bool : null,
      message: json['message']?.toString(),
      data: rawData is List
          ? rawData
              .whereType<Map<String, dynamic>>()
              .map(Evaluation.fromJson)
              .toList()
          : null,
      meta: json['meta'] is Map<String, dynamic>
          ? EvaluationsMeta.fromJson(json['meta'] as Map<String, dynamic>)
          : null,
    );
  }
}

class EvaluationsMeta {
  const EvaluationsMeta({
    this.page,
    this.limit,
    this.total,
    this.totalPages,
  });

  final int? page;
  final int? limit;
  final int? total;
  final int? totalPages;

  factory EvaluationsMeta.fromJson(Map<String, dynamic> json) {
    return EvaluationsMeta(
      page: json['page'] is int ? json['page'] as int : null,
      limit: json['limit'] is int ? json['limit'] as int : null,
      total: json['total'] is int ? json['total'] as int : null,
      totalPages: json['totalPages'] is int ? json['totalPages'] as int : null,
    );
  }
}
