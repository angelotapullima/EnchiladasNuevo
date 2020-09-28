


class DeliveryRapido {
  String idDelivery;
  String estado;

  DeliveryRapido({
    this.idDelivery,
    this.estado,
  });

  factory DeliveryRapido.fromJson(Map<String, dynamic> json) => DeliveryRapido(
    idDelivery: json["idDelivery"],
    estado: json["estado"],
  );

  Map<String, dynamic> toJson() => {
    "idDelivery": idDelivery,
    "id_producto": estado,
  };
}