import 'package:sqflite/sqflite.dart';

import '../domain/receipt.dart';

/// Service for interacting with receipt database
class ReceiptRepository {
  ReceiptRepository({required this.db});
  final Database db;

  static const _receiptsTableName = 'receipts';

  /// Gets all the receipts from the database
  Future<List<Receipt>> getReceipts() async {
    final data = await db.query(_receiptsTableName);
    final List<Receipt> receipts = [];

    for (var map in data) {
      receipts.add(Receipt.fromMap(map));
    }

    return receipts;
  }

  // TODO Add receipt
}
