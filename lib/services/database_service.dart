import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/person.dart';
import '../models/memory.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'remember_me.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Create people table
    await db.execute('''
      CREATE TABLE people (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        relationship TEXT NOT NULL,
        details TEXT,
        photo_path TEXT,
        face_embedding BLOB,
        created_at TEXT NOT NULL
      )
    ''');

    // Create memories table
    await db.execute('''
      CREATE TABLE memories (
        id TEXT PRIMARY KEY,
        type TEXT NOT NULL,
        content TEXT NOT NULL,
        title TEXT,
        description TEXT,
        date TEXT NOT NULL,
        embedding BLOB,
        related_people_ids TEXT
      )
    ''');
  }

  // Person CRUD operations
  Future<void> insertPerson(Person person) async {
    final db = await database;
    await db.insert(
      'people',
      person.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Person>> getAllPeople() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('people');
    return List.generate(maps.length, (i) => Person.fromMap(maps[i]));
  }

  Future<Person?> getPersonById(String id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'people',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isEmpty) return null;
    return Person.fromMap(maps.first);
  }

  Future<void> updatePerson(Person person) async {
    final db = await database;
    await db.update(
      'people',
      person.toMap(),
      where: 'id = ?',
      whereArgs: [person.id],
    );
  }

  Future<void> deletePerson(String id) async {
    final db = await database;
    await db.delete(
      'people',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Memory CRUD operations
  Future<void> insertMemory(Memory memory) async {
    final db = await database;
    await db.insert(
      'memories',
      memory.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Memory>> getAllMemories() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'memories',
      orderBy: 'date DESC',
    );
    return List.generate(maps.length, (i) => Memory.fromMap(maps[i]));
  }

  Future<Memory?> getMemoryById(String id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'memories',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isEmpty) return null;
    return Memory.fromMap(maps.first);
  }

  Future<List<Memory>> getMemoriesByPersonId(String personId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'memories',
      where: 'related_people_ids LIKE ?',
      whereArgs: ['%$personId%'],
      orderBy: 'date DESC',
    );
    return List.generate(maps.length, (i) => Memory.fromMap(maps[i]));
  }

  Future<void> updateMemory(Memory memory) async {
    final db = await database;
    await db.update(
      'memories',
      memory.toMap(),
      where: 'id = ?',
      whereArgs: [memory.id],
    );
  }

  Future<void> deleteMemory(String id) async {
    final db = await database;
    await db.delete(
      'memories',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Close database
  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}
