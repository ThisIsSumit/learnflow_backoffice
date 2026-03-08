import 'package:learnflow_backoffice/models/document_type.dart';

class Document {
  const Document({
    this.id,
    this.uploadUrl,
    this.documentType,
  });

  final String? id;
  final String? uploadUrl;
  final DocumentType? documentType;

  factory Document.fromJson(Map<String, dynamic> json) {
    final dynamic rawDocumentType = json['documentType'];

    return Document(
      id: json['_id']?.toString(),
      uploadUrl: json['uploadUrl']?.toString(),
      documentType: rawDocumentType is Map<String, dynamic>
          ? DocumentType.fromJson(rawDocumentType)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'uploadUrl': uploadUrl,
      'documentType': documentType?.toJson(),
    };
  }
}
