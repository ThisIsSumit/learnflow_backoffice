class DocumentType {
  const DocumentType({
    this.id,
    this.name,
  });

  final String? id;
  final String? name;

  factory DocumentType.fromJson(Map<String, dynamic> json) {
    return DocumentType(
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
