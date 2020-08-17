import 'dart:convert';

import 'package:enchiladasapp/src/database/delivery_rapido_database.dart';
import 'package:enchiladasapp/src/database/producto_database.dart';
import 'package:enchiladasapp/src/database/zona_database.dart';
import 'package:enchiladasapp/src/models/delivery_rapido_model.dart';
import 'package:enchiladasapp/src/models/productos._model.dart';
import 'package:enchiladasapp/src/models/zona_model.dart';
import 'package:enchiladasapp/src/utils/utilidades.dart' as utils;
import 'package:enchiladasapp/src/widgets/preferencias_usuario.dart';
import 'package:http/http.dart' as http;

class ConfiguracionApi {
  final String _url = 'https://delivery.lacasadelasenchiladas.pe';

  final prefs = new Preferences();
  final zonaDatabase = ZonaDatabase();
  final productoDatabase = ProductoDatabase();
  final deliveryRapidoDatabase = DeliveryRapidoDatabase();

  Future<bool> configuracion() async {
    try {
      final url = '$_url/api/categoria/configuracion';
      final resp = await http.post(url, body: {});
      final Map<String, dynamic> decodedData = json.decode(resp.body);
      if (decodedData['result']['code'] == 1) {
        for (int i = 0;
            i < decodedData['result']['data']['zonas'].length;
            i++) {
          Zona zona = Zona();

          zona.idZona = decodedData['result']['data']['zonas'][i]['id_zona'];
          zona.zonaNombre =
              decodedData['result']['data']['zonas'][i]['zona_nombre'];
          zona.zonaPedidoMinimo =
              decodedData['result']['data']['zonas'][i]['zona_pedido_minimo'];
          zona.zonaImagen =
              decodedData['result']['data']['zonas'][i]['zona_imagen'];
          zona.idProducto =
              decodedData['result']['data']['zonas'][i]['id_producto'];
          zona.zonaDescripcion =
              decodedData['result']['data']['zonas'][i]['zona_descripcion'];

          await zonaDatabase.insertarZonaDb(zona);

          ProductosData productos = ProductosData();

          productos.idProducto =
              decodedData['result']['data']['zonas'][i]['id_producto'];
          productos.idCategoria =
              decodedData['result']['data']['zonas'][i]['id_categoria'];
          productos.productoNombre =
              decodedData['result']['data']['zonas'][i]['producto_nombre'];
          productos.productoPrecio =
              decodedData['result']['data']['zonas'][i]['producto_precio'];
          productos.productoUnidad =
              decodedData['result']['data']['zonas'][i]['producto_unidad'];
          productos.productoEstado =
              decodedData['result']['data']['zonas'][i]['producto_estado'];
          productos.productoDescripcion =
              decodedData['result']['data']['zonas'][i]['producto_detalle'];
          productos.productoFoto = '0';
          productos.productoFavorito = 0;

          await productoDatabase.insertarProductosDb(productos);
        }

        ProductosData productos = ProductosData();

        productos.idCategoria =
            decodedData['result']['data']['delivery_rapido']['id_categoria'];
        productos.productoNombre =
            decodedData['result']['data']['delivery_rapido']['producto_nombre'];
        productos.productoPrecio =
            decodedData['result']['data']['delivery_rapido']['producto_precio'];
        productos.idProducto =
            decodedData['result']['data']['delivery_rapido']['id_producto'];
        productos.productoUnidad =
            decodedData['result']['data']['delivery_rapido']['producto_unidad'];
        productos.productoEstado =
            decodedData['result']['data']['delivery_rapido']['producto_estado'];
        productos.productoFoto =
            decodedData['result']['data']['delivery_rapido']['producto_foto'];

        productos.productoDescripcion =
            decodedData['result']['data']['delivery_rapido']['producto_detalle'];
        productos.productoFavorito = 0;

        await productoDatabase.insertarProductosDb(productos);

        await deliveryRapidoDatabase.deleteDeliveryRapido();
        DeliveryRapido deliveryRapido = DeliveryRapido();
        deliveryRapido.idDelivery = "1";
        deliveryRapido.idProducto = productos.idProducto;
        await deliveryRapidoDatabase.insertarDeliveryRapidoDb(deliveryRapido);

        return true;
      } else {
        return false;
      }
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      utils.showToast("Problemas con la conexión a internet", 2);
      return false;
    }
  }
}
