import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static Database? _database;

  // Method to initialize the database
  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    // Initialize the database if it is not initialized
    _database = await _initializeDatabase();
    return _database!;
  }

  // Method to create the database and tables
  Future<Database> _initializeDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'health_tracker.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            username TEXT UNIQUE NOT NULL,
            password TEXT NOT NULL
          )
        ''');
        await db.execute('''
  CREATE TABLE health_data (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    sleepHours INTEGER NOT NULL,
    walkingSteps INTEGER NOT NULL,
    waterDrank INTEGER NOT NULL,
    weight INTEGER NOT NULL,
    height INTEGER NOT NULL
  )
''');
      },
    );
  }

  // Insert a new user into the database
  Future<void> insertUser(Map<String, dynamic> userData) async {
    final db = await database;
    await db.insert('users', userData,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // Get a user by username
  Future<Map<String, dynamic>?> getUser(String username) async {
    final db = await database;
    final result = await db.query(
      'users',
      where: 'username = ?',
      whereArgs: [username],
    );
    if (result.isEmpty) {
      return null;
    }
    return result.first;
  }

  // Insert health data
  Future<void> insertHealthData(Map<String, dynamic> data) async {
    final db = await database;
    await db.insert('health_data', data,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // New method to insert a single record into health_data
  Future<void> insertRecord(Map<String, dynamic> record) async {
    final db = await database;
    await db.insert('health_data', record,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // Update health data
  Future<void> updateHealthData(int id, Map<String, dynamic> data) async {
    final db = await database;
    await db.update(
      'health_data',
      data,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Delete health data
  Future<void> deleteHealthData(int id) async {
    final db = await database;
    await db.delete(
      'health_data',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Query all health data
  Future<List<Map<String, dynamic>>> queryAllHealthData() async {
    final db = await database;
    return await db.query('health_data');
  }
}
