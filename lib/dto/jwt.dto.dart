import 'package:learnflow_backoffice/dto/jwt_payload.dto.dart';

class Jwt {
  const Jwt({
    this.token,
    this.payload,
    this.valid,
    this.expired,
    this.stale,
  });

  final String? token;
  final JwtPayload? payload;
  final bool? valid;
  final bool? expired;
  final bool? stale;

  factory Jwt.fromJson(Map<String, dynamic> json) {
    return Jwt(
      token: json['token']?.toString(),
      payload: json['payload'] is Map<String, dynamic>
          ? JwtPayload.fromJson(json['payload'] as Map<String, dynamic>)
          : null,
      valid: json['valid'] is bool ? json['valid'] as bool : null,
      expired: json['expired'] is bool ? json['expired'] as bool : null,
      stale: json['stale'] is bool ? json['stale'] as bool : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'payload': payload?.toJson(),
      'valid': valid,
      'expired': expired,
      'stale': stale,
    };
  }
}
