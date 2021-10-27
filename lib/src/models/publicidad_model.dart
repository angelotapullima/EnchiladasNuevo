


class PublicidadModel{


  String idPublicidad;
  String publicidadImagen;
  String publicidadEstado;
  String publicidadTipo;
  String idRelacionado;
  String pantalla;
  

PublicidadModel({
  this.idPublicidad,
  this.publicidadImagen,
  this.publicidadEstado,
  this.publicidadTipo,
  this.idRelacionado,
  this.pantalla
});


factory PublicidadModel.fromJson(Map<String, dynamic> json) => PublicidadModel(
    idPublicidad: json["publicidad_id"],
    publicidadImagen: json["publicidad_imagen"],
    publicidadEstado: json["publicidad_estado"],
    publicidadTipo: json["publicidad_tipo"],
    idRelacionado:  json["id_relacionado"],
    pantalla:  json["pantalla"],
  );

}