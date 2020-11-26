

 

import 'package:enchiladasapp/src/database/database_provider.dart';
import 'package:enchiladasapp/src/models/direccion_model.dart';

class DireccionDatabase{

  final dbprovider = DatabaseProvider.db;

  insertarDireccionDb(Direccion direccion) async {
    try {
      final db = await dbprovider.database;

      final res = await db.rawInsert(
          "INSERT INTO Direccion (id_zona,titulo,direccion,latitud,longitud,seleccionado,referencia) "
          "VALUES ('${direccion.idZona}','${direccion.titulo}','${direccion.direccion}','${direccion.latitud}','${direccion.longitud}','${direccion.seleccionado}','${direccion.referencia}'"
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

  deleteDireccionPorId(String id)async{
      final db = await dbprovider.database;

    final res = await db.rawDelete("DELETE FROM Direccion where id_direccion = '$id'");

    return res;
  }

  seleccionarDireccion(String id)async{

    final db = await dbprovider.database;

    final res = await db.rawDelete("UPDATE  Direccion set seleccionado = 1 where id_direccion='$id'");

    return res;
  }
  ponerTodos0()async{

    final db = await dbprovider.database;

    final res = await db.rawDelete('UPDATE  Direccion set seleccionado = 0');

    return res;
  }


  Future<List<Direccion>> obtenerDirecciones() async {
    final db = await dbprovider.database;
    final res = await db.rawQuery('SELECT * FROM Direccion d inner join Zona z on d.id_zona=z.id_zona');

    List<Direccion> list =
        res.isNotEmpty ? res.map((c) => Direccion.fromJson(c)).toList() : [];

    return list;
  }


 
  Future<List<Direccion>> obtenerDireccionesConZonas() async {
    final db = await dbprovider.database;
    final res = await db.rawQuery("SELECT * FROM Direccion d inner join Zona z on d.id_zona=z.id_zona where seleccionado = 1");

    List<Direccion> list =
        res.isNotEmpty ? res.map((c) => Direccion.fromJson(c)).toList() : [];

    return list;
  }



}