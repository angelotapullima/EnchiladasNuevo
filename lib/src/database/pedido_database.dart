import 'package:enchiladasapp/src/database/database_provider.dart';
import 'package:enchiladasapp/src/models/pedido_server_model.dart';

class PedidoDatabase {
  final dbprovider = DatabaseProvider.db;

  insertarPedido(PedidoServer pedido) async {
    try {
      final db = await dbprovider.database;

      final res = await db.rawInsert(
          "INSERT OR REPLACE INTO Pedido (id_pedido,pedido_total,pedido_dni,pedido_nombre,pedido_telefono,pedido_direccion,pedido_referencia,pedido_forma_pago,"
          "pedido_monto_pago,pedido_vuelto_pago,pedido_estado_pago,pedido_estado,pedido_codigo,pedido_fecha,pedido_hora) "
          "VALUES ('${pedido.idPedido}','${pedido.pedidoTotal}','${pedido.pedidoDni}','${pedido.pedidoNombre}','${pedido.pedidoTelefono}','${pedido.pedidoDireccion}',"
          "'${pedido.pedidoReferencia}','${pedido.pedidoFormaPago}','${pedido.pedidoMontoPago}','${pedido.pedidoVueltoPago}',${pedido.pedidoEstadoPago},"
          "${pedido.pedidoEstado},'${pedido.pedidoCodigo}','${pedido.pedidoFecha}','${pedido.pedidoHora}'"
          ")");
      return res;
    } catch (exception) {
      print(exception);
    }
  }

  Future<List<PedidoServer>> obtenerTodosLosPedidosPendientes() async {
    final db = await dbprovider.database;
    final res = await db.rawQuery("SELECT * FROM Pedido where pedido_estado in (0,1,2,3)  ");

    List<PedidoServer> list = res.isNotEmpty
        ? res.map((c) => PedidoServer.fromJson2(c)).toList()
        : [];

    return list;
  }
  Future<List<PedidoServer>> obtenerTodosLosPedidosPasados() async {
    final db = await dbprovider.database;
    final res = await db.rawQuery("SELECT * FROM Pedido where pedido_estado = 4 and pedido_estado = 5");

    List<PedidoServer> list = res.isNotEmpty
        ? res.map((c) => PedidoServer.fromJson2(c)).toList()
        : [];

    return list;
  }

  Future<List<PedidoServer>> obtenerPedidoPorId(String id) async {
    try {
      final db = await dbprovider.database;
      final res =
          await db.rawQuery("SELECT * FROM Pedido where id_pedido = '$id'");

      List<PedidoServer> list = res.isNotEmpty
          ? res.map((c) => PedidoServer.fromJson2(c)).toList()
          : [];

      return list;
    } catch (exception) {
      print(exception);
      return [];
    }
  }

  

  insertarDetallePedido(ProductoServer productoDetalle) async {
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
  Future<List<ProductoServer>> obtenerDetallePedidoPorIdPedido(String id) async {
    final db = await dbprovider.database;
    final res =
        await db.rawQuery("SELECT * FROM DetallePedido where id_pedido = $id");

    List<ProductoServer> list = res.isNotEmpty
        ? res.map((c) => ProductoServer.fromJson(c)).toList()
        : [];

    return list;
  }


  /* 

  //consulta para obtener la cantidad y hacer el contador
  Future<List<ProductoServer>> cantidadOrdenProducto() async {
    final db = await dbprovider.database;
    final res = await db.rawQuery("SELECT * FROM OrdenProducto ");

    List<ProductoServer> list = res.isNotEmpty
        ? res.map((c) => ProductoServer.fromJson(c)).toList()
        : [];

    return list;
  }

  Future<List<ProductoServer>> obtenerOrdenProductoPorIdPedido(
      String id) async {
    final db = await dbprovider.database;
    final res =
        await db.rawQuery("SELECT * FROM OrdenProducto where id_pedido = $id");

    List<ProductoServer> list = res.isNotEmpty
        ? res.map((c) => ProductoServer.fromJson(c)).toList()
        : [];

    return list;
  }
} */
}
