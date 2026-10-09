import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/intervention.dart';

/// Cache local des interventions, pour travailler sans réseau.
class LocalDb {
  Database? _db;

  Future<Database> get db async {
    _db ??= await openDatabase(
      join(await getDatabasesPath(), 'fieldops.db'),
      version: 1,
      onCreate: (db, version) => db.execute(
        'CREATE TABLE interventions (id INTEGER PRIMARY KEY, address TEXT, starts_at TEXT, status TEXT, report TEXT)',
      ),
    );
    return _db!;
  }

  Future<void> saveAll(List<Intervention> interventions) async {
    final database = await db;
    final batch = database.batch();
    for (final intervention in interventions) {
      batch.insert('interventions', intervention.toJson(), conflictAlgorithm: ConflictAlgorithm.replace);
    }
    await batch.commit(noResult: true);
  }

  Future<Intervention?> findById(String id) async {
    final database = await db;
    // FIXME: identifiant interpolé dans la requête
    final rows = await database.rawQuery("SELECT * FROM interventions WHERE id = $id");
    return rows.isEmpty ? null : Intervention.fromJson(rows.first);
  }
}
