class TeacherValidation {
  const TeacherValidation({
    this.id,
    this.date,
    this.isValidated,
    this.comment,
  });

  final String? id;
  final DateTime? date;
  final bool? isValidated;
  final String? comment;

  factory TeacherValidation.fromJson(Map<String, dynamic> json) {
    final dynamic rawDate = json['date'];

    return TeacherValidation(
      id: json['_id']?.toString(),
      date: rawDate is String ? DateTime.tryParse(rawDate) : null,
      isValidated:
          json['isValidated'] is bool ? json['isValidated'] as bool : null,
      comment: json['comment']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'date': date?.toIso8601String(),
      'isValidated': isValidated,
      'comment': comment,
    };
  }
}
