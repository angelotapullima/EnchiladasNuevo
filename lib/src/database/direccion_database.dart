

 

import 'package:enchiladasapp/src/database/database_provider.dart';
import 'package:enchiladasapp/src/models/direccion_model.dart';

class DireccionDatabase{

  final dbprovider = DatabaseProvider.db;

  insertarDireccionDb(Direccion direccion) async {
    try {
      final db = await dbprovider.database;

      final res = await db.rawInsert(
          "INSERT OR REPLACE INTO Direccion (direccion,latitud,longitud,referencia) "
          "VALUES ('${direccion.direccion}','${direccion.latitud}','${direccion.longitud}','${direccion.referencia}'"
          ")");
      return res;
    } catch (exception) {
      print(exception);
    }
  }

  deleteDireccion()async{
      final db = await dbprovider.database;

    final res = await db.rawDelete('DELETE FROM Direccion');

    return res;
  }


  Future<List<Direccion>> obtenerdireccion() async {
    final db = await dbprovider.database;
    final res = await db.query('Direccion');

    List<Direccion> list =
        res.isNotEmpty ? res.map((c) => Direccion.fromJson(c)).toList() : [];

    return list;
  }

}