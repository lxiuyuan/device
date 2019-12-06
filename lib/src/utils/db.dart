import 'package:sqflite/sqflite.dart';
class DBUtils{
  static Database _db;

  static Future<void> _openDb() async{
    if(_db==null||!_db.isOpen){
      _db= await openDatabase('my_db.db',version: 1 );
    }
  }

  static Future<void> createDb(int version,
      Future<void>Function(Database db, int version) onCreate,)async {

    _db=await openDatabase('my_db.db',version: version,onCreate:(Database db, int version) async{
      return await onCreate(db,version);
    });
  }

  static Future<void> execute(Database db,String sql) async {
    db.execute(sql);
  }

  static Future<void> delegateDb() async{
    deleteDatabase('my_db.db');

  }

  static Future<List<Map<String, dynamic>>> query(String sql) async {
    _openDb();
    return await _db.rawQuery(sql);
  }
  static Future<int> insert(String sql) async {
    _openDb();
    return await _db.rawInsert(sql);
  }

  static Future<int> delegate(String sql) async {
    _openDb();
    return await _db.rawDelete(sql);
  }
  static Future<int> update(String sql) async {
    _openDb();
    return await _db.rawUpdate(sql);
  }

  static Future<void> close()async{
    if(_db!=null&&_db.isOpen){
      return await _db.close();
    }
  }

}