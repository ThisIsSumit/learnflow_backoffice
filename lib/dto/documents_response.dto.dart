import 'package:learnflow_backoffice/models/document.dart';

class DocumentsResponse {
  const DocumentsResponse({
    this.success,
    this.message,
    this.data,
    this.meta,
  });

  final bool? success;
  final String? message;
  final List<Document>? data;
  final DocumentsMeta? meta;

  factory DocumentsResponse.fromJson(Map<String, dynamic> json) {
    final dynamic rawData = json['data'];
    return DocumentsResponse(
      success: json['success'] is bool ? json['success'] as bool : null,
      message: json['message']?.toString(),
      data: rawData is List
          ? rawData
              .whereType<Map<String, dynamic>>()
              .map(Document.fromJson)
              .toList()
          : null,
      meta: json['meta'] is Map<String, dynamic>
          ? DocumentsMeta.fromJson(json['meta'] as Map<String, dynamic>)
          : null,
    );
  }
}

class DocumentsMeta {
  const DocumentsMeta({
    this.page,
    this.limit,
    this.total,
    this.totalPages,
  });

  final int? page;
  final int? limit;
  final int? total;
  final int? totalPages;

  factory DocumentsMeta.fromJson(Map<String, dynamic> json) {
    return DocumentsMeta(
      page: json['page'] is int ? json['page'] as int : null,
      limit: json['limit'] is int ? json['limit'] as int : null,
      total: json['total'] is int ? json['total'] as int : null,
      totalPages: json['totalPages'] is int ? json['totalPages'] as int : null,
    );
  }
}
