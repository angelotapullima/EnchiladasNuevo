import 'dart:convert';

import 'package:enchiladasapp/src/models/tracking_model.dart';
import 'package:enchiladasapp/src/widgets/preferencias_usuario.dart'; 
import 'package:http/http.dart' as http;
import 'package:enchiladasapp/src/utils/utilidades.dart' as utils;

class TrackingApi {
  final String _url = 'https://delivery.lacasadelasenchiladas.pe';
  final prefs = new Preferences();
  Future<int> iniciarEntrega(String idEntrega) async {
    try {
      final url = '$_url/api/entrega/iniciar_entrega';

      final resp = await http.post(url, body: {
        'tn': prefs.token,
        'id_user': prefs.idUser,
        'app': 'true', 
        'id_entrega': idEntrega
      });
      final decodedData = json.decode(resp.body);
      final code = decodedData['success'];
      if (code == 1 || code ==8) {
        return 1;
      } else {
        return 0;
      }
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      utils.showToast(  "Problemas con la conexión a internet",2);
      return 0;
    }
  }

  Future<int> finalizarEntrega(String idEntrega) async {
    try {
      final url = '$_url/api/entrega/finalizar_entrega';

      final resp = await http.post(url, body: {
        'tn': prefs.token,
        'id_user': prefs.idUser,
        'app': 'true',
        'id_entrega': idEntrega
      });
      final decodedData = json.decode(resp.body);
      final code = decodedData['success'];
      if (code == 1 || code ==8) {
        return 1;
      } else {
        return 0;
      }
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      utils.showToast(  "Problemas con la conexión a internet",2);
      return 0;
    }
  }

  Future<List<TrackingData>> trackingRepartidor( String idPedido) async {
    try {
      final url = '$_url/api/pedido/tracking_pedido';
      final list = List<TrackingData>();

      final resp = await http.post(url,
          body: {'tn': prefs.token, 'app': 'true', 'id_pedido': idPedido});
      final decodedData = json.decode(resp.body);
      final code = decodedData['result']['code'];

      if (code == 1) {
        var data = decodedData['result']['data'];

        TrackingData trackingData =   TrackingData.fromJson(data);
        /* TrackingData trackingData = new TrackingData();
        trackingData.idPedido = data['id_pedido'];
        trackingData.idUser = data['id_user'];
        trackingData.pedidoTipoComprobante = data['pedido_tipo_comprobante'];
        trackingData.pedidoCodPersona = data['pedido_cod_persona'];
        trackingData.pedidoFecha = data['pedido_fecha'];
        trackingData.pedidoHora = data['pedido_hora'];
        trackingData.pedidoTotal = data['pedido_total'];
        trackingData.pedidoTelefono = data['pedido_telefono'];
        trackingData.pedidoDni = data['pedido_dni'];
        trackingData.pedidoX = data['pedido_x'];
        trackingData.pedidoY = data['pedido_y'];
        trackingData.pedidoNombre = data['pedido_nombre'];
        trackingData.pedidoDireccion = data['pedido_direccion'];
        trackingData.pedidoReferencia = data['pedido_referencia'];
        trackingData.pedidoFormaPago = data['pedido_forma_pago'];
        trackingData.pedidoMontoPago = data['pedido_monto_pago'];
        trackingData.pedidoVueltoPago = data['pedido_vuelto_pago'];
        trackingData.pedidoEstadoPago = data['pedido_estado_pago'];
        trackingData.pedidoEstado = data['pedido_estado'];
        trackingData.pedidoCodigo = data['pedido_codigo']; 
        trackingData.idEntrega = data['id_entrega'];
        trackingData.idRepartidor = data['id_repartidor'];
        trackingData.idVehiculo = data['id_vehiculo'];
        trackingData.entregaFechaInicio = data['entrega_fecha_inicio'];
        trackingData.entregaHoraInicio = data['entrega_hora_inicio'];
        trackingData.entregaFechaFin = data['entrega_fecha_fin'];
        trackingData.entregaHoraFin = data['entrega_hora_fin'];
        trackingData.idTracking = data['id_tracking'];
        trackingData.trackingX = data['tracking_x'];
        trackingData.trackingY = data['tracking_y'];
        trackingData.trackingFecha = data['tracking_fecha'];
        trackingData.trackingHora = data['tracking_hora'];
        trackingData.idPerson = data['id_person'];
        trackingData.idRel = data['id_rel'];
        trackingData.idRole = data['id_role'];
 */
        list.add(trackingData);
        return list;
      } else {
        return [];
      }
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      utils.showToast(  "Problemas con la conexión a internet",2);
      return [];
    }
  }
}
