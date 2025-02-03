import 'dart:io';

import 'package:absensi_app_sqlite_130924/models/absensi.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper {
  static DbHelper? _dbhelper;
  static Database? _database;

  DbHelper.createObject(); //membantu database membuat table dan column

//benfungsi create project ketika dp helper kosong atau null
  factory DbHelper() {
    if (_dbhelper == null) {
      _dbhelper = DbHelper.createObject();
    }
    return _dbhelper!;
  }

  //pembuatan database dan init database
  Future<Database> initDb() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'absensi.db';

    var todoDatabase = openDatabase(path, version: 1, onCreate: _createDb);

    return todoDatabase;
  }

  void _createDb(Database db, int version) async {
    await db.execute('''
        CREATE TABLE absensi (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          nama TEXT,
          status_hadir TEXT

)
''');
  }

  //untuk get databasenya
  Future<Database> get database async {
    if (_database == null) {
      _database = await initDb();
    }
    return _database!;
  }

  // membuat get database untuk create,read, update, delete
  Future<List<Map<String, dynamic>>> select() async {
    Database db = await this.database;
    var mapList = await db.query('absensi', orderBy: 'nama');
    return mapList;
  }

  //Create, read, uodate, delete
  // Create
  Future<int> create(Absensi object) async {
    Database db = await this.database;
    int count = await db.insert('absensi', object.toMap());
    return count;
  }

  //Update
  Future<int> update(Absensi object) async {
    Database db = await this.database;
    int count = await db.update('absensi', object.toMap(),
        where: 'id=?', whereArgs: [object.id]);
    return count;
  }

//Delete
  Future<int> delete(int id) async {
    Database db = await this.database;
    int count = await db.delete('absensi', where: 'id=?', whereArgs: [id]);
    return count;
  }

//Read

  Future<List<Absensi>> getAbsensiList() async {
    var absensiMapList = await select();
    int count = absensiMapList.length;
    List<Absensi> absensiList = <Absensi>[];
    for (int i = 0; i < count; i++) {
      absensiList.add(Absensi.fromMap(absensiMapList[i]));
    }
    return absensiList;
  }
}
