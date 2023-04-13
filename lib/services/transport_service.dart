import 'package:testai/models/user.dart';
import 'airports_service.dart';
import 'bank_service.dart';

import 'users_service.dart';

class TransportService {
  final double ticketCost = 10000;

  final airports = AirportsService();
  final users = UsersService();

  late BankService bank;
  late User user;

  TransportService(this.user) {
    bank = BankService(user);
  }

  Future<void> buyTicket(String destination) async {
    final airport = await airports.get(destination);

    if (airport == null) {
      throw Exception("Airport not found");
    }

    final balance = await bank.getBalance();
    if (balance < ticketCost) {
      throw Exception("Not enough money");
    }

    await users.moveTo(destination, user.id!);
    await bank.addBalance(-ticketCost, "Ticket to $destination");
  }
}
