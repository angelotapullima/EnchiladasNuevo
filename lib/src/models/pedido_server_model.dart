 
import 'dart:convert';

PedidosServer pedidosFromJson(String str) => PedidosServer.fromJson(json.decode(str));

String pedidosToJson(PedidosServer data) => json.encode(data.toJson());

class PedidosServer {
    PedidosServer({
        this.result,
    });

    Result result;

    factory PedidosServer.fromJson(Map<String, dynamic> json) => PedidosServer(
        result: Result.fromJson(json["result"]),
    );

    Map<String, dynamic> toJson() => {
        "result": result.toJson(),
    };
}

class Result {
    Result({
        this.code,
        this.pedido,
    });

    int code;
    PedidoServer pedido;

    factory Result.fromJson(Map<String, dynamic> json) => Result(
        code: json["code"],
        pedido: PedidoServer.fromJson(json["pedido"]),
    );

    Map<String, dynamic> toJson() => {
        "code": code,
        "pedido": pedido.toJson(),
    };
}

class PedidoServer {
    PedidoServer({
        this.idPedido,
        this.pedidoTotal,
        this.pedidoDni,
        this.pedidoNombre,
        this.pedidoTelefono,
        this.pedidoDireccion,
        this.pedidoReferencia,
        this.pedidoFormaPago,
        this.pedidoMontoPago,
        this.pedidoVueltoPago,
        this.pedidoEstadoPago,
        this.pedidoEstado,
        this.pedidoCodigo,
        this.pedidoTipoComprobante,
        this.pedidoCodPersona,
        this.pedidoFecha,
        this.pedidoHora,
        this.productos,
        this.pedidoMontoFinal,
    });

    String idPedido;
    String pedidoTotal;
    String pedidoDni;
    String pedidoNombre;
    String pedidoTelefono;
    String pedidoDireccion;
    String pedidoReferencia;
    String pedidoFormaPago;
    String pedidoTipoComprobante;
    String pedidoCodPersona;
    String pedidoMontoPago;
    String pedidoVueltoPago;
    String pedidoEstadoPago;
    String  pedidoEstado;
    String pedidoCodigo;
    String pedidoFecha;
    String pedidoHora;
    String pedidoMontoFinal;
    List<ProductoServer> productos;

    factory PedidoServer.fromJson(Map<String, dynamic> json) => PedidoServer(
        idPedido: json["id_pedido"],
        pedidoTotal: json["pedido_total"],
        pedidoDni: json["pedido_dni"],
        pedidoNombre: json["pedido_nombre"],
        pedidoTelefono: json["pedido_telefono"],
        pedidoDireccion: json["pedido_direccion"],
        pedidoReferencia: json["pedido_referencia"],
        pedidoFormaPago: json["pedido_forma_pago"],
        pedidoTipoComprobante: json["pedido_tipo_comprobante"],
        pedidoCodPersona: json["pedido_cod_persona"],
        pedidoMontoPago: json["pedido_monto_pago"],
        pedidoVueltoPago: json["pedido_vuelto_pago"],
        pedidoEstadoPago: json["pedido_estado_pago"],
        pedidoEstado: json["pedido_estado"],
        pedidoCodigo: json["pedido_codigo"],
        pedidoFecha:  json["pedido_fecha"],
        pedidoHora: json["pedido_hora"],
        productos: List<ProductoServer>.from(json["productos"].map((x) => ProductoServer.fromJson(x))),
    ); 

    factory PedidoServer.fromJson2(Map<String, dynamic> json) => PedidoServer(
        idPedido: json["id_pedido"],
        pedidoTotal: json["pedido_total"],
        pedidoDni: json["pedido_dni"],
        pedidoNombre: json["pedido_nombre"],
        pedidoTelefono: json["pedido_telefono"],
        pedidoDireccion: json["pedido_direccion"],
        pedidoReferencia: json["pedido_referencia"],
        pedidoFormaPago: json["pedido_forma_pago"],
        pedidoTipoComprobante: json["pedido_tipo_comprobante"],
        pedidoCodPersona: json["pedido_cod_persona"],
        pedidoMontoPago: json["pedido_monto_pago"],
        pedidoVueltoPago: json["pedido_vuelto_pago"],
        pedidoEstadoPago: json["pedido_estado_pago"],
        pedidoEstado: json["pedido_estado"],
        pedidoCodigo: json["pedido_codigo"],
        pedidoFecha:  json["pedido_fecha"],
        pedidoHora: json["pedido_hora"],
        //productos: List<ProductoServer>.from(json["productos"].map((x) => ProductoServer.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "id_pedido": idPedido,
        "pedido_total": pedidoTotal,
        "pedido_dni": pedidoDni,
        "pedido_nombre": pedidoNombre,
        "pedido_telefono": pedidoTelefono,
        "pedido_direccion": pedidoDireccion,
        "pedido_referencia": pedidoReferencia,
        "pedido_forma_pago": pedidoFormaPago,
        "pedido_tipo_comprobante": pedidoTipoComprobante,
        "pedido_cod_persona": pedidoCodPersona,
        "pedido_monto_pago": pedidoMontoPago,
        "pedido_vuelto_pago": pedidoVueltoPago,
        "pedido_estado_pago": pedidoEstadoPago,
        "pedido_estado": pedidoEstado,
        "pedido_codigo": pedidoCodigo,
        "pedido_fecha":  pedidoFecha,
        "pedido_hora": pedidoHora,
        "productos": List<dynamic>.from(productos.map((x) => x.toJson())),
    };
}

class ProductoServer {
    ProductoServer({
        this.idDetallePedido,
        this.idPedido,
        this.idProducto,
        this.detalleCantidad,
        this.detallePrecioUnit,
        this.detallePrecioTotal,
        this.detalleObservacion,
        this.productoNombre,
    });

    String idDetallePedido;
    String idPedido;
    String idProducto;
    String detalleCantidad;
    String detallePrecioUnit;
    String detallePrecioTotal;
    String detalleObservacion;
    String productoNombre;

    factory ProductoServer.fromJson(Map<String, dynamic> json) => ProductoServer(
        idDetallePedido: json["id_detalle_pedido"],
        idPedido: json["id_pedido"],
        idProducto: json["id_producto"],
        detalleCantidad: json["detalle_cantidad"],
        detallePrecioUnit: json["detalle_precio_unit"],
        detallePrecioTotal: json["detalle_precio_total"],
        detalleObservacion: json["detalle_observacion"],
        productoNombre: json["producto_nombre"],
    );

    Map<String, dynamic> toJson() => {
        "id_detalle_pedido": idDetallePedido,
        "id_pedido": idPedido,
        "id_producto": idProducto,
        "detalle_cantidad": detalleCantidad,
        "detalle_precio_unit": detallePrecioUnit,
        "detalle_precio_total": detallePrecioTotal,
        "detalle_observacion": detalleObservacion,
        "producto_nombre": productoNombre,
    };
     
}
