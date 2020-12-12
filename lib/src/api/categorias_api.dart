import 'package:enchiladasapp/src/database/categorias_database.dart';
import 'package:enchiladasapp/src/database/producto_database.dart';
import 'package:enchiladasapp/src/database/temporizador_database.dart';
import 'package:enchiladasapp/src/models/categoria_model.dart';
import 'package:enchiladasapp/src/models/productos_model.dart';
import 'package:enchiladasapp/src/models/temporizador_model.dart';
import 'package:enchiladasapp/src/utils/utilidades.dart' as utils;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CategoriasApi {
  final String _url = 'https://delivery.lacasadelasenchiladas.pe';
  final categoriasDatabase = CategoriasDatabase();
  final productoDatabase = ProductoDatabase();
  final temporizadorDatabase = TemporizadorDatabase();

  Future<bool> obtenerAmbos() async {
    try {
      final url = '$_url/api/categoria/listar_categorias_productos';
      final resp = await http.post(url, body: {});
      final Map<String, dynamic> decodedData = json.decode(resp.body);
      if (decodedData == null) return false;

      for (int i = 0; i < decodedData['result']['data'].length; i++) {
        if (decodedData['result']['data'].length > 0) {
          CategoriaData categoriaData = CategoriaData();

          categoriaData.idCategoria =
              decodedData['result']['data'][i]['id_categoria'];
          categoriaData.categoriaNombre =
              decodedData['result']['data'][i]['categoria_nombre'];
          categoriaData.categoriaIcono =
              decodedData['result']['data'][i]['categoria_icono'];
          categoriaData.categoriaTipo =
              decodedData['result']['data'][i]['categoria_tipo'];
          categoriaData.categoriaFoto =
              decodedData['result']['data'][i]['categoria_foto'];
          categoriaData.categoriaBanner =
              decodedData['result']['data'][i]['categoria_banner'];
          categoriaData.categoriaPromocion =decodedData['result']['data'][i]['categoria_promocion'];
          categoriaData.categoriaSonido =decodedData['result']['data'][i]['categoria_sonido'];
          categoriaData.categoriaEstado =
              decodedData['result']['data'][i]['categoria_estado'];
          categoriaData.categoriaMostrarApp =
              decodedData['result']['data'][i]['categoria_mostrar_app'];

          categoriasDatabase.insertarCategoriasDb(categoriaData);



          //TEMPORIZADOR
          var temporizador = List<dynamic>();
          temporizador = decodedData['result']['data'][i]['temporizador'];

          TemporizadorModel temporizadorModel = TemporizadorModel();
          temporizadorModel.idTemporizador =
              decodedData['result']['data'][i]['id_categoria'];
          temporizadorModel.temporizadorTipo =
              temporizador[0]['temporizador_tipo'];
          temporizadorModel.temporizadorFechainicio =
              temporizador[0]['temporizador_fechainicio'];
          temporizadorModel.temporizadorFechafin =
              temporizador[0]['temporizador_fechafin'];
          temporizadorModel.temporizadorHorainicio =
              temporizador[0]['temporizador_horainicio'];
          temporizadorModel.temporizadorHorafin = temporizador[0]['temporizador_horafin'];
          temporizadorModel.temporizadorMensaje = temporizador[0]['temporizador_mensaje'];
          temporizadorModel.temporizadorLunes =
              temporizador[0]['temporizador_dias']['Lunes'];
          temporizadorModel.temporizadorMartes =
              temporizador[0]['temporizador_dias']['Martes'];
          temporizadorModel.temporizadorMiercoles =
              temporizador[0]['temporizador_dias']['Miercoles'];
          temporizadorModel.temporizadorJueves =
              temporizador[0]['temporizador_dias']['Jueves'];
          temporizadorModel.temporizadorViernes =
              temporizador[0]['temporizador_dias']['Viernes'];
          temporizadorModel.temporizadorSabado =
              temporizador[0]['temporizador_dias']['Sabado'];
          temporizadorModel.temporizadorDomingo =
              temporizador[0]['temporizador_dias']['Domingo'];

          await temporizadorDatabase.insertarTemporizador(temporizadorModel);

          //PRODUCTOS
          var productos = List<dynamic>();
          productos = decodedData['result']['data'][i]['productos'];
          //print('productos tamaño ${productos.length}');

          for (int x = 0; x < productos.length; x++) {
            final idproducto = productos[x]['id_producto'];
            final datoproducto =
                await productoDatabase.consultarPorId(idproducto);
            //print('id productos ${datoproducto.length}');
            ProductosData productosData = ProductosData();
            productosData.idProducto = productos[x]['id_producto'];
            productosData.idCategoria = productos[x]['id_categoria'];
            productosData.productoNombre = productos[x]['producto_nombre'];
            productosData.productoFoto = productos[x]['producto_foto'];
            productosData.productoPrecio = productos[x]['producto_precio'];
            productosData.productoUnidad = productos[x]['producto_unidad'];
            productosData.productoEstado = productos[x]['producto_estado'];
            productosData.productoDescripcion = productos[x]['producto_detalle'];
            productosData.productoComentario = decodedData['result']['data'][i]['categoria_comentario'];
            productosData.sonido = decodedData['result']['data'][i]['categoria_sonido'];


            if (datoproducto.length > 0) {
              productosData.productoFavorito = datoproducto[0].productoFavorito;
              productosData.productoComentario = datoproducto[0].productoComentario;
              productoDatabase.updateProductosDb(productosData);
              //print('actualizado producto ${productosData.idProducto}  ');
            } else {
              productosData.productoFavorito = 0;

              productoDatabase.insertarProductosDb(productosData);
              //print('nuevo producto ${productosData.idProducto}  ');
            }
          }
          //categoriasDatabase.insertarCategoriasDb(cate[i]);
        }
      }

      return true;
    } catch (error, stacktrace) {
      //print("Exception occured: $error stackTrace: $stacktrace");

      utils.showToast(
          "Problemas con la conexión a internet", 2, ToastGravity.TOP);
      return false;
    }
  }

 /*  Future<List<CategoriaData>> cargarCategorias() async {
    try {
      final url = '$_url/api/Categoria/listar_categorias';
      final lista = List<CategoriaData>();
      final resp = await http.post(url, body: {});
      final Map<String, dynamic> decodedData = json.decode(resp.body);

      if (decodedData == null) return [];

      CategoriaData categorias = CategoriaData(); //.fromJson(decodedData);

      categorias.idCategoria = decodedData['result']['data'];

      for (int i = 0; i < decodedData['result']['data'].length; i++) {
        CategoriaData categorias = CategoriaData();

        categorias.idCategoria =
            decodedData['result']['data'][i]['id_categoria'];
        categorias.categoriaTipo =
            decodedData['result']['data'][i]['categoria_tipo'];
        categorias.categoriaNombre =
            decodedData['result']['data'][i]['categoria_nombre'];
        categorias.categoriaIcono =
            decodedData['result']['data'][i]['categoria_icono'];
        categorias.categoriaPromocion =
            decodedData['result']['data'][i]['categoria_promocion'];
        categorias.categoriaFoto =
            decodedData['result']['data'][i]['categoria_foto'];
        categorias.categoriaBanner =
            decodedData['result']['data'][i]['categoria_banner'];
        categorias.categoriaEstado =
            decodedData['result']['data'][i]['categoria_estado'];
        categorias.categoriaMostrarApp =
            decodedData['result']['data'][i]['categoria_mostrar_app'];

        categoriasDatabase.insertarCategoriasDb(categorias);
        /* if (categorias.result.data.length > 0) {
          final id = categorias.result.data[i].idCategoria;
          final dato = await categoriasDatabase.consultarPorId(id);
          CategoriaData categoriaData = CategoriaData();

          categoriaData.idCategoria     = categorias.result.data[i].idCategoria;
          categoriaData.categoriaNombre = categorias.result.data[i].categoriaNombre;
          categoriaData.categoriaEstado = categorias.result.data[i].categoriaEstado;

          if (dato.length > 0) {
            categoriasDatabase.insertarCategoriasDb(categoriaData);

            //'actualizado ${categoriaData.idCategoria}  ');
          } else {
            //print('nuevo ${categoriaData.idCategoria}');

            categoriasDatabase.insertarCategoriasDb(categoriaData);
          }
          lista.add(categoriaData);

          
        } */
      }

      if (lista.length < 0) {
        return [];
      } else {
        return lista;
      }
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      utils.showToast(
          "Problemas con la conexión a internet", 2, ToastGravity.TOP);
      return [];
    }
  }

   */Future<List<ProductosData>> obtenerProductoCategoria(String id) async {
    try {
      final lista = List<ProductosData>();

      final url = '$_url/api/Categoria/listar_productos/$id';
      final resp = await http.post(url, body: {});
      final Map<String, dynamic> decodedData = json.decode(resp.body);

      if (decodedData == null) return [];
      Productos productos = Productos.fromJson(decodedData);
      for (int i = 0; i < productos.result.data.length; i++) {
        if (productos.result.data.length > 0) {
          final id = productos.result.data[i].idProducto;
          final dato = await productoDatabase.consultarPorId(id);
          ProductosData productosData = ProductosData();
          productosData.idProducto = productos.result.data[i].idProducto;
          productosData.idCategoria = productos.result.data[i].idCategoria;
          productosData.productoNombre =
              productos.result.data[i].productoNombre;
          productosData.productoFoto = productos.result.data[i].productoFoto;
          productosData.productoPrecio =
              productos.result.data[i].productoPrecio;
          productosData.productoUnidad =
              productos.result.data[i].productoUnidad;
          productosData.productoEstado =
              productos.result.data[i].productoEstado;

          productosData.productoDescripcion =
              productos.result.data[i].productoDescripcion;

          if (dato.length > 0) {
            productosData.productoFavorito = dato[0].productoFavorito;
            productosData.sonido = dato[0].sonido;
            productoDatabase.updateProductosDb(productosData);
          } else {
            productosData.productoFavorito = 0;

            productoDatabase.insertarProductosDb(productosData);
          }
          lista.add(productosData);
        }
      }

      if (lista.length < 0) {
        return [];
      } else {
        return lista;
      }
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      utils.showToast(
          "Problemas con la conexión a internet", 2, ToastGravity.TOP);
      return [];
    }
  }
}
