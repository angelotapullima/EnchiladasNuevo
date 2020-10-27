import 'package:enchiladasapp/src/database/database_provider.dart';
import 'package:enchiladasapp/src/models/pedidos_asignados_model.dart';

class PedidoAsignadoDatabase {
  final dbprovider = DatabaseProvider.db;

  insertarPedido(PedidoAsignados pedido) async {
    try {
      final db = await dbprovider.database;

      final res = await db.rawInsert("INSERT OR REPLACE INTO PedidoAsignado ("
          "id_pedido,"
          "id_entrega,"
          "pedido_tipo_comprobante,"
          "pedido_cod_persona,"
          "pedido_fecha,"
          "pedido_hora,"
          "pedido_total,"
          "pedido_telefono,"
          "pedido_dni,"
          "pedido_nombre,"
          "pedido_direccion,"
          "pedido_referencia,"
          "pedido_forma_pago,"
          "pedido_monto_pago,"
          "pedido_vuelto_pago,"
          "pedido_estado_pago,"
          "pedido_estado,"
          "pedido_codigo ) "
          "VALUES ('${pedido.idPedido}','${pedido.idEntrega}','${pedido.pedidoTipoComprobante}','${pedido.pedidoCodPersona}',"
          "'${pedido.pedidoFecha}','${pedido.pedidoHora}','${pedido.pedidoTotal}','${pedido.pedidoTelefono}',"
          "'${pedido.pedidoDni}','${pedido.pedidoNombre}','${pedido.pedidoDireccion}','${pedido.pedidoReferencia}',"
          "'${pedido.pedidoFormaPago}','${pedido.pedidoMontoPago}','${pedido.pedidoVueltoPago}','${pedido.pedidoEstadoPago}',"
          "'${pedido.pedidoEstado}','${pedido.pedidoCodigo}'"
          ")");
      return res;
    } catch (exception) {
      print(exception);
    }
  }

  Future<List<PedidoAsignados>> obtenerPedidoPorID(String id) async {
    final db = await dbprovider.database;
    final res = await db
        .rawQuery("SELECT * FROM PedidoAsignado where id_pedido='$id'  ");

    List<PedidoAsignados> list = res.isNotEmpty
        ? res.map((c) => PedidoAsignados.fromJson(c)).toList()
        : [];

    return list;
  }

  insertarDetallePedido(DetallePedidoAsignados productoDetalle) async {
    try {
      final db = await dbprovider.database;

      final res = await db.rawInsert(
          "INSERT OR REPLACE INTO DetallePedido (id_detalle_pedido,id_pedido,id_producto,detalle_cantidad,detalle_precio_unit,"
          "detalle_precio_total,detalle_observacion,producto_nombre) "
          "VALUES ('${productoDetalle.idDetallePedido}','${productoDetalle.idPedido}','${productoDetalle.idProducto}','${productoDetalle.detalleCantidad}',"
          "'${productoDetalle.detallePrecioUnit}','${productoDetalle.detallePrecioTotal}','${productoDetalle.detalleObservacion}','${productoDetalle.productoNombre}'"          
          ")");

      return res;
    } catch (exception) {
      print(exception);
    }
  }
  Future<List<DetallePedidoAsignados>> obtenerDetallePedidoPorIdPedido(String id) async {
    final db = await dbprovider.database;
    final res =
        await db.rawQuery("SELECT * FROM DetallePedido where id_pedido = $id");

    List<DetallePedidoAsignados> list = res.isNotEmpty
        ? res.map((c) => DetallePedidoAsignados.fromJson(c)).toList()
        : [];

    return list;
  }
}
