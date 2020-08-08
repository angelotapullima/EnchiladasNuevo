import 'package:enchiladasapp/src/database/categorias_database.dart';
import 'package:enchiladasapp/src/database/producto_database.dart';
import 'package:enchiladasapp/src/models/categoria_model.dart';
import 'package:enchiladasapp/src/models/productos._model.dart';
import 'package:enchiladasapp/src/utils/utilidades.dart' as utils; 
import 'package:http/http.dart' as http;
import 'dart:convert';

class CategoriasApi {
  final String _url = 'https://delivery.lacasadelasenchiladas.pe';
  final categoriasDatabase = CategoriasDatabase();
  final productoDatabase = ProductoDatabase();

  Future<bool> obtenerAmbos() async {
    try {
      final url = '$_url/api/categoria/listar_categorias_productos';
      final resp = await http.post(url, body: {});
      final Map<String, dynamic> decodedData = json.decode(resp.body);
      if (decodedData == null) return false;
      

      for (int i = 0; i < decodedData['result']['data'].length; i++) {
        if (decodedData['result']['data'].length > 0) {
          final id = decodedData['result']['data'][i]['id_categoria'];
          final dato = await categoriasDatabase.consultarPorId(id);
          CategoriaData categoriaData = CategoriaData();

          categoriaData.idCategoria = decodedData['result']['data'][i]['id_categoria'];
          categoriaData.categoriaNombre = decodedData['result']['data'][i]['categoria_nombre'];
          categoriaData.categoriaEstado = decodedData['result']['data'][i]['categoria_estado'];
          categoriaData.categoriaMostrarApp = decodedData['result']['data'][i]['categoria_mostrar_app'];
          categoriaData.categoriaTipo = decodedData['result']['data'][i]['categoria_tipo'];

          if (dato.length > 0) {
            categoriaData.categoriaCod = dato[0].categoriaCod;
            categoriaData.idAlmacen = dato[0].idAlmacen;

            categoriasDatabase.updateCategoriaDb(categoriaData);
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

              if (datoproducto.length > 0) {
                productosData.productoFavorito =
                    datoproducto[0].productoFavorito;
                productoDatabase.updateProductosDb(productosData);
                //print('actualizado producto ${productosData.idProducto}  ');
              } else {
                productosData.productoFavorito = 0;

                productoDatabase.insertarProductosDb(productosData);
                //print('nuevo producto ${productosData.idProducto}  ');
              }
            }

            //print('actualizado categoria ${categoriaData.idCategoria}  ');
          } else {
            categoriaData.categoriaCod = " ";
            categoriaData.idAlmacen = " ";

            categoriasDatabase.insertarCategoriasDb(categoriaData);

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

              if (datoproducto.length > 0) {
                productosData.productoFavorito =
                    datoproducto[0].productoFavorito;
                productoDatabase.updateProductosDb(productosData);
                //print('actualizado producto ${productosData.idProducto}  ');
              } else {
                productosData.productoFavorito = 0;

                productoDatabase.insertarProductosDb(productosData);
                //print('nuevo producto ${productosData.idProducto}  ');
              }
            }
            //print('nuevo categoria  ${categoriaData.idCategoria}');
          }

          //categoriasDatabase.insertarCategoriasDb(cate[i]);
        }
      }

      return true;
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");

      utils.showToast(  "Problemas con la conexión a internet",2);
      return false;
    }
  }

  Future<List<CategoriaData>> cargarCategorias() async {
    try {
      final url = '$_url/api/Categoria/listar_categorias';
      final lista = List<CategoriaData>();
      final resp = await http.post(url, body: {});
      final Map<String, dynamic> decodedData = json.decode(resp.body);

      if (decodedData == null) return [];

      Categorias categorias = Categorias.fromJson(decodedData);

      for (int i = 0; i < categorias.result.data.length; i++) {
        if (categorias.result.data.length > 0) {
          final id = categorias.result.data[i].idCategoria;
          final dato = await categoriasDatabase.consultarPorId(id);
          CategoriaData categoriaData = CategoriaData();

          categoriaData.idCategoria = categorias.result.data[i].idCategoria;
          categoriaData.categoriaNombre =
              categorias.result.data[i].categoriaNombre;
          categoriaData.categoriaCod = categorias.result.data[i].categoriaCod;
          categoriaData.idAlmacen = categorias.result.data[i].idAlmacen;
          categoriaData.categoriaEstado =
              categorias.result.data[i].categoriaEstado;

          if (dato.length > 0) {
            categoriasDatabase.updateCategoriaDb(categoriaData);

            //'actualizado ${categoriaData.idCategoria}  ');
          } else {
            //print('nuevo ${categoriaData.idCategoria}');

            categoriasDatabase.insertarCategoriasDb(categoriaData);
          }
          lista.add(categoriaData);

          categoriasDatabase.insertarCategoriasDb(categorias.result.data[i]);
        }
      }

      if (lista.length < 0) {
        return [];
      } else {
        return lista;
      }
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      utils.showToast(  "Problemas con la conexión a internet",2);
      return [];
    }
  }

  Future<List<ProductosData>> obtenerProductoCategoria(
       String id) async {
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

          if (dato.length > 0) {
            productosData.productoFavorito = dato[0].productoFavorito;
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
      utils.showToast(  "Problemas con la conexión a internet",2);
      return [];
    }
  }
}
