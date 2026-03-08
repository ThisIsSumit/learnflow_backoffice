import 'package:learnflow_backoffice/models/justificative.dart';
import 'package:learnflow_backoffice/models/payment.dart';
import 'package:learnflow_backoffice/models/school_subject.dart';
import 'package:learnflow_backoffice/models/student.dart';
import 'package:learnflow_backoffice/models/teacher.dart';

class Booking {
  const Booking({
    this.id,
    this.startDate,
    this.endDate,
    this.isAccepted,
    this.schoolSubject,
    this.student,
    this.teacher,
    this.studentJustificative,
    this.teacherJustificative,
    this.payment,
  });

  final String? id;
  final DateTime? startDate;
  final DateTime? endDate;
  final bool? isAccepted;
  final SchoolSubject? schoolSubject;
  final Student? student;
  final Teacher? teacher;
  final Justificative? studentJustificative;
  final Justificative? teacherJustificative;
  final Payment? payment;

  factory Booking.fromJson(Map<String, dynamic> json) {
    final dynamic rawStartDate = json['startDate'];
    final dynamic rawEndDate = json['endDate'];

    return Booking(
      id: json['_id']?.toString(),
      startDate:
          rawStartDate is String ? DateTime.tryParse(rawStartDate) : null,
      endDate: rawEndDate is String ? DateTime.tryParse(rawEndDate) : null,
      isAccepted:
          json['isAccepted'] is bool ? json['isAccepted'] as bool : null,
      schoolSubject: json['schoolSubject'] is Map<String, dynamic>
          ? SchoolSubject.fromJson(
              json['schoolSubject'] as Map<String, dynamic>)
          : null,
      student: json['student'] is Map<String, dynamic>
          ? Student.fromJson(json['student'] as Map<String, dynamic>)
          : null,
      teacher: json['teacher'] is Map<String, dynamic>
          ? Teacher.fromJson(json['teacher'] as Map<String, dynamic>)
          : null,
      studentJustificative: json['studentJustificative'] is Map<String, dynamic>
          ? Justificative.fromJson(
              json['studentJustificative'] as Map<String, dynamic>,
            )
          : null,
      teacherJustificative: json['teacherJustificative'] is Map<String, dynamic>
          ? Justificative.fromJson(
              json['teacherJustificative'] as Map<String, dynamic>,
            )
          : null,
      payment: json['payment'] is Map<String, dynamic>
          ? Payment.fromJson(json['payment'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'startDate': startDate?.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'isAccepted': isAccepted,
      'schoolSubject': schoolSubject?.toJson(),
      'student': student?.toJson(),
      'teacher': teacher?.toJson(),
      'studentJustificative': studentJustificative?.toJson(),
      'teacherJustificative': teacherJustificative?.toJson(),
      'payment': payment?.toJson(),
    };
  }
}
