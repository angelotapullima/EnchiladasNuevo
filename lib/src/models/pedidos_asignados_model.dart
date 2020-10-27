
import 'dart:convert';

PedidosAsignados pedidosAsignadosFromJson(String str) => PedidosAsignados.fromJson(json.decode(str));

String pedidosAsignadosToJson(PedidosAsignados data) => json.encode(data.toJson());

class PedidosAsignados {
    PedidosAsignados({
        this.result,
    });

    Result result;

    factory PedidosAsignados.fromJson(Map<String, dynamic> json) => PedidosAsignados(
        result: Result.fromJson(json["result"]),
    );

    Map<String, dynamic> toJson() => {
        "result": result.toJson(),
    };
}

class Result {
    Result({
        this.code,
        this.message,
        this.data,
    });

    int code;
    String message;
    List<PedidoAsignados> data;

    factory Result.fromJson(Map<String, dynamic> json) => Result(
        code: json["code"],
        message: json["message"],
        data: List<PedidoAsignados>.from(json["data"].map((x) => PedidoAsignados.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class PedidoAsignados {
    PedidoAsignados({
        this.idPedido,
        this.idEntrega,
        this.pedidoTipoComprobante,
        this.pedidoCodPersona,
        this.pedidoFecha,
        this.pedidoHora,
        this.pedidoTotal,
        this.pedidoTelefono,
        this.pedidoDni,
        this.pedidoNombre,
        this.pedidoDireccion,
        this.pedidoReferencia,
        this.pedidoFormaPago,
        this.pedidoMontoPago,
        this.pedidoVueltoPago,
        this.pedidoEstadoPago,
        this.pedidoEstado,
        this.pedidoCodigo,
        this.productos,
    });

    String idPedido;
    String idEntrega;
    String pedidoTipoComprobante;
    String pedidoCodPersona;
    String pedidoFecha;
    String pedidoHora;
    String pedidoTotal;
    String pedidoTelefono;
    String pedidoDni;
    String pedidoNombre;
    String pedidoDireccion;
    String pedidoReferencia;
    String pedidoFormaPago;
    String pedidoMontoPago;
    String pedidoVueltoPago;
    String pedidoEstadoPago;
    String pedidoEstado;
    String pedidoCodigo;
    List<DetallePedidoAsignados> productos;

    factory PedidoAsignados.fromJson(Map<String, dynamic> json) => PedidoAsignados(
        idPedido: json["id_pedido"],
        idEntrega: json["id_entrega"],
        pedidoTipoComprobante: json["pedido_tipo_comprobante"],
        pedidoCodPersona: json["pedido_cod_persona"],
        pedidoFecha: json["pedido_fecha"],
        pedidoHora: json["pedido_hora"],
        pedidoTotal: json["pedido_total"],
        pedidoTelefono: json["pedido_telefono"],
        pedidoDni: json["pedido_dni"],
        pedidoNombre: json["pedido_nombre"],
        pedidoDireccion: json["pedido_direccion"],
        pedidoReferencia: json["pedido_referencia"],
        pedidoFormaPago: json["pedido_forma_pago"],
        pedidoMontoPago: json["pedido_monto_pago"],
        pedidoVueltoPago: json["pedido_vuelto_pago"],
        pedidoEstadoPago: json["pedido_estado_pago"],
        pedidoEstado: json["pedido_estado"],
        pedidoCodigo: json["pedido_codigo"],
        //productos: List<DetallePedidoAsignados>.from(json["productos"].map((x) => DetallePedidoAsignados.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "id_pedido": idPedido,
        "id_entrega": idEntrega,
        "pedido_tipo_comprobante": pedidoTipoComprobante,
        "pedido_cod_persona": pedidoCodPersona,
        "pedido_fecha": pedidoFecha,
        "pedido_hora": pedidoHora,
        "pedido_total": pedidoTotal,
        "pedido_telefono": pedidoTelefono,
        "pedido_dni": pedidoDni,
        "pedido_nombre": pedidoNombre,
        "pedido_direccion": pedidoDireccion,
        "pedido_referencia": pedidoReferencia,
        "pedido_forma_pago": pedidoFormaPago,
        "pedido_monto_pago": pedidoMontoPago,
        "pedido_vuelto_pago": pedidoVueltoPago,
        "pedido_estado_pago": pedidoEstadoPago,
        "pedido_estado": pedidoEstado,
        "pedido_codigo": pedidoCodigo,
        //"productos": List<dynamic>.from(productos.map((x) => x.toJson())),
    };
}

class DetallePedidoAsignados {
    DetallePedidoAsignados({
        this.idDetallePedido,
        this.idPedido,
        this.idProducto,
        this.productoNombre,
        this.detalleCantidad,
        this.detallePrecioUnit,
        this.detallePrecioTotal,
        this.detalleObservacion,
    });

    String idDetallePedido;
    String idPedido;
    String idProducto;
    String productoNombre;
    String detalleCantidad;
    String detallePrecioUnit;
    String detallePrecioTotal;
    String detalleObservacion;

    factory DetallePedidoAsignados.fromJson(Map<String, dynamic> json) => DetallePedidoAsignados(
        idDetallePedido: json["id_detalle_pedido"],
        idPedido: json["id_pedido"],
        idProducto: json["id_producto"],
        productoNombre: json["producto_nombre"],
        detalleCantidad: json["detalle_cantidad"],
        detallePrecioUnit: json["detalle_precio_unit"],
        detallePrecioTotal: json["detalle_precio_total"],
        detalleObservacion: json["detalle_observacion"],
    );

    Map<String, dynamic> toJson() => {
        "id_detalle_pedido": idDetallePedido,
        "id_pedido": idPedido,
        "id_producto": idProducto,
        "producto_nombre": productoNombre,
        "detalle_cantidad": detalleCantidad,
        "detalle_precio_unit": detallePrecioUnit,
        "detalle_precio_total": detallePrecioTotal,
        "detalle_observacion": detalleObservacion,
    };
}
