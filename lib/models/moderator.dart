class Moderator {
  const Moderator({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
  });

  final String? id;
  final String? firstName;
  final String? lastName;
  final String? email;

  factory Moderator.fromJson(Map<String, dynamic> json) {
    return Moderator(
      id: json['_id']?.toString(),
      firstName: json['firstName']?.toString(),
      lastName: json['lastName']?.toString(),
      email: json['email']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
    };
  }
}
