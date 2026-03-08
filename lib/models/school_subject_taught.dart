import 'package:learnflow_backoffice/models/school_subject.dart';
import 'package:learnflow_backoffice/models/teacher.dart';

class SchoolSubjectTaught {
  const SchoolSubjectTaught({
    this.id,
    this.yearsOfExperience,
    this.teacher,
    this.schoolSubject,
  });

  final String? id;
  final int? yearsOfExperience;
  final Teacher? teacher;
  final SchoolSubject? schoolSubject;

  factory SchoolSubjectTaught.fromJson(Map<String, dynamic> json) {
    return SchoolSubjectTaught(
      id: json['_id']?.toString(),
      yearsOfExperience: json['yearsOfExperience'] is int
          ? json['yearsOfExperience'] as int
          : null,
      teacher: json['teacher'] is Map<String, dynamic>
          ? Teacher.fromJson(json['teacher'] as Map<String, dynamic>)
          : null,
      schoolSubject: json['schoolSubject'] is Map<String, dynamic>
          ? SchoolSubject.fromJson(
              json['schoolSubject'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'yearsOfExperience': yearsOfExperience,
      'teacher': teacher?.toJson(),
      'schoolSubject': schoolSubject?.toJson(),
    };
  }
}
