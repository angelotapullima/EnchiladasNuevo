import 'package:enchiladasapp/src/database/adicionales_database.dart';
import 'package:enchiladasapp/src/models/productos_model.dart';
import 'package:rxdart/subjects.dart';

class AdicionalesBloc {
  final adicionalesDatabase = AdicionalesDatabase();

  final _adicionalesController = new BehaviorSubject<List<ProductosData>>();

  Stream<List<ProductosData>> get adicionalesStream =>
      _adicionalesController.stream;

  dispose() {
    _adicionalesController?.close();
  }

  void obtenerAdicionales(String idCategoria) async {
    final listGeneral = List<ProductosData>();
    final listProductos =
        await adicionalesDatabase.obtenerAdicionales(idCategoria);

    for (var x = 0; x < listProductos.length; x++) {
      //final listCategorias =await categoriaDatabase.consultarPorId(listProductos[x].idCategoria);
      ProductosData productosData = ProductosData();
      productosData.idProducto = listProductos[x].idProducto;
      productosData.idCategoria = listProductos[x].idCategoria;
      productosData.productoNombre = listProductos[x].productoNombre;
      productosData.productoFoto = listProductos[x].productoFoto;
      productosData.productoPrecio = listProductos[x].productoPrecio;
      productosData.productoCarta = listProductos[x].productoCarta;
      productosData.productoDelivery = listProductos[x].productoDelivery;
      productosData.productoSeleccionado =
          listProductos[x].productoSeleccionado;
      productosData.productoEstado = listProductos[x].productoEstado;
      productosData.productoDescripcion = listProductos[x].productoDescripcion;
      listGeneral.add(productosData);
    }
    _adicionalesController.sink.add(listGeneral);
  }
}
