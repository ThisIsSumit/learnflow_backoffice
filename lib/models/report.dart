import 'package:learnflow_backoffice/models/moderator.dart';
import 'package:learnflow_backoffice/models/report_type.dart';
import 'package:learnflow_backoffice/models/student.dart';
import 'package:learnflow_backoffice/models/teacher.dart';

class Report {
  const Report({
    this.id,
    this.date,
    this.reason,
    this.detail,
    this.reportType,
    this.student,
    this.moderator,
    this.teacher,
  });

  final String? id;
  final DateTime? date;
  final String? reason;
  final String? detail;
  final ReportType? reportType;
  final Student? student;
  final Moderator? moderator;
  final Teacher? teacher;

  factory Report.fromJson(Map<String, dynamic> json) {
    final dynamic rawDate = json['date'];

    return Report(
      id: json['_id']?.toString(),
      date: rawDate is String ? DateTime.tryParse(rawDate) : null,
      reason: json['reason']?.toString(),
      detail: json['detail']?.toString(),
      reportType: json['reportType'] is Map<String, dynamic>
          ? ReportType.fromJson(json['reportType'] as Map<String, dynamic>)
          : null,
      student: json['student'] is Map<String, dynamic>
          ? Student.fromJson(json['student'] as Map<String, dynamic>)
          : null,
      moderator: json['moderator'] is Map<String, dynamic>
          ? Moderator.fromJson(json['moderator'] as Map<String, dynamic>)
          : null,
      teacher: json['teacher'] is Map<String, dynamic>
          ? Teacher.fromJson(json['teacher'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'date': date?.toIso8601String(),
      'reason': reason,
      'detail': detail,
      'reportType': reportType?.toJson(),
      'student': student?.toJson(),
      'moderator': moderator?.toJson(),
      'teacher': teacher?.toJson(),
    };
  }
}
