import 'dart:convert';
import 'package:enchiladasapp/src/database/pedido_asignado_database.dart';
import 'package:enchiladasapp/src/database/usuario_database.dart';
import 'package:enchiladasapp/src/models/pedidos_asignados_model.dart';
import 'package:enchiladasapp/src/models/user.dart';
import 'package:enchiladasapp/src/utils/utilidades.dart' as utils;
import 'package:fluttertoast/fluttertoast.dart'; 

import 'package:http/http.dart' as http;

class PedidosAsignadosApi {
  final String _url = 'https://delivery.lacasadelasenchiladas.pe';
  final userDatabase = UsuarioDatabase();
  final pedidoAsignadoDatabase=PedidoAsignadoDatabase();

  Future<List<PedidoAsignados>> obtenerPedidosAsignados() async {
    try {
      print('empezamos a pedir');
      final url = '$_url/api/entrega/pedidos_asignados';
      final List<User> user = await userDatabase.obtenerUsUario();

      final pedidosAsignados = List<PedidoAsignados>();
      final productosAsignadosList = List<DetallePedidoAsignados>();

      final response = await http.post(url, body: {
        'app': 'true',
        'tn': user[0].token,
        'id_user': user[0].cU,
      });
      final decodedData = json.decode(response.body);

      if (decodedData['result']['code'] == 1) {
        print(' tamaño de lista ${decodedData['result']['data'].length}');
        var tipoAtencion;
        if (decodedData['result']['atendiendo_pedido'] == 1) {
          tipoAtencion = decodedData['result']['pedido_en_entrega'];
        } else {
          tipoAtencion = decodedData['result']['data'];
        }
        for (int i = 0; i < tipoAtencion.length; i++) {
          PedidoAsignados pediditos = new PedidoAsignados();

          pediditos.idPedido = tipoAtencion[i]['id_pedido'];
          pediditos.idEntrega = tipoAtencion[i]['id_entrega'];
          pediditos.pedidoTipoComprobante =tipoAtencion[i]['pedido_tipo_comprobante'];
          pediditos.pedidoCodPersona = tipoAtencion[i]['pedido_cod_persona'];
          pediditos.pedidoFecha = tipoAtencion[i]['pedido_fecha'];
          pediditos.pedidoHora = tipoAtencion[i]['pedido_hora'];
          pediditos.pedidoTotal = tipoAtencion[i]['pedido_total'];
          pediditos.pedidoTelefono = tipoAtencion[i]['pedido_telefono'];
          pediditos.pedidoDni = tipoAtencion[i]['pedido_dni'];
          pediditos.pedidoNombre = tipoAtencion[i]['pedido_nombre'];
          pediditos.pedidoDireccion = tipoAtencion[i]['pedido_direccion'];
          pediditos.pedidoReferencia = tipoAtencion[i]['pedido_referencia'];
          pediditos.pedidoFormaPago = tipoAtencion[i]['pedido_forma_pago'];
          pediditos.pedidoMontoPago = tipoAtencion[i]['pedido_monto_pago'];
          pediditos.pedidoVueltoPago = tipoAtencion[i]['pedido_vuelto_pago'];
          pediditos.pedidoEstadoPago = tipoAtencion[i]['pedido_estado_pago'];
          pediditos.pedidoEstado = tipoAtencion[i]['pedido_estado'];
          pediditos.pedidoCodigo = tipoAtencion[i]['pedido_codigo'];
          
          await pedidoAsignadoDatabase.insertarPedido(pediditos);

          for (int x = 0; x < tipoAtencion[i]['productos'].length; x++) {
            DetallePedidoAsignados productAsignado = new DetallePedidoAsignados();

            productAsignado.idDetallePedido =tipoAtencion[i]['productos'][x]['id_detalle_pedido'];
            productAsignado.idPedido =tipoAtencion[i]['productos'][x]['id_pedido'];
            productAsignado.idProducto =tipoAtencion[i]['productos'][x]['id_producto'];
            productAsignado.productoNombre =tipoAtencion[i]['productos'][x]['producto_nombre'];
            productAsignado.detalleCantidad =tipoAtencion[i]['productos'][x]['detalle_cantidad'];
            productAsignado.detallePrecioUnit = tipoAtencion[i]['productos'][x]['detalle_precio_unit'];
            productAsignado.detallePrecioTotal =tipoAtencion[i]['productos'][x]['detalle_precio_total'];
            productAsignado.detalleObservacion =tipoAtencion[i]['productos'][x]['detalle_observacion'];

            await pedidoAsignadoDatabase.insertarDetallePedido(productAsignado);
            productosAsignadosList.add(productAsignado);
          }
          pediditos.productos = productosAsignadosList;

          pedidosAsignados.add(pediditos);
        }
        print('tenermos ${pedidosAsignados.length} pedidos asignador');
        return pedidosAsignados;
      } else {
        return [];
      }
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      utils.showToast(  "Problemas con la conexión a internet",2,ToastGravity.TOP);
      return [];
    }
  }
}
