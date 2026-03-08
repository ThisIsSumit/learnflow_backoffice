import 'package:learnflow_backoffice/models/moderator.dart';

class ModeratorsResponse {
  const ModeratorsResponse({
    this.success,
    this.message,
    this.data,
    this.meta,
  });

  final bool? success;
  final String? message;
  final List<Moderator>? data;
  final ModeratorsMeta? meta;

  factory ModeratorsResponse.fromJson(Map<String, dynamic> json) {
    final dynamic rawData = json['data'];
    return ModeratorsResponse(
      success: json['success'] is bool ? json['success'] as bool : null,
      message: json['message']?.toString(),
      data: rawData is List
          ? rawData
              .whereType<Map<String, dynamic>>()
              .map(Moderator.fromJson)
              .toList()
          : null,
      meta: json['meta'] is Map<String, dynamic>
          ? ModeratorsMeta.fromJson(json['meta'] as Map<String, dynamic>)
          : null,
    );
  }
}

class ModeratorsMeta {
  const ModeratorsMeta({
    this.page,
    this.limit,
    this.total,
    this.totalPages,
  });

  final int? page;
  final int? limit;
  final int? total;
  final int? totalPages;

  factory ModeratorsMeta.fromJson(Map<String, dynamic> json) {
    return ModeratorsMeta(
      page: json['page'] is int ? json['page'] as int : null,
      limit: json['limit'] is int ? json['limit'] as int : null,
      total: json['total'] is int ? json['total'] as int : null,
      totalPages: json['totalPages'] is int ? json['totalPages'] as int : null,
    );
  }
}
