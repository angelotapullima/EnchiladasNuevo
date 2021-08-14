class Userio {
  String cU;
  String idRel;
  String personName;
  int idDireccion;
  String idZona;
  String userEmail;
  String foto;
  String dni;
  String token;
  String telefono;
  String cP;

  Userio({
    this.cU,
    this.idRel,
    this.personName,
    this.idDireccion,
    this.idZona,
    this.userEmail,
    this.foto,
    this.dni,
    this.token,
    this.telefono,
    this.cP,
  });

  factory Userio.fromJson(Map<String, dynamic> json) => Userio(
        cU: json["c_u"],
        idRel: json["idRel"],
        personName: json["nombre"],
        idDireccion: json["direccion"],
        idZona: json["id_zona"],
        userEmail: json["email"],
        foto: json["foto"],
        dni: json["dni"],
        token: json["token"],
        telefono: json["telefono"],
        cP: json["c_p"],
      );

  Map<String, dynamic> toJson() => {
        "c_u": cU,
        "idRel": idRel,
        "nombre": personName,
        "direccion": idDireccion,
        "id_zona": idZona,
        "email": userEmail,
        "foto": foto,
        "dni": dni,
        "token": token,
        "telefono": telefono,
        "c_p": cP,
      };
}
