import "package:sqflite/sqflite.dart";
import "dart:async";
import "dart:io";
import "package:path_provider/path_provider.dart";
import "package:note_keeper_lecture/models/Note.dart";

class DatabaseHelper {
  static DatabaseHelper _databaseHelper;
  static Database _database;

  String tableName = "note_table";
  String colId = "id";
  String colTitle = "title";
  String colDescription = "description";
  String colPriority = "priority";
  String colDate = "date";

  DatabaseHelper._createInstance();

  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper._createInstance();
    }
    return _databaseHelper;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initializerDatabase();
    }
    return _database;
  }

  Future<Database> initializerDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + "notes.db";

    var noteDatabase = await openDatabase(path, version: 1, onCreate: _createDB);
    return noteDatabase;
  }

  void _createDB(Database db, int newVersion) async {
    await db.execute(
        "CREATE TABLE $tableName ("
        "  $colId INTEGER PRIMARY KEY AUTOINCREMENT,"
        "  $colTitle TEXT,"
        "  $colDescription TEXT,"
        "  $colPriority INTEGER,"
        "  $colDate TIMESTAMP"
        ")");
  }

  Future<List<Map<String, dynamic>>> getNoteMapList() async {
    Database db = await this.database;

    var result = await db.rawQuery(
      "SELECT * FROM $tableName "
      "ORDER BY $colPriority ASC"
    );
    result = await db.query(tableName, orderBy: "$colPriority ASC");

    return result;
  }

  Future<int> insertNote(Note note) async {
    Database db = await this.database;

    var result = await db.insert(tableName, note.toMap());
    return result;
  }

  Future<int> updateNote(Note note) async {
    Database db = await this.database;
    var result = await db.update(tableName, note.toMap(), where: "$colId = ?",
      whereArgs: [note.id]);
    return result;
  }

  Future<int> deleteNote(int id) async {
    Database db = await this.database;
    var result = await db.delete(tableName, where: "$colId = ?", whereArgs: [id]);
    return result;
  }

  Future<int> getCount() async {
    Database db = await this.database;
    List<Map<String, dynamic>> fetch = await db.rawQuery("SELECT COUNT(id) FROM $tableName");
    int result = Sqflite.firstIntValue(fetch);
    return result;
  }
}