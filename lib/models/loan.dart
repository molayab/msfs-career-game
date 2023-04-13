class Loan {
  final int? id;
  final int userId;
  final double amount;
  final double interest;
  final DateTime due;

  double calculateTotalAmount() {
    return amount + (amount * interest);
  }

  Loan(
      {this.id,
      required this.userId,
      required this.amount,
      required this.interest,
      required this.due});

  Loan.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        userId = map['user_id'],
        amount = map['amount'],
        interest = map['interest'],
        due = DateTime.parse(map['due']);

  Map<String, dynamic> toMap({int? userId}) {
    return {
      'id': id,
      'user_id': userId ?? this.userId,
      'amount': amount,
      'interest': interest,
      'due': due.toIso8601String(),
    };
  }
}
