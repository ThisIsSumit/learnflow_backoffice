import 'package:learnflow_backoffice/models/student.dart';

class StudentsResponse {
  const StudentsResponse({
    this.success,
    this.message,
    this.data,
    this.meta,
  });

  final bool? success;
  final String? message;
  final List<Student>? data;
  final StudentsMeta? meta;

  factory StudentsResponse.fromJson(Map<String, dynamic> json) {
    final dynamic rawData = json['data'];
    return StudentsResponse(
      success: json['success'] is bool ? json['success'] as bool : null,
      message: json['message']?.toString(),
      data: rawData is List
          ? rawData
              .whereType<Map<String, dynamic>>()
              .map(Student.fromJson)
              .toList()
          : null,
      meta: json['meta'] is Map<String, dynamic>
          ? StudentsMeta.fromJson(json['meta'] as Map<String, dynamic>)
          : null,
    );
  }
}

class StudentsMeta {
  const StudentsMeta({
    this.page,
    this.limit,
    this.total,
    this.totalPages,
  });

  final int? page;
  final int? limit;
  final int? total;
  final int? totalPages;

  factory StudentsMeta.fromJson(Map<String, dynamic> json) {
    return StudentsMeta(
      page: json['page'] is int ? json['page'] as int : null,
      limit: json['limit'] is int ? json['limit'] as int : null,
      total: json['total'] is int ? json['total'] as int : null,
      totalPages: json['totalPages'] is int ? json['totalPages'] as int : null,
    );
  }
}
