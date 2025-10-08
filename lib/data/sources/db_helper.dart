import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class AppDatabase {
    static const _dbName = 'kothai_app.db'; // TODO: later add to ENV
    static const _dbVersion = 2; // Incremented version to trigger onUpgrade

    static Future<Database> open() async {
        final dbPath = await getDatabasesPath();
        final path = join(dbPath, _dbName);
        return openDatabase(
            path,
            version: _dbVersion,
            onCreate: (db, version) async {
                await db.execute('''
                CREATE TABLE typing_sessions (
                  id TEXT PRIMARY KEY,
                  mode TEXT NOT NULL,
                  difficulty TEXT NOT NULL,
                  startedAt INTEGER NOT NULL,
                  endedAt INTEGER NOT NULL,
                  typed INTEGER NOT NULL,
                  correct INTEGER NOT NULL,
                  errors INTEGER NOT NULL,
                  elapsedMs INTEGER NOT NULL
                );
                ''');
                // Also create xp_entries table during onCreate for fresh installs
                await db.execute('''
                 CREATE TABLE xp_entries (
                   id TEXT PRIMARY KEY,
                   at INTEGER NOT NULL,
                   mode TEXT NOT NULL,
                   amount INTEGER NOT NULL,
                   synced INTEGER NOT NULL DEFAULT 0,
                   sessionId TEXT
                 );
               ''');
            }
        );
    }
}
