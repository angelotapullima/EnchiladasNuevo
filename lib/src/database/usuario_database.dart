import 'package:enchiladasapp/src/database/database_provider.dart';
import 'package:enchiladasapp/src/models/user.dart';

class UsuarioDatabase {
  final dbprovider = DatabaseProvider.db; 

  insertarUsuariosDb(User user) async {
    final db = await dbprovider.database;

    final res = await db.rawInsert(
        "INSERT or REPLACE INTO Usuario (c_u,idRel,nombre,email,foto,dni,id_direccion,id_zona,token,telefono,c_p) "
        "VALUES ( '${user.cU}' , '${user.idRel}' , '${user.personName}' ,"
        " '${user.userEmail}' , '${user.foto}' , '${user.dni}', ${user.idDireccion} ,'${user.idZona}',"
        " '${user.token}','${user.telefono}', '${user.cP}' )");
    return res;
  }

  deleteUser() async {
    final db = await dbprovider.database;

    final res = await db.rawDelete('DELETE FROM Usuario');

    return res;
  }

  updateTelefonoUsuario(String telefono) async {
    try {
      final db = await dbprovider.database;

      final res = await db.rawUpdate("UPDATE Usuario SET "
          "telefono='$telefono' ");

      return res;
    } catch (exception) {
      print(exception);
    }
  }

  

  updateDireccionUsuario(int direccion) async {
    final db = await dbprovider.database;

    final res = await db.rawUpdate("UPDATE Usuario SET "
        "id_direccion='$direccion' ");

    return res;
  }

  Future<List<User>> obtenerUsUario() async {
    final db = await dbprovider.database;
    final res = await db.rawQuery("SELECT * FROM Usuario");

    List<User> list =
        res.isNotEmpty ? res.map((c) => User.fromJson(c)).toList() : [];

    return list;
  }

  updateZonaUsuario(String zona) async {
    final db = await dbprovider.database;

    final res = await db.rawUpdate("UPDATE Usuario SET id_zona='$zona' ");

    return res;
  }
}
