import 'package:learnflow_backoffice/models/rating.dart';

class RatingsResponse {
  const RatingsResponse({
    this.success,
    this.message,
    this.data,
    this.meta,
  });

  final bool? success;
  final String? message;
  final List<Rating>? data;
  final RatingsMeta? meta;

  factory RatingsResponse.fromJson(Map<String, dynamic> json) {
    final dynamic rawData = json['data'];
    return RatingsResponse(
      success: json['success'] is bool ? json['success'] as bool : null,
      message: json['message']?.toString(),
      data: rawData is List
          ? rawData
              .whereType<Map<String, dynamic>>()
              .map(Rating.fromJson)
              .toList()
          : null,
      meta: json['meta'] is Map<String, dynamic>
          ? RatingsMeta.fromJson(json['meta'] as Map<String, dynamic>)
          : null,
    );
  }
}

class RatingsMeta {
  const RatingsMeta({
    this.page,
    this.limit,
    this.total,
    this.totalPages,
  });

  final int? page;
  final int? limit;
  final int? total;
  final int? totalPages;

  factory RatingsMeta.fromJson(Map<String, dynamic> json) {
    return RatingsMeta(
      page: json['page'] is int ? json['page'] as int : null,
      limit: json['limit'] is int ? json['limit'] as int : null,
      total: json['total'] is int ? json['total'] as int : null,
      totalPages: json['totalPages'] is int ? json['totalPages'] as int : null,
    );
  }
}
