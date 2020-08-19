

class Zona {
  String idZona;
  String zonaNombre;
  String zonaPedidoMinimo;
  String zonaImagen;
  String idProducto;
  String zonaDescripcion;
  String zonaPrecio;
  String route;
  String zonaEstado;

  Zona({
    this.idZona,
    this.zonaNombre,
    this.zonaPedidoMinimo,
    this.zonaImagen,
    this.idProducto,
    this.zonaDescripcion,
    this.zonaPrecio,
    this.zonaEstado,
  });

  factory Zona.fromJson(Map<String, dynamic> json) => Zona(
    idZona: json["id_zona"],
    zonaNombre: json["zona_nombre"],
    zonaPedidoMinimo: json["zona_pedido_minimo"],
    zonaImagen: json["zona_imagen"],
    idProducto: json["id_producto"],
    zonaDescripcion: json["zona_descripcion"],
    zonaEstado: json["zona_estado"],
  );

  Map<String, dynamic> toJson() => {
    "id_zona": idZona,
    "zona_nombre": zonaNombre,
    "zona_pedido_minimo": zonaPedidoMinimo,
    "zona_imagen": zonaImagen,
    "id_producto": idProducto,
    "zona_descripcion": zonaDescripcion,
    "zona_estado": zonaEstado,
  };
}