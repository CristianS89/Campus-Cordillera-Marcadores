
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;
import 'package:macador_bd_cs/models/marker_model.dart';

class DBService {
  static Database? _db;

  //Función para crear la BD en caso de que la BD exista no la crea nuevamente
  static Future<Database> _getDb() async {
    if (_db != null) return _db!;
    final dbPath = await getDatabasesPath();
    final path = p.join(dbPath, 'markers.db');
    _db = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE markers(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT NOT NULL,
            lat REAL NOT NULL,
            lng REAL NOT NULL,
            imagePath TEXT
          )
        ''');
      },
    );
    return _db!;
  }

  //Lista todos los registros de la tabla y lo ordena según el id de forma descendente
  static Future<List<MarkerModel>> fetchAll() async {
    final db = await _getDb();
    final rows = await db.query('markers', orderBy: 'id DESC');
    return rows.map((e) => MarkerModel.fromMap(e)).toList();
  }

  //Inserta un nuevo registro en la tabla
  static Future<int> insert(MarkerModel m) async {
    final db = await _getDb();
    return db.insert('markers', m.toMap());
  }

  //Actualiza un registro existente de la tabla según el id del marcador seleccionado
  static Future<int> update(MarkerModel m) async {
    final db = await _getDb();
    return db.update('markers', m.toMap(), where: 'id = ?', whereArgs: [m.id]);
  }

  //Elimina un registro de la tabla según el id seleccionado
  static Future<int> delete(int id) async {
    final db = await _getDb();
    return db.delete('markers', where: 'id = ?', whereArgs: [id]);
  }

  //Elimina todos los registros de la tabla
  static Future<int> clear() async {
    final db = await _getDb();
    return db.delete('markers');
  }
}
