import 'package:enchiladasapp/src/database/item_observacion_database.dart';
import 'package:enchiladasapp/src/models/productos_model.dart';
import 'package:rxdart/subjects.dart';

class ItemObservacionBloc {
  final itemObservacionDatabase = ItemObservacionDatabase();

  final _itemObservacioController = new BehaviorSubject<List<ProductosData>>();

  Stream<List<ProductosData>> get itemObservacioStream =>
      _itemObservacioController.stream;

  dispose() {
    _itemObservacioController?.close();
  }

  void obtenerObservacionItem() async {
    final listGeneral = List<ProductosData>();

    final datosObtenidos =await itemObservacionDatabase.obtenerItemObservacion();

    if (datosObtenidos.length > 0) {
      for (var i = 0; i < datosObtenidos.length; i++) { 
       // if (datosObtenidos[i].idCategoria != '16') {
          ProductosData productosData = ProductosData();
          productosData.idProducto = datosObtenidos[i].idProducto;
          productosData.idCategoria = datosObtenidos[i].idCategoria;
          productosData.productoNombre = datosObtenidos[i].productoNombre;
          productosData.productoPrecio = datosObtenidos[i].productoPrecio;
          productosData.productoFoto = datosObtenidos[i].productoFoto;
          productosData.productoObservacion =datosObtenidos[i].productoObservacion;
          productosData.productoTipo =datosObtenidos[i].productoTipo;
          listGeneral.add(productosData);
        //}
      }
      /* for (var x = 0; x < datosObtenidos.length; x++) {
        if (datosObtenidos[x].idCategoria == '16') {
          ProductosData productosData = ProductosData();
          productosData.idProducto = datosObtenidos[x].idProducto;
          productosData.idCategoria = datosObtenidos[x].idCategoria;
          productosData.productoNombre = datosObtenidos[x].productoNombre;
          productosData.productoPrecio = datosObtenidos[x].productoPrecio;
          productosData.productoFoto = datosObtenidos[x].productoFoto;
          productosData.productoTipo =datosObtenidos[x].productoTipo;
          productosData.productoObservacion =
              datosObtenidos[x].productoObservacion;
          listGeneral.add(productosData);
        }
      } */
    }

    /* if (listGeneral.length > 0) {
      print('lista de los pendejos     ${listGeneral[0].productoObservacion}');
    } */
    _itemObservacioController.sink.add(listGeneral);
  }
}
