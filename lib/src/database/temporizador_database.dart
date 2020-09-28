import 'package:enchiladasapp/src/database/database_provider.dart';
import 'package:enchiladasapp/src/models/temporizador_model.dart';

class TemporizadorDatabase {
  final dbprovider = DatabaseProvider.db;

  insertarTemporizador(TemporizadorModel temporizadorModel) async {
    try {
      final db = await dbprovider.database;

      final res = await db.rawInsert(
          "INSERT OR REPLACE INTO Temporizador (idTemporizador,temporizador_tipo,temporizador_fechainicio,temporizador_fechafin,"
          "temporizador_horainicio,temporizador_horafin,temporizador_lunes,temporizador_martes,temporizador_miercoles,"
          "temporizador_jueves,temporizador_viernes,temporizador_sabado,temporizador_domingo) "
          "VALUES ('${temporizadorModel.idTemporizador}','${temporizadorModel.temporizadorTipo}','${temporizadorModel.temporizadorFechainicio}'"
          ",'${temporizadorModel.temporizadorFechafin}','${temporizadorModel.temporizadorHorainicio}','${temporizadorModel.temporizadorHorafin}',"
          "'${temporizadorModel.temporizadorLunes}','${temporizadorModel.temporizadorMartes}','${temporizadorModel.temporizadorMiercoles}',"
          "'${temporizadorModel.temporizadorJueves}','${temporizadorModel.temporizadorViernes}','${temporizadorModel.temporizadorSabado}','${temporizadorModel.temporizadorDomingo}'"
          ")");
      return res;
    } catch (exception) {
      print(exception);
    }
  }

  Future<List<TemporizadorModel>> obtenerTemporizadorPorIdCategoria(
      String idCategoria) async {
    final db = await dbprovider.database;
    final res = await db.rawQuery(
        "SELECT * FROM Temporizador where idTemporizador ='$idCategoria' ");

    List<TemporizadorModel> list = res.isNotEmpty
        ? res.map((c) => TemporizadorModel.fromJson(c)).toList()
        : [];

    return list;
  }
}
