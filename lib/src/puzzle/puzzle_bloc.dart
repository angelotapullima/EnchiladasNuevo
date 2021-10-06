/* import 'package:enchiladasapp/src/api/puzzle_api.dart';
import 'package:enchiladasapp/src/database/puzzle_database.dart';
import 'package:enchiladasapp/src/database/ranking_database.dart';
import 'package:enchiladasapp/src/models/puzzle_model.dart';
import 'package:rxdart/rxdart.dart';

class PuzzleBloc {
  final puzzleApi = PuzzleApi();
  final rankingDatabase = RankingDatabase();
  //final puzzleDatabase = PuzzleDatabase();
  final _puzzleController = new BehaviorSubject<List<PuzzleDatum>>();
  final _puzzleTiemposController = new BehaviorSubject<List<RankingPuzzle>>();
  final _cargandoTiempo = new BehaviorSubject<bool>();

  Stream<List<PuzzleDatum>> get puzzleStream => _puzzleController.stream;
  Stream<List<RankingPuzzle>> get puzzleTiempoStream =>
      _puzzleTiemposController.stream;
  Stream<bool> get cargandoTiempo => _cargandoTiempo.stream;

  dispose() {
    _puzzleController?.close();
    _puzzleTiemposController?.close();
    _cargandoTiempo?.close();
  }

  void obtenerPuzzle() async {
    _puzzleController.sink.add(await puzzleDatabase.consultarPuzzle());
    await puzzleApi.obtenerImagenesPuzzle();
    _puzzleController.sink.add(await puzzleDatabase.consultarPuzzle());
  }

  void obtenerTiempos(String fecha) async {
    _puzzleTiemposController.sink.add([]);
    _puzzleTiemposController.sink
        .add(await rankingDatabase.obtenerRankingPorFecha(fecha));
    await puzzleApi.obtenerTiemposDia(fecha);
    _puzzleTiemposController.sink
        .add(await rankingDatabase.obtenerRankingPorFecha(fecha));
  }

  void changeCargandoTiempo() async {
    _cargandoTiempo.sink.add(false);
  }

  void subirTiempo(String tiempo, String idImagen) async {
    _cargandoTiempo.sink.add(true);
    await puzzleApi.subirTiempo(tiempo, idImagen);
    _cargandoTiempo.sink.add(false);
  }
}
 */