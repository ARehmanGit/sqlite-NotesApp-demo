import 'package:mynotesapp/notes.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper {
  static const _dbName = 'notes.db';
  static const _dbVersion = 1;
  static const columnId = 'id';
  static const columnName = 'name';
  static const columnDescription = 'description';
  static const table = 'mytable';
  static Database? _database;

  DbHelper._privateconstructor();
  static final DbHelper instance = DbHelper._privateconstructor();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await initDatabase();
    return _database!;
  }

  initDatabase() async {
    String path = join(await getDatabasesPath(), _dbName);
    return await openDatabase(path, version: _dbVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    return await db.execute(
        """CREATE TABLE $table ($columnId INTEGER PRIMARY KEY NOT NULL, $columnName TEXT NOT NULL, $columnDescription TEXT NOT NULL)""");
  }

  Future<int> insertNote(Note note) async {
    Database db = await instance.database;
    return await db.insert(table, note.toMap());
  }

  Future<List<Note>> fetchAllNotes() async {
    Database db = await instance.database;
    List<Map<String, dynamic>> maps = await db.query(table);
    return List.generate(maps.length, (index) => Note.fromJson(maps[index]));
  }

  Future<int> updateNote(Note note) async {
    Database db = await instance.database;
    return await db.update(table, note.toMap(),
        where: '$columnId = ?', whereArgs: [note.id]);
  }

  Future<int> deleteNote(int id) async {
    Database db = await instance.database;
    return await db.delete(table, where: '$columnId = ?', whereArgs: [id]);
  }
}
