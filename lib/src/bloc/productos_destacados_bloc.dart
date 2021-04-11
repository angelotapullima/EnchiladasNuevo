import 'package:enchiladasapp/src/database/categorias_database.dart';
import 'package:enchiladasapp/src/database/producto_database.dart';
import 'package:enchiladasapp/src/models/productos_model.dart';
import 'package:rxdart/subjects.dart';

class ProductosDestacadosBloc {
  final productoDatabase = ProductoDatabase();
  final categoriaDatabase = CategoriasDatabase();

  final _productosDestacadosController =
      new BehaviorSubject<List<ProductosData>>();

  Stream<List<ProductosData>> get productosDestacadosStream =>
      _productosDestacadosController.stream;

  dispose() { 
    _productosDestacadosController?.close();
  }

  void obtenerProductosDestacados() async {
    final listGeneral = List<ProductosData>();

    final listProductos = await productoDatabase.obtenerProductosDestacados();

    if (listProductos.length > 0) {
      for (var x = 0; x < listProductos.length; x++) {
        final listCategorias = await categoriaDatabase
            .consultarPorId(listProductos[x].idCategoria);
        ProductosData productosData = ProductosData();
        productosData.idProducto = listProductos[x].idProducto;
      productosData.idCategoria = listProductos[x].idCategoria;
      productosData.productoNombre = listProductos[x].productoNombre;
      productosData.productoFoto = listProductos[x].productoFoto;
      productosData.productoOrden = listProductos[x].productoOrden;
      productosData.productoPrecio = listProductos[x].productoPrecio;
      productosData.productoCarta = listProductos[x].productoCarta;
      productosData.productoDelivery = listProductos[x].productoDelivery;
      productosData.sonido = listCategorias[0].categoriaSonido;
      productosData.productoUnidad = listProductos[x].productoUnidad;
      productosData.productoEstado = listProductos[x].productoEstado;
      productosData.productoDestacado = listProductos[x].productoDestacado;
      productosData.productoEstadoDestacado = listProductos[x].productoEstadoDestacado;
      productosData.productoTupper = listProductos[x].productoTupper;
      productosData.productoNuevo = listProductos[x].productoNuevo;
      productosData.numeroitem = x.toString();
      productosData.productoDescripcion = listProductos[x].productoDescripcion;
      productosData.productoComentario = listProductos[x].productoComentario;
      productosData.productoFavorito = listProductos[x].productoFavorito;

        listGeneral.add(productosData);
      }
    }

    _productosDestacadosController.sink.add(listGeneral);
  }
}
