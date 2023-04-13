import 'package:testai/models/user.dart';
import 'package:testai/services/sql_service.dart';

import '../models/balance.dart';
import '../models/loan.dart';

class BankService {
  final maximumDebtAmount = 5000000;
  final database = SqlService();
  final User user;

  BankService(this.user);

  Future<double> getBalance() async {
    final db = await database.connect();
    final a = await db.rawQuery(
        "SELECT SUM(balance) FROM balances WHERE user_id = ?", [user.id]);
    final b = a.toList().first.values.first;
    if (b == null) {
      return 0;
    }
    return b as double;
  }

  Future<void> addBalance(double amount, String concept) async {
    final db = await database.connect();
    await db.rawInsert(
        "INSERT INTO balances (user_id, balance, concept, created_at) VALUES (?, ?, ?, ?)",
        [user.id, amount, concept, DateTime.now().toIso8601String()]);
  }

  Future<bool> askForLoan(Loan loan) async {
    final db = await database.connect();
    final currentDebtResult = await db
        .rawQuery("SELECT SUM(amount) FROM loans WHERE user_id = ?", [user.id]);
    final currentDebt = currentDebtResult.toList().first.values.first;

    if (currentDebt != null &&
        (currentDebt as double) + loan.amount > maximumDebtAmount) {
      return false;
    }

    final id = await db.insert("loans", loan.toMap(userId: user.id));
    await db.insert("balances", {
      "user_id": user.id,
      "balance": loan.amount,
      "concept": "Loan adquired ($id)",
      "created_at": DateTime.now().toIso8601String()
    });
    return true;
  }

  Future<List<Loan>> getLoans() async {
    final db = await database.connect();
    final loansResult =
        await db.query("loans", where: "user_id = ?", whereArgs: [user.id]);
    return loansResult.map((e) => Loan.fromMap(e)).toList();
  }

  Future<void> payLoan(int loanId, double amount) async {
    final db = await database.connect();
    final loanResult =
        await db.query("loans", where: "id = ?", whereArgs: [loanId]);

    if (loanResult.isEmpty) {
      throw Exception("Loan not found");
    }

    final loan = Loan.fromMap(loanResult.first);
    final paymentBalanceResult = await db.rawQuery(
        "SELECT SUM(amount) FROM loan_payments WHERE loan_id = ?", [loanId]);
    final paymentBalance =
        paymentBalanceResult.toList().first.values.first as double;

    if (paymentBalance + amount > loan.calculateTotalAmount()) {
      throw Exception("Payment amount exceeds loan amount");
    }

    await db.insert("loan_payments", {
      "loan_id": loanId,
      "amount": amount,
      "paid_at": DateTime.now().toIso8601String(),
    });

    await _cleanUpLoansPaid();
  }

  Future<List<Balance>> getBalances() async {
    final db = await database.connect();
    final balancesResult =
        await db.query("balances", where: "user_id = ?", whereArgs: [user.id]);
    return balancesResult.map((e) => Balance.fromMap(e)).toList();
  }

  Future<void> _cleanUpLoansPaid() async {
    final db = await database.connect();
    final loansResult = await db.query("loans");
    final loans = loansResult.map((e) => Loan.fromMap(e)).toList();

    for (final loan in loans) {
      final paymentBalanceResult = await db.rawQuery(
          "SELECT SUM(amount) FROM loan_payments WHERE loan_id = ?", [loan.id]);
      final paymentBalance =
          paymentBalanceResult.toList().first.values.first as double;

      if (paymentBalance >= loan.calculateTotalAmount()) {
        await db.delete("loans", where: "id = ?", whereArgs: [loan.id]);
      }
    }
  }
}
