import 'package:enchiladasapp/src/database/adicionales_database.dart';
import 'package:enchiladasapp/src/database/producto_database.dart';
import 'package:enchiladasapp/src/models/adicionales_model.dart';
import 'package:rxdart/subjects.dart';

class AdicionalesBloc {
  final adicionalesDatabase = AdicionalesDatabase();
  final prodcutoDatase = ProductoDatabase();

  final _adicionalesController = new BehaviorSubject<List<AdicionalesModel>>();

  Stream<List<AdicionalesModel>> get adicionalesStream =>
      _adicionalesController.stream;

  dispose() {
    _adicionalesController?.close();
  }

  void obtenerAdicionales(String idProducto) async {
    final listGeneral = List<AdicionalesModel>();
    final listAdicionales =
        await adicionalesDatabase.obtenerAdicionales(idProducto);

    for (var i = 0; i < listAdicionales.length; i++) {
      final listProduct = await prodcutoDatase
          .consultarPorId(listAdicionales[i].idProductoAdicional);

      if (listProduct.length > 0) {
        AdicionalesModel adicionalesModel = AdicionalesModel();
        adicionalesModel.idProducto = listAdicionales[i].idProducto;
        adicionalesModel.adicionalesNombre = listProduct[0].productoNombre;
        adicionalesModel.adicionalesPrecio = listProduct[0].productoPrecio;
        adicionalesModel.adicionalSeleccionado =listAdicionales[i].adicionalSeleccionado;
        adicionalesModel.idProductoAdicional =listAdicionales[i].idProductoAdicional;
        listGeneral.add(adicionalesModel);
        listProduct.clear();
      }
    }


    _adicionalesController.sink.add(listGeneral);
  }
}
