class Manager {
  const Manager({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
  });

  final String? id;
  final String? firstName;
  final String? lastName;
  final String? email;

  factory Manager.fromJson(Map<String, dynamic> json) {
    return Manager(
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
