/// Represents a transaction to be included in the invoice
///
/// {@category Receipts}
class Receipt {
  static const acceptedFileTypes = ['jpg', 'png'];
  final int id;
  DateTime date;
  int amount;
  String store;
  String description;
  String fileName;
  int profileId;
  String minute;

  /// Creates Receipt
  ///
  /// Takes unique [id], [date] of the receipt, [amount] of the receipt,
  /// [store] from which the receipt is from, [description] about
  /// the receipt, [fileName] of the attached receipt file, [minute] where
  /// the transaction was approved and the [profileId]
  /// of the profile which the receipt belongs to.
  Receipt({
    required this.id,
    required this.date,
    required this.amount,
    required this.store,
    required this.description,
    required this.fileName,
    required this.profileId,
    required this.minute,
  });

  /// Creates a receipt from map
  ///
  /// Takes a [map] containing fields: id, profileId, date, amount, store,
  /// description, minute and fileName
  Receipt.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        date = DateTime.parse(map['date']),
        amount = map['amount'],
        store = map['store'],
        description = map['description'],
        fileName = map['fileName'],
        profileId = map['profileId'],
        minute = map['minute'];

  /// Returns the date of the receipt as dd.mm.yyyy string
  String get dateOnly {
    return '${date.day}.${date.month}.${date.year}';
  }

  /// Returns the amount of the Receipt in euros as a String
  String get euros {
    return (amount / 100).toStringAsFixed(2);
  }

  /// Returns the Receipt as a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'amount': amount,
      'store': store,
      'description': description,
      'fileName': fileName,
      'minute': minute,
      'profileId': profileId,
    };
  }

  @override
  String toString() {
    return 'Receipt{'
        'id: $id, '
        'date: ${date.toIso8601String()}, '
        'amount: $amount, '
        'store: "$store", '
        'description: "$description", '
        'fileName: "$fileName", '
        'minute: "$minute", '
        'profileId: "$profileId"'
        '}';
  }
}
