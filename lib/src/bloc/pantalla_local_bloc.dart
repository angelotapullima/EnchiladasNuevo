import 'package:enchiladasapp/src/database/categorias_database.dart';
import 'package:enchiladasapp/src/database/pantalla_database.dart';
import 'package:enchiladasapp/src/database/producto_database.dart';
import 'package:enchiladasapp/src/database/puzzle_database.dart';
import 'package:enchiladasapp/src/models/categoria_model.dart';
import 'package:enchiladasapp/src/models/productos_model.dart';
import 'package:rxdart/subjects.dart';

class PantallaLocalBloc {
  final pantallaDatabase = PantallaDatabase();
  final categoriasDatabase = CategoriasDatabase();
  final puzzleDatabase = PuzzleDatabase();
  final productosDatabase = ProductoDatabase();

  final _pantallasLocalController = new BehaviorSubject<List<CategoriaData>>();
  final _estadoPantallaLocalDesicion = new BehaviorSubject<bool>();

  Stream<List<CategoriaData>> get pantallasLocalStream =>
      _pantallasLocalController.stream;
  Stream<bool> get estadoDesicionLocalStream =>
      _estadoPantallaLocalDesicion.stream;

  dispose() {
    _pantallasLocalController?.close();
    _estadoPantallaLocalDesicion?.close();
  }

  void obtenerPantallasLocal() async {
    final listGeneral = List<CategoriaData>();

    var listaCategorias =
        await categoriasDatabase.obtenerCategoriasEnchiladas();

    for (var i = 0; i < listaCategorias.length; i++) {
      CategoriaData categoriaData = CategoriaData();

      categoriaData.categoriaNombre = listaCategorias[i].categoriaNombre;
      categoriaData.categoriaIcono = listaCategorias[i].categoriaIcono;
      categoriaData.categoriaTipo = listaCategorias[i].categoriaTipo;
      categoriaData.idCategoria = listaCategorias[i].idCategoria;
      categoriaData.categoriaFoto = listaCategorias[i].categoriaFoto;
      categoriaData.categoriaBanner = listaCategorias[i].categoriaBanner;
      categoriaData.categoriaPromocion = listaCategorias[i].categoriaPromocion;
      categoriaData.categoriaEstado = listaCategorias[i].categoriaEstado;
      categoriaData.categoriaMostrarApp =
          listaCategorias[i].categoriaMostrarApp;

      final productos = await productosDatabase
          .obtenerProductosPorCategoria(listaCategorias[i].idCategoria);

      final productitos = List<ProductosData>();

      for (var x = 0; x < productos.length; x++) {
        ProductosData productosData = ProductosData();
        productosData.idProducto = productos[x].idProducto;
        productosData.idCategoria = productos[x].idCategoria;
        productosData.productoNombre = productos[x].productoNombre;
        productosData.productoFoto = productos[x].productoFoto;
        productosData.productoPrecio = productos[x].productoPrecio;
        productosData.productoUnidad = productos[x].productoUnidad;
        productosData.productoEstado = productos[x].productoEstado;
        productosData.numeroitem = x.toString();
        productosData.productoDescripcion = productos[x].productoDescripcion;
        productosData.productoComentario = productos[x].productoComentario;
        productitos.add(productosData);
      }
      categoriaData.productos = productitos;

      listGeneral.add(categoriaData);
    }

    _pantallasLocalController.sink.add(listGeneral);
  }
}