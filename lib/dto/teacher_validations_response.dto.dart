import 'package:learnflow_backoffice/models/teacher_validation.dart';

class TeacherValidationsResponse {
  const TeacherValidationsResponse({
    this.success,
    this.message,
    this.data,
    this.meta,
  });

  final bool? success;
  final String? message;
  final List<TeacherValidation>? data;
  final TeacherValidationsMeta? meta;

  factory TeacherValidationsResponse.fromJson(Map<String, dynamic> json) {
    final dynamic rawData = json['data'];
    return TeacherValidationsResponse(
      success: json['success'] is bool ? json['success'] as bool : null,
      message: json['message']?.toString(),
      data: rawData is List
          ? rawData
              .whereType<Map<String, dynamic>>()
              .map(TeacherValidation.fromJson)
              .toList()
          : null,
      meta: json['meta'] is Map<String, dynamic>
          ? TeacherValidationsMeta.fromJson(
              json['meta'] as Map<String, dynamic>,
            )
          : null,
    );
  }
}

class TeacherValidationsMeta {
  const TeacherValidationsMeta({
    this.page,
    this.limit,
    this.total,
    this.totalPages,
  });

  final int? page;
  final int? limit;
  final int? total;
  final int? totalPages;

  factory TeacherValidationsMeta.fromJson(Map<String, dynamic> json) {
    return TeacherValidationsMeta(
      page: json['page'] is int ? json['page'] as int : null,
      limit: json['limit'] is int ? json['limit'] as int : null,
      total: json['total'] is int ? json['total'] as int : null,
      totalPages: json['totalPages'] is int ? json['totalPages'] as int : null,
    );
  }
}
