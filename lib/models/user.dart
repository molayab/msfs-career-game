import 'package:testai/services/bank_service.dart';
import 'package:testai/services/users_service.dart';

import '../services/transport_service.dart';

class User {
  final int? id;
  final String name;
  final String location;
  final int rank;

  // Check a better way to do this, maybe a service locator? in order to allow unit testing.
  Future<double> balance() async {
    return await BankService(this).getBalance();
  }

  BankService bank() {
    return BankService(this);
  }

  TransportService transport() {
    return TransportService(this);
  }

  User({
    required this.id,
    required this.name,
    required this.location,
    required this.rank,
  });

  User.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        name = map['name'],
        location = map['location'],
        rank = map['rank'];

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'name': name,
      'location': location,
      'rank': rank,
    };
  }
}
