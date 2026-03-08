class ReportType {
  const ReportType({
    this.id,
    this.name,
  });

  final String? id;
  final String? name;

  factory ReportType.fromJson(Map<String, dynamic> json) {
    return ReportType(
      id: json['_id']?.toString(),
      name: json['name']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
    };
  }
}
