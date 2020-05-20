import 'dart:io';

import 'package:limas_burger/model/usuario.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
class DataBaseHelper{
  
  static DataBaseHelper _dataBaseHelper;
  static Database _dataBase;
  
  String usuarioTable = 'usuario';
  String colId = 'id';
  String colNome = 'nome';
  String colEmail = 'email';
  String colSenha = 'senha';
  String colContato = 'contato';

  static DataBaseHelper getInstance() {
    if(_dataBaseHelper==null)
      _dataBaseHelper = DataBaseHelper();
    return _dataBaseHelper;
  }

  Future<Database> get database async{
    if(_dataBase == null){
      _dataBase = await initializeDataBase();
    }
    return _dataBase;
  }

  Future<Database> initializeDataBase() async{
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'usuario.db';

    var usuariosDataBase = await openDatabase(path, version: 1, onCreate:  _onCreate);
    return usuariosDataBase;
  }

  void _onCreate(Database database, int newVersion) async {
    await database.execute("CREATE TABLE $usuarioTable($colId INTEGER PRIMARY KEY, $colNome TEXT, $colSenha TEXT, $colEmail TEXT, $colContato TEXT)",);
  }

  Future<int> insertUsuario(Usuario usuario) async {
    Database db = await this.database;
    var resultado;
    try {
      resultado = await db.insert(usuarioTable, usuario.toMap());
    }catch(e){

    }
     

    return resultado;
  }

  Future<Usuario> getUsuario() async {
    Database db = await this.database;
    List maps = await db.query(usuarioTable,
      columns: [colId, colNome, colEmail, colSenha, colContato],
    );

    if(maps!=null && maps.length  > 0){
      return Usuario(
        maps[0]['id'],
        maps[0]['nome'],
        maps[0]['senha'],
        maps[0]['email'],
        maps[0]['contato'],
        null
      );
    }else{
      return null;
    }
  }

  Future<int> deletUsuario(int id) async {
    Database db = await this.database;
    int resultado = await db.delete(usuarioTable,
      where: "$colId = ?",
      whereArgs: [id]
    );

    return resultado;
  }
}