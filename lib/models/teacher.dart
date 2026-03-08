import 'package:learnflow_backoffice/models/address.dart';
import 'package:learnflow_backoffice/models/document.dart';

class Teacher {
  const Teacher({
    this.id,
    this.firstName,
    this.lastName,
    this.birthdate,
    this.email,
    this.phoneNumber,
    this.profilePictureUrl,
    this.isValidated,
    this.address,
    this.documents,
  });

  final String? id;
  final String? firstName;
  final String? lastName;
  final DateTime? birthdate;
  final String? email;
  final String? phoneNumber;
  final String? profilePictureUrl;
  final bool? isValidated;
  final Address? address;
  final List<Document>? documents;

  factory Teacher.fromJson(Map<String, dynamic> json) {
    final dynamic rawBirthdate = json['birthdate'];
    final dynamic rawAddress = json['address'];
    final dynamic rawDocuments = json['documents'];

    return Teacher(
      id: json['_id']?.toString(),
      firstName: json['firstName']?.toString(),
      lastName: json['lastName']?.toString(),
      birthdate:
          rawBirthdate is String ? DateTime.tryParse(rawBirthdate) : null,
      email: json['email']?.toString(),
      phoneNumber: json['phoneNumber']?.toString(),
      profilePictureUrl: json['profilePictureUrl']?.toString(),
      isValidated:
          json['isValidated'] is bool ? json['isValidated'] as bool : null,
      address: rawAddress is Map<String, dynamic>
          ? Address.fromJson(rawAddress)
          : null,
      documents: rawDocuments is List
          ? rawDocuments
              .whereType<Map<String, dynamic>>()
              .map(Document.fromJson)
              .toList()
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
      'isValidated': isValidated,
      'address': address?.toJson(),
      'documents': documents?.map((e) => e.toJson()).toList(),
    };
  }
}
