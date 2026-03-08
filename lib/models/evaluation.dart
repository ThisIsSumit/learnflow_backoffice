import 'package:learnflow_backoffice/models/school_subject.dart';
import 'package:learnflow_backoffice/models/student.dart';
import 'package:learnflow_backoffice/models/teacher.dart';

class Evaluation {
  const Evaluation({
    this.id,
    this.note,
    this.subject,
    this.student,
    this.teacher,
  });

  final String? id;
  final String? note;
  final SchoolSubject? subject;
  final Student? student;
  final Teacher? teacher;

  factory Evaluation.fromJson(Map<String, dynamic> json) {
    return Evaluation(
      id: json['_id']?.toString(),
      note: json['note']?.toString(),
      subject: json['subject'] is Map<String, dynamic>
          ? SchoolSubject.fromJson(json['subject'] as Map<String, dynamic>)
          : null,
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
      'subject': subject?.toJson(),
      'student': student?.toJson(),
      'teacher': teacher?.toJson(),
    };
  }
}
