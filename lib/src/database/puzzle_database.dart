
import 'package:enchiladasapp/src/database/database_provider.dart';
import 'package:enchiladasapp/src/models/puzzle_model.dart';


class PuzzleDatabase{

  final dbprovider = DatabaseProvider.db;  

  insertarPuzzle(PuzzleDatum puzzle) async {
    try {
      final db = await dbprovider.database;

      final res = await db.rawInsert(
          "INSERT OR REPLACE INTO Puzzle (id_imagen,imagen_ruta,imagen_titulo,imagen_subida,imagen_inicio,imagen_fin,imagen_estado) "
          "VALUES ('${puzzle.idImagen}','${puzzle.imagenRuta}','${puzzle.imagenTitulo}','${puzzle.imagenSubida}',"
          "'${puzzle.imagenInicio}','${puzzle.imagenFin}','${puzzle.imagenEstado}')");
      return res;
    } catch (exception) {
      print(exception);
    }
  }

  Future<List<PuzzleDatum>> consultarPuzzle() async {
      final db = await dbprovider.database;
      final res =
          await db.rawQuery("SELECT * FROM Puzzle WHERE imagen_estado='1'");

      List<PuzzleDatum> list = res.isNotEmpty
          ? res.map((c) => PuzzleDatum.fromJson(c)).toList()
          : [];

      return list;
  } 


  Future<List<PuzzleDatum>> obtenerPuzzle() async {
      final db = await dbprovider.database;
      final res =
          await db.rawQuery("SELECT * FROM Puzzle ");

      List<PuzzleDatum> list = res.isNotEmpty
          ? res.map((c) => PuzzleDatum.fromJson(c)).toList()
          : [];

      return list;
  } 
}