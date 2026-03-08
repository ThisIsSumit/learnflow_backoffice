class SchoolSubject {
  const SchoolSubject({
    this.id,
    this.name,
  });

  final String? id;
  final String? name;

  factory SchoolSubject.fromJson(Map<String, dynamic> json) {
    return SchoolSubject(
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
