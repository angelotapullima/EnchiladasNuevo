import 'dart:convert';

import 'package:enchiladasapp/src/models/tracking_model.dart';
import 'package:enchiladasapp/src/utils/preferencias_usuario.dart';
import 'package:http/http.dart' as http;

class TrackingApi {
  final String _url = 'https://delivery.lacasadelasenchiladas.pe';
  final prefs = new Preferences();
  /* Future<int> iniciarEntrega(String idEntrega) async {
    try {
      final url = '$_url/api/entrega/iniciar_entrega';

      final resp = await http.post(url, body: {
        'tn': prefs.token,
        'id_user': prefs.idUser,
        'app': 'true', 
        'id_entrega': idEntrega,
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

      utils.showToast(  "Problemas con la conexión a internet",2,ToastGravity.TOP);
      return 0;
    }
  }

  Future<int> finalizarEntrega(String idEntrega,String comentarios) async {
    try {
      final url = '$_url/api/entrega/finalizar_entrega';

      final resp = await http.post(url, body: {
        'tn': prefs.token,
        'id_user': prefs.idUser,
        'app': 'true',
        'id_entrega': idEntrega,
        'entrega_comentarios': comentarios,
      });
      final decodedData = json.decode(resp.body);
      final code = decodedData['result']['code'];
      if (code == 1 || code ==8) {
        return 1;
      } else {
        return 0;
      }
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      utils.showToast(  "Problemas con la conexión a internet",2,ToastGravity.TOP);
      return 0;
    }
  }

   */
  Future<List<TrackingData>> trackingRepartidor(String idPedido) async {
    try {
      final url = '$_url/api/pedido/tracking_pedido';
      final list = List<TrackingData>();

      final resp = await http.post((Uri.parse(url)), body: {'tn': prefs.token, 'app': 'true', 'id_pedido': idPedido});
      final decodedData = json.decode(resp.body);
      print(decodedData);
      final code = decodedData['result']['code'];

      //print(resp.body);
      if (code == 1) {
        var data = decodedData['result']['data'][0];

        //TrackingData trackingData =   TrackingData.fromJson(data);
        TrackingData trackingData = new TrackingData();
        trackingData.idPedido = data['id_pedido'];
        trackingData.idEntrega = data['id_entrega'];
        trackingData.pedidoEstado = data['pedido_estado'];
        trackingData.personName = data['person_name'];
        trackingData.pedidoDireccion = data['pedido_direccion'];
        trackingData.idRepartidor = data['id_repartidor'];
        trackingData.userImage = data['user_image'];
        trackingData.pedidoX = data['pedido_x'];
        trackingData.pedidoY = data['pedido_y'];
        trackingData.trackingX = data['punto_x'];
        trackingData.trackingY = data['punto_y'];

        list.add(trackingData);
        return list;
      } else {
        return [];
      }
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      //utils.showToast(  "Problemas con la conexión a internet",2,ToastGravity.TOP);
      return [];
    }
  }
}
