import 'package:enchiladasapp/src/database/puzzle_database.dart';
import 'package:enchiladasapp/src/database/ranking_database.dart';
import 'package:enchiladasapp/src/models/puzzle_model.dart';
import 'package:enchiladasapp/src/utils/preferencias_usuario.dart';
import 'package:http/http.dart' as http;

import 'dart:async';
import 'dart:convert'; 

class PuzzleApi {
  final String _url = 'https://delivery.lacasadelasenchiladas.pe';
  final prefs = Preferences();
  final rankingDatabase=RankingDatabase();
  final puzzleDatabase = PuzzleDatabase();
  Future<List<PuzzleDatum>> obtenerImagenesPuzzle() async {
    final url = '$_url/api/puzzle/listar_imagenes_activa';
    final list = List<PuzzleDatum>();
    final resp = await http.post(url, body: {'app': 'true', 'tn': prefs.token});
 
    final decodedData = json.decode(resp.body);
    if (decodedData['result']['code'] == 1) {
      if (decodedData['result']['data'].length > 0) {
        for (int i = 0; i < decodedData['result']['data'].length; i++) {
          PuzzleDatum puzzle = PuzzleDatum();
          puzzle.idImagen = decodedData['result']['data'][i]['id_imagen'];
          puzzle.imagenRuta = decodedData['result']['data'][i]['imagen_ruta'];
          puzzle.imagenTitulo =
              decodedData['result']['data'][i]['imagen_titulo'];
          puzzle.imagenSubida =
              decodedData['result']['data'][i]['imagen_subida'];
          puzzle.imagenInicio =
              decodedData['result']['data'][i]['imagen_inicio'];
          puzzle.imagenFin = decodedData['result']['data'][i]['imagen_fin'];
          puzzle.imagenEstado =
              decodedData['result']['data'][i]['imagen_estado'];


          await puzzleDatabase.insertarPuzzle(puzzle);
          list.add(puzzle);
        }
      }
      return list;
    } else {
      return [];
    }
  }

  Future<bool> obtenerTiemposDia(String fecha) async {
    final formatFecha = fecha.split(' ');
    var formatFecha1 = formatFecha[0].toString();



    final url = '$_url/api/puzzle/listar_tiempos_dia'; 
    final resp = await http.post(url, body: {'app': 'true', 'tn': prefs.token,'puzzle_fecha':formatFecha1.toString()});

    final decodedData = json.decode(resp.body);

    print('listar dia $decodedData');
    if (decodedData['result']['code'] == 1) {
      if (decodedData['result']['data'].length > 0) {
        for (int i = 0; i < decodedData['result']['data'].length; i++) {

          RankingPuzzle puzzle = RankingPuzzle();
          puzzle.idPuzzle = decodedData['result']['data'][i]['user_email'];
          puzzle.personName = decodedData['result']['data'][i]['person_name'];
          puzzle.puzzleFecha = decodedData['result']['data'][i]['puzzle_fecha'];
          puzzle.userImage = decodedData['result']['data'][i]['user_image'];
          puzzle.puzzleTiempo =
          decodedData['result']['data'][i]['puzzle_tiempo'];
          await rankingDatabase.insertarRanking(puzzle);
        }
      }
      return true;
    } else {
      return false;
    }
  }

  Future<bool> subirTiempo(String tiempo,String idImagen)async{
    final url = '$_url/api/puzzle/subir_tiempo'; 
     
    final resp = await http.post(url, body: {
      'app': 'true',
      'puzzle_tiempo': tiempo,
      'id_user': prefs.idUser,
      'id_imagen': idImagen,
      'tn': prefs.token
    });

    final decodedData = json.decode(resp.body);
    print('subir $decodedData');
    if (decodedData['result']['code'] == 1) { 
      
      if (decodedData['result']['data'].length > 0) {
       for (int i = 0; i < decodedData['result']['data'].length; i++) {

          RankingPuzzle puzzle = RankingPuzzle();
          puzzle.idPuzzle = decodedData['result']['data'][i]['user_email'];
          puzzle.personName = decodedData['result']['data'][i]['person_name'];
          puzzle.puzzleFecha = decodedData['result']['data'][i]['puzzle_fecha'];
          puzzle.userImage = decodedData['result']['data'][i]['user_image'];
          puzzle.puzzleTiempo =
          decodedData['result']['data'][i]['puzzle_tiempo']; 
          await rankingDatabase.insertarRanking(puzzle);
        }
      }
      return true; 
    } else {
      return false;
    }

  }
}
