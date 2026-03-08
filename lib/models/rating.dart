import 'package:learnflow_backoffice/models/student.dart';
import 'package:learnflow_backoffice/models/teacher.dart';

class Rating {
  const Rating({
    this.id,
    this.note,
    this.student,
    this.teacher,
  });

  final String? id;
  final int? note;
  final Student? student;
  final Teacher? teacher;

  factory Rating.fromJson(Map<String, dynamic> json) {
    return Rating(
      id: json['_id']?.toString(),
      note: json['note'] is int ? json['note'] as int : null,
      student: json['student'] is Map<String, dynamic>
          ? Student.fromJson(json['student'] as Map<String, dynamic>)
          : null,
      teacher: json['teacher'] is Map<String, dynamic>
          ? Teacher.fromJson(json['teacher'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'note': note,
      'student': student?.toJson(),
      'teacher': teacher?.toJson(),
    };
  }
}
