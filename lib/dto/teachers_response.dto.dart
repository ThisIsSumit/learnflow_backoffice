import 'package:learnflow_backoffice/models/teacher.dart';

class TeachersResponse {
  const TeachersResponse({
    this.success,
    this.message,
    this.data,
    this.meta,
  });

  final bool? success;
  final String? message;
  final List<Teacher>? data;
  final TeachersMeta? meta;

  factory TeachersResponse.fromJson(Map<String, dynamic> json) {
    final dynamic rawData = json['data'];
    return TeachersResponse(
      success: json['success'] is bool ? json['success'] as bool : null,
      message: json['message']?.toString(),
      data: rawData is List
          ? rawData
              .whereType<Map<String, dynamic>>()
              .map(Teacher.fromJson)
              .toList()
          : null,
      meta: json['meta'] is Map<String, dynamic>
          ? TeachersMeta.fromJson(json['meta'] as Map<String, dynamic>)
          : null,
    );
  }
}

class TeachersMeta {
  const TeachersMeta({
    this.page,
    this.limit,
    this.total,
    this.totalPages,
  });

  final int? page;
  final int? limit;
  final int? total;
  final int? totalPages;

  factory TeachersMeta.fromJson(Map<String, dynamic> json) {
    return TeachersMeta(
      page: json['page'] is int ? json['page'] as int : null,
      limit: json['limit'] is int ? json['limit'] as int : null,
      total: json['total'] is int ? json['total'] as int : null,
      totalPages: json['totalPages'] is int ? json['totalPages'] as int : null,
    );
  }
}
