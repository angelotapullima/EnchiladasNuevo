


class DeliveryRapido {
  String idDelivery;
  String idProducto;

  DeliveryRapido({
    this.idDelivery,
    this.idProducto,
  });

  factory DeliveryRapido.fromJson(Map<String, dynamic> json) => DeliveryRapido(
    idDelivery: json["id_delivery"],
    idProducto: json["id_producto"],
  );

  Map<String, dynamic> toJson() => {
    "id_delivery": idDelivery,
    "id_producto": idProducto,
  };
}