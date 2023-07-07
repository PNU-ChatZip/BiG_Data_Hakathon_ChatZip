import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class ChannelProvider {
  late Database _database;

  Future<Database?> get database async {
    _database = await initDB();
    return _database;
  }

  initDB() async {
    String path = join(await getDatabasesPath(), 'Channels.db');
    return await openDatabase(path, version: 1, onCreate: (db, version) async {
      await db.execute('''
          CREATE TABLE Channels(
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              icon TEXT NOT NULL,
              chats 
            )
        ''');
    });
  }
}
