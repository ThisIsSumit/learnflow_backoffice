class Payment {
  const Payment({
    this.id,
    this.amount,
    this.date,
    this.isDue,
  });

  final String? id;
  final String? amount;
  final DateTime? date;
  final bool? isDue;

  factory Payment.fromJson(Map<String, dynamic> json) {
    final dynamic rawDate = json['date'];

    return Payment(
      id: json['_id']?.toString(),
      amount: json['amount']?.toString(),
      date: rawDate is String ? DateTime.tryParse(rawDate) : null,
      isDue: json['isDue'] is bool ? json['isDue'] as bool : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'amount': amount,
      'date': date?.toIso8601String(),
      'isDue': isDue,
    };
  }
}
