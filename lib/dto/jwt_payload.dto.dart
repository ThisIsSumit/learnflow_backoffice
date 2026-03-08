class JwtPayload {
  const JwtPayload({
    required this.email,
    required this.role,
    required this.stales,
  });

  final String email;
  final String role;
  final int stales;

  factory JwtPayload.fromJson(Map<String, dynamic> json) {
    return JwtPayload(
      email: json['email']?.toString() ?? '',
      role: json['role']?.toString() ?? '',
      stales: json['stales'] is int ? json['stales'] as int : 0,
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
