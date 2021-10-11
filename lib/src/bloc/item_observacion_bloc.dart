import 'package:enchiladasapp/src/api/categorias_api.dart';
import 'package:enchiladasapp/src/database/item_observacion_database.dart';
import 'package:enchiladasapp/src/models/productos_model.dart';
import 'package:rxdart/subjects.dart';

class ItemObservacionBloc {
  final categoriasApi = CategoriasApi();
  final itemObservacionDatabase = ItemObservacionDatabase();

  final _itemObservacioController = new BehaviorSubject<List<ProductosData>>();

  Stream<List<ProductosData>> get itemObservacioStream =>
      _itemObservacioController.stream;

  dispose() {
    _itemObservacioController?.close();
  }

  void obtenerObservacionItem() async {
    //await categoriasApi.obtenerAdicionalesPorProducto(idProducto);
    _itemObservacioController.sink.add(await obtenerObservacionItem2());
  }

  Future<List<ProductosData>> obtenerObservacionItem2() async {
    final List<ProductosData> listGeneral = [];

    final datosObtenidos =
        await itemObservacionDatabase.obtenerItemObservacion();

    if (datosObtenidos.length > 0) {
      for (var i = 0; i < datosObtenidos.length; i++) {
        // if (datosObtenidos[i].idCategoria != '16') {
        ProductosData productosData = ProductosData();
        productosData.idProducto = datosObtenidos[i].idProducto;
        productosData.idCategoria = datosObtenidos[i].idCategoria;
        productosData.productoNombre = datosObtenidos[i].productoNombre;
        productosData.productoPrecio = datosObtenidos[i].productoPrecio;
        productosData.productoFoto = datosObtenidos[i].productoFoto;
        productosData.productoObservacion =
            datosObtenidos[i].productoObservacion;
        productosData.productoTipo = datosObtenidos[i].productoTipo;
        listGeneral.add(productosData);
        //}
      }
    }

    /* if (listGeneral.length > 0) {
      print('lista de los pendejos     ${listGeneral[0].productoObservacion}');
    } */
    return listGeneral;
  }
}
