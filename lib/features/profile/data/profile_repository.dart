import 'package:sqflite/sqflite.dart';

import '../../../utils/database.dart';
import '../domain/profile.dart';

/// Handles the data operations between the database and providers for profiles
class ProfileRepository {
  static const _profileTableName = 'profiles';
  Database? db;

  /// Gets all the profiles from the database
  Future<List<Profile>> getProfiles() async {
    await _openDatabase();
    final data = await db!.query(_profileTableName);
    final List<Profile> profiles = [];
    for (var map in data) {
      profiles.add(Profile.fromMap(map));
    }
    return profiles;
  }

  /// Adds a Profile to the database
  Future<int> addProfile({required Profile profile}) async {
    await _openDatabase();
    final result = await db!.insert(_profileTableName, profile.toMap());
    return result;
  }

  /// Makes sure that the SQLite database is initialized and opened
  Future<void> _openDatabase() async {
    db ??= await initDb();
  }
}