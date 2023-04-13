class Balance {
  final int? id;
  final int userId;
  final double balance;
  final String concept;
  final DateTime createdAt;

  Balance({
    this.id,
    required this.userId,
    required this.balance,
    required this.concept,
    required this.createdAt,
  });

  Balance.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        userId = map['user_id'],
        balance = map['balance'],
        concept = map['concept'],
        createdAt = DateTime.parse(map['created_at']);

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'balance': balance,
      'concept': concept,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
