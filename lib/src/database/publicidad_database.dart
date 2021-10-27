import 'package:enchiladasapp/src/database/database_provider.dart';
import 'package:enchiladasapp/src/models/publicidad_model.dart';

class PublicidadDatabase {
  final dbprovider = DatabaseProvider.db;

  insertarPublicidad(PublicidadModel publicidadModel) async {
    try {
      final db = await dbprovider.database;

      final res = await db.rawInsert(
          "INSERT OR REPLACE INTO Publicidad (publicidad_id,publicidad_imagen,publicidad_estado,"
          "publicidad_tipo,pantalla,id_relacionado) "
          "VALUES ('${publicidadModel.idPublicidad}','${publicidadModel.publicidadImagen}','${publicidadModel.publicidadEstado}',"
          "'${publicidadModel.publicidadTipo}','${publicidadModel.pantalla}','${publicidadModel.idRelacionado}'"
          ")");
      return res;
    } catch (exception) {
      print(exception);
    }
  }

  Future<List<PublicidadModel>> obtenerPublicidad(String dato) async {
    final db = await dbprovider.database;
    final res = await db.rawQuery("SELECT * FROM Publicidad where  pantalla = '$dato'");

    List<PublicidadModel> list = res.isNotEmpty
        ? res.map((c) => PublicidadModel.fromJson(c)).toList()
        : [];

    return list;
  }

  deletePublcidadDb() async {
    final db = await dbprovider.database;

    final res = await db.rawDelete('DELETE FROM Publicidad');

    return res;
  }
}
