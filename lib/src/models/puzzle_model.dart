// To parse this JSON data, do
//
//     final puzzle = puzzleFromJson(jsonString);

import 'dart:convert';

Puzzle puzzleFromJson(String str) => Puzzle.fromJson(json.decode(str));

String puzzleToJson(Puzzle data) => json.encode(data.toJson());

class Puzzle {
  Puzzle({
    this.result,
  });

  PuzzleResult result;

  factory Puzzle.fromJson(Map<String, dynamic> json) => Puzzle(
    result: PuzzleResult.fromJson(json["result"]),
  );

  Map<String, dynamic> toJson() => {
    "result": result.toJson(),
  };
}

class PuzzleResult {
  PuzzleResult({
    this.code,
    this.data,
  });

  int code;
  List<PuzzleDatum> data;

  factory PuzzleResult.fromJson(Map<String, dynamic> json) => PuzzleResult(
    code: json["code"],
    data: List<PuzzleDatum>.from(json["data"].map((x) => PuzzleDatum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class PuzzleDatum {
  PuzzleDatum({
    this.idImagen,
    this.imagenRuta,
    this.imagenTitulo,
    this.imagenSubida,
    this.imagenInicio,
    this.imagenFin,
    this.imagenEstado,
  });

  String idImagen;
  String imagenRuta;
  String imagenTitulo;
  String imagenSubida;
  String imagenInicio;
  String imagenFin;
  String imagenEstado;

  factory PuzzleDatum.fromJson(Map<String, dynamic> json) => PuzzleDatum(
    idImagen: json["id_imagen"],
    imagenRuta: json["imagen_ruta"],
    imagenTitulo: json["imagen_titulo"],
    imagenSubida: json["imagen_subida"],
    imagenInicio:  json["imagen_inicio"],
    imagenFin:  json["imagen_fin"],
    imagenEstado: json["imagen_estado"],
  );

  Map<String, dynamic> toJson() => {
    "id_imagen": idImagen,
    "imagen_ruta": imagenRuta,
    "imagen_titulo": imagenTitulo,
    "imagen_subida": imagenSubida,
    "imagen_inicio": imagenInicio,
    "imagen_fin": imagenFin,
    "imagen_estado": imagenEstado,
  };


}
class RankingPuzzle{
  RankingPuzzle({
    this.idPuzzle,
    this.personName,
    this.puzzleTiempo,
    this.puzzleFecha,
    this.userImage,
    this.path,
    this.idImagen,
  });

  

  String idPuzzle;
  String personName;
  String puzzleTiempo;
  String puzzleFecha;
  String userImage;
  String path;
  String idImagen;

  factory RankingPuzzle.fromJson(Map<String, dynamic> json) => RankingPuzzle(
    idPuzzle: json["id_puzzle"],
    personName: json["nombre"],
    puzzleTiempo: json["tiempo"],
    userImage: json["foto"],
    puzzleFecha: json["fecha"],
  );

  Map<String, dynamic> toJson() => {
    "id_puzzle": idPuzzle,
    "nombre": personName,
    "tiempo": puzzleTiempo,
    "fecha": puzzleFecha,
  };

}
