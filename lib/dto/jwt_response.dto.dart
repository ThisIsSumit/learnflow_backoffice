class JwtResponse {
  const JwtResponse({
    this.jwt,
    this.refreshToken,
  });

  final JwtData? jwt;
  final String? refreshToken;

  factory JwtResponse.fromJson(Map<String, dynamic> json) {
    return JwtResponse(
      jwt: json['jwt'] is Map<String, dynamic>
          ? JwtData.fromJson(json['jwt'] as Map<String, dynamic>)
          : null,
      refreshToken: json['refreshToken']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'jwt': jwt?.toJson(),
      'refreshToken': refreshToken,
    };
  }
}

class JwtData {
  const JwtData({
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

  factory JwtData.fromJson(Map<String, dynamic> json) {
    return JwtData(
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

class JwtPayload {
  const JwtPayload({
    this.email,
    this.role,
    this.stales,
  });

  final String? email;
  final String? role;
  final int? stales;

  factory JwtPayload.fromJson(Map<String, dynamic> json) {
    return JwtPayload(
      email: json['email']?.toString(),
      role: json['role']?.toString(),
      stales: json['stales'] is int ? json['stales'] as int : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'role': role,
      'stales': stales,
    };
  }
}
