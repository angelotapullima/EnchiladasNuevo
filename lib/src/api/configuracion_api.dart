import 'dart:convert';
import 'package:enchiladasapp/src/database/pantalla_database.dart';
import 'package:enchiladasapp/src/database/producto_database.dart';
import 'package:enchiladasapp/src/database/puzzle_database.dart';
import 'package:enchiladasapp/src/database/zona_database.dart';
import 'package:enchiladasapp/src/models/pantalla_model.dart';
import 'package:enchiladasapp/src/models/productos._model.dart';
import 'package:enchiladasapp/src/models/puzzle_model.dart';
import 'package:enchiladasapp/src/models/zona_model.dart';
import 'package:enchiladasapp/src/utils/utilidades.dart' as utils;
import 'package:enchiladasapp/src/utils/preferencias_usuario.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class ConfiguracionApi {
  final String _url = 'https://delivery.lacasadelasenchiladas.pe';

  final prefs = new Preferences();
  final zonaDatabase = ZonaDatabase();
  final pantallaDatabase = PantallaDatabase();
  final puzzleDatabase = PuzzleDatabase();
  final productoDatabase = ProductoDatabase();

  Future<bool> configuracion() async {
    try { 
      final url = '$_url/api/categoria/configuracion'; 
      final resp = await http.post(url, body: {});
      final Map<String, dynamic> decodedData = json.decode(resp.body);
      if (decodedData['result']['code'] == 1) {


        for (int z = 0; z < decodedData['result']['data']['bolsa'].length; z++) {
            ProductosData productosData = ProductosData();
            productosData.idProducto = decodedData['result']['data']['bolsa'][z]['id_producto'];
            productosData.idCategoria = decodedData['result']['data']['bolsa'][z]['id_categoria'];
            productosData.productoNombre = decodedData['result']['data']['bolsa'][z]['producto_nombre'];
            productosData.productoPrecio = decodedData['result']['data']['bolsa'][z]['producto_precio'];
            productosData.productoUnidad = decodedData['result']['data']['bolsa'][z]['producto_unidad'];
            productosData.productoEstado = decodedData['result']['data']['bolsa'][z]['producto_estado'];
            productosData.productoFavorito = 0;

            productoDatabase.insertarProductosDb(productosData);

            prefs.idBolsa=decodedData['result']['data']['bolsa'][z]['id_producto'];
        }
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
          zona.zonaDescripcion =
              decodedData['result']['data']['zonas'][i]['zona_descripcion'];
          zona.zonaEstado =
              decodedData['result']['data']['zonas'][i]['zona_estado'];
          zona.zonaTiempo =
              decodedData['result']['data']['zonas'][i]['zona_tiempo'];

          zona.recargoProductoNombre = decodedData['result']['data']['zonas'][i]
              ['recargo'][0]['recargo_producto_nombre'];
          zona.recargoProductoPrecio = decodedData['result']['data']['zonas'][i]
              ['recargo'][0]['recargo_producto_precio'];
          zona.deliveryProductoNombre = decodedData['result']['data']['zonas']
              [i]['delivery_rapido'][0]['delivery_producto_nombre'];
          zona.deliveryProductoPrecio = decodedData['result']['data']['zonas']
              [i]['delivery_rapido'][0]['delivery_producto_precio'];

          await zonaDatabase.insertarZonaDb(zona);
        }

        for (int x = 0;
            x < decodedData['result']['data']['pantallas'].length;
            x++) {
          PantallaModel pantalla = PantallaModel();

          pantalla.idPantalla =
              decodedData['result']['data']['pantallas'][x]['id_pantalla'];
          pantalla.pantallaNombre =
              decodedData['result']['data']['pantallas'][x]['pantalla_nombre'];
          pantalla.pantallaOrden =
              decodedData['result']['data']['pantallas'][x]['pantalla_orden'];
          pantalla.pantallaFoto =
              decodedData['result']['data']['pantallas'][x]['pantalla_foto'];
          pantalla.pantallaEstado =
              decodedData['result']['data']['pantallas'][x]['pantalla_estado'];
          pantalla.pantallCategoria = decodedData['result']['data']['pantallas']
              [x]['pantalla_categorias'][0]['id_categoria'];

          await pantallaDatabase.insertarPantalla(pantalla);
        }

        for (int y = 0;
            y < decodedData['result']['data']['puzzle'].length;
            y++) {
          PuzzleDatum puzzle = PuzzleDatum();
          puzzle.idImagen =
              decodedData['result']['data']['puzzle'][y]['id_imagen'];
          puzzle.imagenRuta =
              decodedData['result']['data']['puzzle'][y]['imagen_ruta'];
          puzzle.imagenTitulo =
              decodedData['result']['data']['puzzle'][y]['imagen_titulo'];

          puzzle.imagenSubida =
              decodedData['result']['data']['puzzle'][y]['imagen_subida'];
          puzzle.imagenInicio =
              decodedData['result']['data']['puzzle'][y]['imagen_inicio'];
          puzzle.imagenFin =
              decodedData['result']['data']['puzzle'][y]['imagen_fin'];
          puzzle.imagenEstado =
              decodedData['result']['data']['puzzle'][y]['imagen_estado'];

          await puzzleDatabase.insertarPuzzle(puzzle);
        }

        return true;
      } else {
        return false;
      }
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      utils.showToast(
          "Problemas con la conexión a internet", 2, ToastGravity.TOP);
      return false;
    }
  }
}
