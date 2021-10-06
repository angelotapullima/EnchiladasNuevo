/* 

import 'package:enchiladasapp/src/database/database_provider.dart';
import 'package:enchiladasapp/src/puzzle/puzzle_model.dart';

class RankingDatabase{


  final dbprovider = DatabaseProvider.db;

  insertarRanking(RankingPuzzle ranking) async {
    try {
      final db = await dbprovider.database;

      final res = await db.rawInsert(
          "INSERT OR REPLACE INTO Ranking (id_puzzle,nombre,tiempo,foto,fecha) "
          "VALUES ('${ranking.idPuzzle}','${ranking.personName}',"
          "'${ranking.puzzleTiempo}','${ranking.userImage}','${ranking.puzzleFecha}')");
      return res;
    } catch (exception) {
      print(exception);
    }
  }

  Future<List<RankingPuzzle>> obtenerRankingPorFecha(String fecha) async {
      final db = await dbprovider.database;
      final res =
          await db.rawQuery("SELECT * FROM Ranking WHERE fecha='$fecha'");

      List<RankingPuzzle> list = res.isNotEmpty
          ? res.map((c) => RankingPuzzle.fromJson(c)).toList()
          : [];

      return list;
  } 
} */