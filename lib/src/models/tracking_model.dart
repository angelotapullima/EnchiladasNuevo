// To parse this JSON data, do
//
//     final tracking = trackingFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

Tracking trackingFromJson(String str) => Tracking.fromJson(json.decode(str));

String trackingToJson(Tracking data) => json.encode(data.toJson());

class Tracking {
    Tracking({
        @required this.result,
    });

    Result result;

    factory Tracking.fromJson(Map<String, dynamic> json) => Tracking(
        result: Result.fromJson(json["result"]),
    );

    Map<String, dynamic> toJson() => {
        "result": result.toJson(),
    };
}

class Result {
    Result({
        @required this.code,
        @required this.data,
    });

    int code;
    TrackingData data;

    factory Result.fromJson(Map<String, dynamic> json) => Result(
        code: json["code"],
        data: TrackingData.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "code": code,
        "data": data.toJson(),
    };
}

class TrackingData {
    TrackingData({
         this.idPedido,
         this.idUser,
         this.pedidoTipoComprobante,
         this.pedidoCodPersona,
         this.pedidoFecha,
         this.pedidoHora,
         this.pedidoTotal,
         this.pedidoTelefono,
         this.pedidoDni,
         this.pedidoX,
         this.pedidoY,
         this.pedidoNombre,
         this.pedidoDireccion,
         this.pedidoReferencia,
         this.pedidoFormaPago,
         this.pedidoMontoPago,
         this.pedidoVueltoPago,
         this.pedidoEstadoPago,
         this.pedidoEstado,
         this.pedidoCodigo,
         this.idEntrega,
         this.idRepartidor,
         this.idVehiculo,
         this.entregaFechaInicio,
         this.entregaHoraInicio,
         this.entregaFechaFin,
         this.entregaHoraFin,
         this.idTracking,
         this.trackingX,
         this.trackingY,
         this.trackingFecha,
         this.trackingHora,
         this.idPerson,
         this.idRel,
         this.idRole,
         this.userNickname,
         this.userEmail,
         this.userImage,
         this.personName,
    });

    String idPedido;
    String idUser;
    String idZona;
    String pedidoTipoComprobante;
    String pedidoCodPersona;
    String pedidoFecha;
    String pedidoHora;
    String pedidoTotal;
    String pedidoTelefono;
    String pedidoDni;
    String pedidoX;
    String pedidoY;
    String pedidoNombre;
    String pedidoDireccion;
    String pedidoReferencia;
    String pedidoFormaPago;
    String pedidoMontoPago;
    String pedidoVueltoPago;
    String pedidoEstadoPago;
    String pedidoEstado;
    String pedidoCodigo;
    String idEntrega;
    String idRepartidor;
    String idVehiculo;
    String entregaFechaInicio;
    String entregaHoraInicio;
    String entregaFechaFin;
    String entregaHoraFin;
    String idTracking;
    String trackingX;
    String trackingY;
    String trackingFecha;
    String trackingHora;
    String idPerson;
    String idRel;
    String idRole;
    String userNickname;
    String userEmail;
    String userImage;
    String personName;


   



    factory TrackingData.fromJson(Map<String, dynamic> json) => TrackingData(
        idPedido: json["id_pedido"],
        idUser: json["id_user"],
        pedidoTipoComprobante: json["pedido_tipo_comprobante"],
        pedidoCodPersona: json["pedido_cod_persona"],
        pedidoFecha: json["pedido_fecha"],
        pedidoHora: json["pedido_hora"],
        pedidoTotal: json["pedido_total"],
        pedidoTelefono: json["pedido_telefono"],
        pedidoDni: json["pedido_dni"],
        pedidoX: json["pedido_x"],
        pedidoY: json["pedido_y"],
        pedidoNombre: json["pedido_nombre"],
        pedidoDireccion: json["pedido_direccion"],
        pedidoReferencia: json["pedido_referencia"],
        pedidoFormaPago: json["pedido_forma_pago"],
        pedidoMontoPago: json["pedido_monto_pago"],
        pedidoVueltoPago: json["pedido_vuelto_pago"],
        pedidoEstadoPago: json["pedido_estado_pago"],
        pedidoEstado: json["pedido_estado"],
        pedidoCodigo: json["pedido_codigo"],
        idEntrega: json["id_entrega"],
        idRepartidor: json["id_repartidor"],
        idVehiculo: json["id_vehiculo"],
        entregaFechaInicio: json["entrega_fecha_inicio"],
        entregaHoraInicio: json["entrega_hora_inicio"],
        entregaFechaFin: json["entrega_fecha_fin"],
        entregaHoraFin: json["entrega_hora_fin"],
        idTracking: json["id_tracking"],
        trackingX: json["tracking_x"],
        trackingY: json["tracking_y"],
        trackingFecha:json["tracking_fecha"],
        trackingHora: json["tracking_hora"],
        idPerson: json["id_person"],
        idRel: json["id_rel"],
        idRole: json["id_role"],
        userNickname: json["user_nickname"],
        userEmail: json["user_email"],
        userImage: json["user_image"],
        personName: json["person_name"],
    );

    Map<String, dynamic> toJson() => {
        "id_pedido": idPedido,
        "id_user": idUser,
        "pedido_tipo_comprobante": pedidoTipoComprobante,
        "pedido_cod_persona": pedidoCodPersona,
        "pedido_fecha": pedidoFecha,
        "pedido_hora": pedidoHora,
        "pedido_total": pedidoTotal,
        "pedido_telefono": pedidoTelefono,
        "pedido_dni": pedidoDni,
        "pedido_x": pedidoX,
        "pedido_y": pedidoY,
        "pedido_nombre": pedidoNombre,
        "pedido_direccion": pedidoDireccion,
        "pedido_referencia": pedidoReferencia,
        "pedido_forma_pago": pedidoFormaPago,
        "pedido_monto_pago": pedidoMontoPago,
        "pedido_vuelto_pago": pedidoVueltoPago,
        "pedido_estado_pago": pedidoEstadoPago,
        "pedido_estado": pedidoEstado,
        "pedido_codigo": pedidoCodigo,
        "id_entrega": idEntrega,
        "id_repartidor": idRepartidor,
        "id_vehiculo": idVehiculo,
        "entrega_fecha_inicio": entregaFechaInicio,
        "entrega_hora_inicio": entregaHoraInicio,
        "entrega_fecha_fin": entregaFechaFin,
        "entrega_hora_fin": entregaHoraFin,
        "id_tracking": idTracking,
        "tracking_x": trackingX,
        "tracking_y": trackingY,
        "tracking_fecha": trackingFecha,
        "tracking_hora": trackingHora,
        "id_person": idPerson,
        "id_rel": idRel,
        "id_role": idRole,
        "user_nickname": userNickname,
        "userEmail": userEmail,
        "user_image": userImage,
        "person_name": personName,
    };
}
