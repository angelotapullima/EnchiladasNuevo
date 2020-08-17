import 'dart:convert';

import 'package:enchiladasapp/src/database/carrito_database.dart';
import 'package:enchiladasapp/src/database/direccion_database.dart';
import 'package:enchiladasapp/src/database/usuario_database.dart';
import 'package:enchiladasapp/src/database/pedido_database.dart';
import 'package:enchiladasapp/src/models/carrito_model.dart';
import 'package:enchiladasapp/src/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:enchiladasapp/src/models/pedido_server_model.dart';
import 'package:enchiladasapp/src/utils/utilidades.dart' as utils;

class OrdenesApi {
  final String _url = 'https://delivery.lacasadelasenchiladas.pe';

  final productoDatabase = CarritoDatabase();
  final pedidoDatabase = PedidoDatabase();
  final userDatabase = UsuarioDatabase();
  final direccionDatabase = DireccionDatabase();

  Future<int> enviarpedido(PedidoServer pedido) async {
    try {
      final url = '$_url/api/pedido/insertar_pedido';

      final List<Carrito> productos = await productoDatabase.obtenerCarritoDB();
      final List<User> user = await userDatabase.obtenerUsUario();
      final direccion = await direccionDatabase.obtenerdireccion();

      int estadoDelivery = 0;
      String productitos = ""; // id_producto.cantidad.referencia
      for (int i = 0; i < productos.length; i++) {
        if (productos[i].productoTipo == '1') {
          estadoDelivery = 1;
        }
      }

      if (estadoDelivery == 1) {
        for (int x = 0; x < productos.length; x++) {
          if (productos[x].productoTipo == '1') {
            estadoDelivery = 1;
          } else {
            productitos +=
                "${productos[x].idProducto}.${productos[x].productoCantidad}.${productos[x].productoObservacion}";

            if (x != productos.length - 2) {
              productitos += "|";
            }
          }
        }
      } else {
        for (int x = 0; x < productos.length; x++) {
          
            productitos +=
                "${productos[x].idProducto}.${productos[x].productoCantidad}.${productos[x].productoObservacion}";

            if (x != productos.length - 1) {
              productitos += "|";
            }
          
        }
      }

      print('productitos $productitos');
      final response = await http.post(url, body: {
        
        'app': 'true',
        'tn': user[0].token,
        'id_user': user[0].cU,
        'pedido_tipo_comprobante': pedido.pedidoTipoComprobante,
        'pedido_cod_persona': pedido.pedidoCodPersona,
        'pedido_total': pedido.pedidoMontoFinal,
        'pedido_telefono': user[0].telefono,
        'pedido_dni': '11111111',
        'pedido_nombre': user[0].personName,
        'id_zona': user[0].idZona,
        'pedido_direccion': direccion[0].direccion,
        'pedido_x': direccion[0].latitud,
        'pedido_y': direccion[0].longitud,
        'pedido_referencia': direccion[0].referencia,
        'pedido_forma_pago': pedido.pedidoFormaPago,
        'pedido_monto_pago': pedido.pedidoMontoPago,
        'pedido_vuelto_pago': pedido.pedidoVueltoPago,
        'productos': productitos,
        'pedido_rapido': estadoDelivery.toString(),
        'pedido_estado_pago': pedido.pedidoEstadoPago.toString()
      });
      

      print('Response status: $response');
      final decodedData = json.decode(response.body);
      print(response.body);
      utils.showToast(response.body, 2);

      if (decodedData['result']['code'] == 1) {
        PedidoServer pedidosServer =
            PedidoServer.fromJson2(decodedData['result']['pedido']);
        final pedidoInsertado =
            await pedidoDatabase.insertarPedido(pedidosServer);

        print(pedidoInsertado);

        for (int i = 0;
            i < decodedData['result']['pedido']['productos'].length;
            i++) {
          ProductoServer productoServer = new ProductoServer();

          productoServer.idDetallePedido = decodedData['result']['pedido']
              ['productos'][i]['id_detalle_pedido'];
          productoServer.idPedido =
              decodedData['result']['pedido']['productos'][i]['id_pedido'];
          productoServer.idProducto =
              decodedData['result']['pedido']['productos'][i]['id_producto'];
          productoServer.detalleCantidad = decodedData['result']['pedido']
              ['productos'][i]['detalle_cantidad'];
          productoServer.detallePrecioUnit = decodedData['result']['pedido']
              ['productos'][i]['detalle_precio_unit'];
          productoServer.detallePrecioTotal = decodedData['result']['pedido']
              ['productos'][i]['detalle_precio_total'];
          productoServer.detalleObservacion = decodedData['result']['pedido']
              ['productos'][i]['detalle_observacion'];
          productoServer.productoNombre = decodedData['result']['pedido']
              ['productos'][i]['producto_nombre'];

          await pedidoDatabase.insertarDetallePedido(productoServer);
        }

        //list.add(pedidosServer);

        return 1;
      } else if (decodedData['result']['code'] == 8) {
        final carritoDatabase = CarritoDatabase();
        for (int i = 0;
            i < decodedData['result']['pedido']['productos'].length;
            i++) {
          Carrito carrito = new Carrito();
          carrito.idProducto = int.parse(
              decodedData['result']['pedido']['productos'][i]['id_producto']);
          carrito.productoNombre = decodedData['result']['pedido']['productos']
              [i]['producto_nombre'];
          carrito.productoCantidad = decodedData['result']['pedido']
              ['productos'][i]['detalle_cantidad'];
          carrito.productoPrecio = decodedData['result']['pedido']['productos']
              [i]['detalle_precio_unit'];
          carrito.productoObservacion = decodedData['result']['pedido']
              ['productos'][i]['detalle_observacion'];
          carrito.productoTipo = '0';

          await carritoDatabase.insertarCarritoDb(carrito);
        }
        return 8;
      } else {
        return 2;
      }
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      utils.showToast("Problemas con la conexión a internet", 2);
      return 2;
    }
  }

  Future<List<PedidoServer>> obtenerhistorialDePedidos() async {
    try {
      final list = List<PedidoServer>();

      final url = '$_url/api/pedido/historial_pedidos';
      final List<User> user = await userDatabase.obtenerUsUario();
      print('token ${user[0].token}');
      print('CU ${user[0].cU}');

      final response = await http.post(url, body: {
        'app': 'true',
        'tn': user[0].token,
        'id_user': user[0].cU,
      });

      final decodedData = json.decode(response.body);

      if (decodedData['result']['code'] == 1) {
        var cantidadPedidos = List<dynamic>();
        cantidadPedidos = decodedData['result']['data'];
        print('cantidad de ordenes ${cantidadPedidos.length}');

        for (int x = 0; x < cantidadPedidos.length; x++) {
          //obtener el pedido si existe para actualizarlo o crear uno nuevo

          PedidoServer pedidosServer =
              PedidoServer.fromJson2(cantidadPedidos[x]);
          final pedidoInsertado =
              await pedidoDatabase.insertarPedido(pedidosServer);

          print(pedidoInsertado);

          for (int i = 0; i < cantidadPedidos[x]['productos'].length; i++) {
            ProductoServer productoServer = new ProductoServer();

            productoServer.idDetallePedido =
                cantidadPedidos[x]['productos'][i]['id_detalle_pedido'];
            productoServer.idPedido =
                cantidadPedidos[x]['productos'][i]['id_pedido'];
            productoServer.idProducto =
                cantidadPedidos[x]['productos'][i]['id_producto'];
            productoServer.detalleCantidad =
                cantidadPedidos[x]['productos'][i]['detalle_cantidad'];
            productoServer.detallePrecioUnit =
                cantidadPedidos[x]['productos'][i]['detalle_precio_unit'];
            productoServer.detallePrecioTotal =
                cantidadPedidos[x]['productos'][i]['detalle_precio_total'];
            productoServer.detalleObservacion =
                cantidadPedidos[x]['productos'][i]['detalle_observacion'];
            productoServer.productoNombre =
                cantidadPedidos[x]['productos'][i]['producto_nombre'];

            await pedidoDatabase.insertarDetallePedido(productoServer);
          }

          list.add(pedidosServer);
        }
        return list;
      } else {
        return [];
      }
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      utils.showToast("Problemas con la conexión a internet", 2);
      return [];
    }
  }
}
