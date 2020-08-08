

class Zona {
  String idZona;
  String zonaNombre;
  String zonaPedidoMinimo;
  String zonaImagen;
  String idProducto;
  String zonaDescripcion;
  String zonaPrecio;

  Zona({
    this.idZona,
    this.zonaNombre,
    this.zonaPedidoMinimo,
    this.zonaImagen,
    this.idProducto,
    this.zonaDescripcion,
    this.zonaPrecio,
  });

  factory Zona.fromJson(Map<String, dynamic> json) => Zona(
    idZona: json["id_zona"],
    zonaNombre: json["zona_nombre"],
    zonaPedidoMinimo: json["zona_pedido_minimo"],
    zonaImagen: json["zona_imagen"],
    idProducto: json["id_producto"],
    zonaDescripcion: json["zona_descripcion"],
  );

  Map<String, dynamic> toJson() => {
    "id_zona": idZona,
    "zona_nombre": zonaNombre,
    "zona_pedido_minimo": zonaPedidoMinimo,
    "zona_imagen": zonaImagen,
    "id_producto": idProducto,
    "zona_descripcion": zonaDescripcion,
  };
}