import 'package:learnflow_backoffice/models/chat.dart';

class ChatsResponse {
  const ChatsResponse({
    this.success,
    this.message,
    this.data,
    this.meta,
  });

  final bool? success;
  final String? message;
  final List<Chat>? data;
  final ChatsMeta? meta;

  factory ChatsResponse.fromJson(Map<String, dynamic> json) {
    final dynamic rawData = json['data'];
    return ChatsResponse(
      success: json['success'] is bool ? json['success'] as bool : null,
      message: json['message']?.toString(),
      data: rawData is List
          ? rawData
              .whereType<Map<String, dynamic>>()
              .map(Chat.fromJson)
              .toList()
          : null,
      meta: json['meta'] is Map<String, dynamic>
          ? ChatsMeta.fromJson(json['meta'] as Map<String, dynamic>)
          : null,
    );
  }
}

class ChatsMeta {
  const ChatsMeta({
    this.page,
    this.limit,
    this.total,
    this.totalPages,
  });

  final int? page;
  final int? limit;
  final int? total;
  final int? totalPages;

  factory ChatsMeta.fromJson(Map<String, dynamic> json) {
    return ChatsMeta(
      page: json['page'] is int ? json['page'] as int : null,
      limit: json['limit'] is int ? json['limit'] as int : null,
      total: json['total'] is int ? json['total'] as int : null,
      totalPages: json['totalPages'] is int ? json['totalPages'] as int : null,
    );
  }
}
