class Direccion {
  int id_direccion;
  String idZona;
  String titulo;
  String direccion;
  String latitud;
  String longitud;
  String seleccionado;
  String referencia;

  String zonaNombre;
  String zonaTiempo;
  String zonaPedidoMinimo;
  String recargoProductoNombre;
  String deliveryProductoNombre;
  String recargoProductoPrecio;
  String deliveryProductoPrecio;

  Direccion({
    this.id_direccion,
    this.idZona,
    this.titulo,
    this.direccion,
    this.latitud,
    this.longitud,
    this.seleccionado,
    this.referencia,
    this.zonaNombre,
    this.zonaTiempo,
    this.zonaPedidoMinimo,
    this.recargoProductoNombre,
    this.deliveryProductoNombre,
    this.recargoProductoPrecio,
    this.deliveryProductoPrecio,
  });

  factory Direccion.fromJson(Map<String, dynamic> json) => Direccion(
        id_direccion: json["id_direccion"],
        idZona: json["id_zona"],
        titulo: json["titulo"],
        direccion: json["direccion"],
        latitud: json["latitud"],
        longitud: json["longitud"],
        seleccionado: json["seleccionado"],
        referencia: json["referencia"],

        
        zonaNombre: json["zona_nombre"],
        zonaTiempo: json["zona_tiempo"],
        zonaPedidoMinimo: json["zona_pedido_minimo"],
        recargoProductoNombre: json["recargo_producto_nombre"],
        deliveryProductoNombre: json["delivery_producto_nombre"],
        recargoProductoPrecio: json["recargo_producto_precio"],
        deliveryProductoPrecio: json["delivery_producto_precio"],
      );

  Map<String, dynamic> toJson() => {
        "id_direccion": id_direccion,
        "id_zona": idZona,
        "titulo": titulo,
        "direccion": direccion,
        "latitud": latitud,
        "longitud": longitud,
        "seleccionado": seleccionado,
        "referencia": referencia,
      };
}
