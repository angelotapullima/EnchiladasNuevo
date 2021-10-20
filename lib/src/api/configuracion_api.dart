import 'dart:convert';
import 'package:enchiladasapp/src/database/pantalla_database.dart';
import 'package:enchiladasapp/src/database/producto_database.dart';
import 'package:enchiladasapp/src/database/publicidad_database.dart';
import 'package:enchiladasapp/src/database/zona_database.dart';
import 'package:enchiladasapp/src/models/pantalla_model.dart';
import 'package:enchiladasapp/src/models/productos_model.dart';
import 'package:enchiladasapp/src/models/publicidad_model.dart';
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
  //final puzzleDatabase = PuzzleDatabase();
  final productoDatabase = ProductoDatabase();
  final publicidadDatabase = PublicidadDatabase();

  Future<bool> configuracion() async {
    try {
      final url = '$_url/api/categoria/configuracion_v2';
      final resp = await http.post((Uri.parse(url)), body: {'numero': '1'});
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
          productosData.productoComentario = '';

          productoDatabase.insertarProductosDb(productosData);

          prefs.idBolsa = decodedData['result']['data']['bolsa'][z]['id_producto'];
        }

        for (int a = 0; a < decodedData['result']['data']['tupper'].length; a++) {
          ProductosData productosData = ProductosData();
          productosData.idProducto = decodedData['result']['data']['tupper'][a]['id_producto'];
          productosData.idCategoria = decodedData['result']['data']['tupper'][a]['id_categoria'];
          productosData.productoNombre = decodedData['result']['data']['tupper'][a]['producto_nombre'];
          productosData.productoPrecio = decodedData['result']['data']['tupper'][a]['producto_precio'];
          productosData.productoUnidad = decodedData['result']['data']['tupper'][a]['producto_unidad'];
          productosData.productoEstado = decodedData['result']['data']['tupper'][a]['producto_estado'];
          productosData.productoFavorito = 0;
          productosData.productoComentario = '';

          productoDatabase.insertarProductosDb(productosData);

          prefs.idTupper = decodedData['result']['data']['tupper'][a]['id_producto'];
        }

        var tamanoPublicidad = decodedData['result']['data']['publicidad'].length;

        if (tamanoPublicidad > 0) {
          await publicidadDatabase.deletePublcidadDb();

          for (int j = 0; j < decodedData['result']['data']['publicidad'].length; j++) {
            PublicidadModel publicidadModel = PublicidadModel();

            publicidadModel.idPublicidad = j.toString();
            publicidadModel.publicidadEstado = decodedData['result']['data']['publicidad'][j]['publicidad_estado'];
            publicidadModel.publicidadImagen = decodedData['result']['data']['publicidad'][j]['publicidad_imagen'];
            publicidadModel.publicidadTipo = decodedData['result']['data']['publicidad'][j]['publicidad_tipo'];
            publicidadModel.idRelacionado = decodedData['result']['data']['publicidad'][j]['publicidad_id'];

            publicidadDatabase.insertarPublicidad(publicidadModel);
          }
        }

        for (int i = 0; i < decodedData['result']['data']['zonas'].length; i++) {
          Zona zona = Zona();

          zona.idZona = decodedData['result']['data']['zonas'][i]['id_zona'];
          zona.zonaNombre = decodedData['result']['data']['zonas'][i]['zona_nombre'];
          zona.zonaPedidoMinimo = decodedData['result']['data']['zonas'][i]['zona_pedido_minimo'];
          zona.zonaImagen = decodedData['result']['data']['zonas'][i]['zona_imagen'];
          zona.zonaDescripcion = decodedData['result']['data']['zonas'][i]['zona_descripcion'];
          zona.zonaEstado = decodedData['result']['data']['zonas'][i]['zona_estado'];
          zona.zonaTiempo = decodedData['result']['data']['zonas'][i]['zona_tiempo'];

          zona.recargoProductoNombre = decodedData['result']['data']['zonas'][i]['recargo'][0]['recargo_producto_nombre'];
          zona.recargoProductoPrecio = decodedData['result']['data']['zonas'][i]['recargo'][0]['recargo_producto_precio'];
          zona.deliveryProductoNombre = decodedData['result']['data']['zonas'][i]['delivery_rapido'][0]['delivery_producto_nombre'];
          zona.deliveryProductoPrecio = decodedData['result']['data']['zonas'][i]['delivery_rapido'][0]['delivery_producto_precio'];

          await zonaDatabase.insertarZonaDb(zona);
        }

        for (int x = 0; x < decodedData['result']['data']['pantallas']['delivery'].length; x++) {
          PantallaModel pantalla = PantallaModel();

          pantalla.idPantalla = decodedData['result']['data']['pantallas']['delivery'][x]['id_pantalla'];
          pantalla.pantallaNombre = decodedData['result']['data']['pantallas']['delivery'][x]['pantalla_nombre'];
          pantalla.pantallaOrden = decodedData['result']['data']['pantallas']['delivery'][x]['pantalla_orden'];
          pantalla.pantallaEstado = decodedData['result']['data']['pantallas']['delivery'][x]['pantalla_estado'];
          pantalla.pantallCategoria = decodedData['result']['data']['pantallas']['delivery'][x]['pantalla_categorias'][0]['id_categoria'];
          pantalla.pantallaTipo = '5';

          await pantallaDatabase.insertarPantalla(pantalla);
        }

        for (int x = 0; x < decodedData['result']['data']['pantallas']['enchiladas'].length; x++) {
          PantallaModel pantalla = PantallaModel();

          pantalla.idPantalla = decodedData['result']['data']['pantallas']['enchiladas'][x]['id_pantalla'];
          pantalla.pantallaNombre = decodedData['result']['data']['pantallas']['enchiladas'][x]['pantalla_nombre'];
          pantalla.pantallaOrden = decodedData['result']['data']['pantallas']['enchiladas'][x]['pantalla_orden'];
          pantalla.pantallaEstado = decodedData['result']['data']['pantallas']['enchiladas'][x]['pantalla_estado'];
          pantalla.pantallCategoria = decodedData['result']['data']['pantallas']['enchiladas'][x]['pantalla_categorias'][0]['id_categoria'];
          pantalla.pantallaTipo = '1';
          await pantallaDatabase.insertarPantalla(pantalla);
        }
        for (int x = 0; x < decodedData['result']['data']['pantallas']['cafe'].length; x++) {
          PantallaModel pantalla = PantallaModel();

          pantalla.idPantalla = decodedData['result']['data']['pantallas']['cafe'][x]['id_pantalla'];
          pantalla.pantallaNombre = decodedData['result']['data']['pantallas']['cafe'][x]['pantalla_nombre'];
          pantalla.pantallaOrden = decodedData['result']['data']['pantallas']['cafe'][x]['pantalla_orden'];
          pantalla.pantallaEstado = decodedData['result']['data']['pantallas']['cafe'][x]['pantalla_estado'];
          pantalla.pantallCategoria = decodedData['result']['data']['pantallas']['cafe'][x]['pantalla_categorias'][0]['id_categoria'];
          pantalla.pantallaTipo = '3';
          await pantallaDatabase.insertarPantalla(pantalla);
        }

        for (int x = 0; x < decodedData['result']['data']['pantallas']['var'].length; x++) {
          PantallaModel pantalla = PantallaModel();

          pantalla.idPantalla = decodedData['result']['data']['pantallas']['var'][x]['id_pantalla'];
          pantalla.pantallaNombre = decodedData['result']['data']['pantallas']['var'][x]['pantalla_nombre'];
          pantalla.pantallaOrden = decodedData['result']['data']['pantallas']['var'][x]['pantalla_orden'];
          pantalla.pantallaEstado = decodedData['result']['data']['pantallas']['var'][x]['pantalla_estado'];
          pantalla.pantallCategoria = decodedData['result']['data']['pantallas']['var'][x]['pantalla_categorias'][0]['id_categoria'];
          pantalla.pantallaTipo = '4';
          await pantallaDatabase.insertarPantalla(pantalla);
        }

        return true;
      } else {
        return false;
      }
    } catch (error) {
      //print("Exception occured: $error stackTrace: $stacktrace");
      utils.showToast("Problemas con la conexión a internet", 2, ToastGravity.TOP);
      return false;
    }
  }
}
