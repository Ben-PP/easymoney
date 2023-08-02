import 'package:sqflite/sqflite.dart';

import '../domain/receipt.dart';
import '../../../utils/database.dart';

class ReceiptRepository {
  Database? db;

  static const _receiptsTableName = 'receipts';

  Future<List<Receipt>> getReceipts() async {
    db ??= await initDb();
    final data = await db!.query(_receiptsTableName);
    final List<Receipt> receipts = [];

    for (var map in data) {
      receipts.add(Receipt.fromMap(map));
    }

    return receipts;
  }
}
