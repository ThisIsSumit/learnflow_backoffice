class Address {
  const Address({
    this.id,
    this.city,
    this.zipCode,
    this.street,
    this.complement,
  });

  final String? id;
  final String? city;
  final String? zipCode;
  final String? street;
  final String? complement;

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      id: json['_id']?.toString(),
      city: json['city']?.toString(),
      zipCode: json['zipCode']?.toString(),
      street: json['street']?.toString(),
      complement: json['complement']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'city': city,
      'zipCode': zipCode,
      'street': street,
      'complement': complement,
    };
  }
}
