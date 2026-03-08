class Justificative {
  const Justificative({
    this.id,
    this.uploadUrl,
    this.comment,
    this.startDate,
    this.endDate,
  });

  final String? id;
  final String? uploadUrl;
  final String? comment;
  final DateTime? startDate;
  final DateTime? endDate;

  factory Justificative.fromJson(Map<String, dynamic> json) {
    final dynamic rawStartDate = json['startDate'];
    final dynamic rawEndDate = json['endDate'];

    return Justificative(
      id: json['_id']?.toString(),
      uploadUrl: json['uploadUrl']?.toString(),
      comment: json['comment']?.toString(),
      startDate:
          rawStartDate is String ? DateTime.tryParse(rawStartDate) : null,
      endDate: rawEndDate is String ? DateTime.tryParse(rawEndDate) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'uploadUrl': uploadUrl,
      'comment': comment,
      'startDate': startDate?.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
    };
  }
}
