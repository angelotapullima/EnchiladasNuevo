



class Direccion {
  int id;
  String direccion;
  String latitud;
  String longitud;
  String referencia; 

  Direccion({
    this.id,
    this.direccion,
    this.latitud,
    this.longitud,
    this.referencia, 
  });

  factory Direccion.fromJson(Map<String, dynamic> json) => Direccion(
        id: json["id"],
        direccion: json["direccion"],
        latitud: json["latitud"],
        longitud: json["longitud"],
        referencia: json["referencia"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "direccion": direccion,
        "latitud": latitud,
        "longitud": longitud,
        "referencia": referencia, 
      };
}
