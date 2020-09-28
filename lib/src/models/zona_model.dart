

class Zona {
  String idZona;
  String zonaNombre;
  String zonaPedidoMinimo;
  String zonaImagen; 
  String zonaDescripcion;
  String route;
  String zonaEstado;
  String zonaTiempo;
  String recargoProductoNombre;
  String deliveryProductoNombre;
  String recargoProductoPrecio;
  String deliveryProductoPrecio;

  Zona({
    this.idZona,
    this.zonaNombre,
    this.zonaPedidoMinimo, 
    this.zonaImagen, 
    this.zonaDescripcion,
    this.zonaEstado,
    this.zonaTiempo,
    this.recargoProductoNombre,
    this.deliveryProductoNombre,
    this.recargoProductoPrecio,
    this.deliveryProductoPrecio,
  });

  factory Zona.fromJson(Map<String, dynamic> json) => Zona(
    idZona: json["id_zona"],
    zonaNombre: json["zona_nombre"],
    zonaPedidoMinimo: json["zona_pedido_minimo"],
    zonaImagen: json["zona_imagen"], 
    zonaDescripcion: json["zona_descripcion"],
    zonaTiempo: json["zona_tiempo"],
    recargoProductoNombre: json["recargo_producto_nombre"],
    deliveryProductoNombre: json["delivery_producto_nombre"],
    recargoProductoPrecio: json["recargo_producto_precio"],
    deliveryProductoPrecio: json["delivery_producto_precio"],
    zonaEstado: json["zona_estado"],
  );

  Map<String, dynamic> toJson() => {
    "id_zona": idZona,
    "zona_nombre": zonaNombre,
    "zona_pedido_minimo": zonaPedidoMinimo,
    "zona_imagen": zonaImagen, 
    "recargo_producto_nombre": recargoProductoNombre,
    "zona_descripcion": zonaDescripcion,
    "zona_tiempo": zonaTiempo,
    "delivery_producto_nombre": deliveryProductoNombre,
    "recargo_producto_precio": recargoProductoPrecio,
    "delivery_producto_precio": deliveryProductoPrecio,
    "zona_estado": zonaEstado,
  };
}