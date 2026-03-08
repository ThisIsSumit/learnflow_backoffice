import 'package:learnflow_backoffice/models/address.dart';

class Student {
  const Student({
    this.id,
    this.firstName,
    this.lastName,
    this.birthdate,
    this.email,
    this.phoneNumber,
    this.profilePictureUrl,
    this.schoolLevel,
    this.address,
  });

  final String? id;
  final String? firstName;
  final String? lastName;
  final DateTime? birthdate;
  final String? email;
  final String? phoneNumber;
  final String? profilePictureUrl;
  final String? schoolLevel;
  final Address? address;

  factory Student.fromJson(Map<String, dynamic> json) {
    final dynamic rawBirthdate = json['birthdate'];
    final dynamic rawAddress = json['address'];

    return Student(
      id: json['_id']?.toString(),
      firstName: json['firstName']?.toString(),
      lastName: json['lastName']?.toString(),
      birthdate:
          rawBirthdate is String ? DateTime.tryParse(rawBirthdate) : null,
      email: json['email']?.toString(),
      phoneNumber: json['phoneNumber']?.toString(),
      profilePictureUrl: json['profilePictureUrl']?.toString(),
      schoolLevel: json['schoolLevel']?.toString(),
      address: rawAddress is Map<String, dynamic>
          ? Address.fromJson(rawAddress)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'firstName': firstName,
      'lastName': lastName,
      'birthdate': birthdate?.toIso8601String(),
      'email': email,
      'phoneNumber': phoneNumber,
      'profilePictureUrl': profilePictureUrl,
      'schoolLevel': schoolLevel,
      'address': address?.toJson(),
    };
  }
}
