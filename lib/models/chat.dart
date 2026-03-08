import 'package:learnflow_backoffice/models/moderator.dart';
import 'package:learnflow_backoffice/models/student.dart';
import 'package:learnflow_backoffice/models/teacher.dart';

class Chat {
  const Chat({
    this.id,
    this.message,
    this.datetime,
    this.student,
    this.moderator,
    this.teacher,
  });

  final String? id;
  final String? message;
  final DateTime? datetime;
  final Student? student;
  final Moderator? moderator;
  final Teacher? teacher;

  factory Chat.fromJson(Map<String, dynamic> json) {
    final dynamic rawDatetime = json['datetime'];

    return Chat(
      id: json['_id']?.toString(),
      message: json['message']?.toString(),
      datetime: rawDatetime is String ? DateTime.tryParse(rawDatetime) : null,
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
      'message': message,
      'datetime': datetime?.toIso8601String(),
      'student': student?.toJson(),
      'moderator': moderator?.toJson(),
      'teacher': teacher?.toJson(),
    };
  }
}
