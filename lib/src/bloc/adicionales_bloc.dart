import 'package:enchiladasapp/src/database/adicionales_database.dart';
import 'package:enchiladasapp/src/database/producto_database.dart';
import 'package:enchiladasapp/src/models/adicionales_model.dart';
import 'package:rxdart/subjects.dart';

class AdicionalesBloc {
  final adicionalesDatabase = AdicionalesDatabase();
  final prodcutoDatase = ProductoDatabase();

  final _adicionalesController = new BehaviorSubject<List<ItemAdicional>>();

  Stream<List<ItemAdicional>> get adicionalesStream =>
      _adicionalesController.stream;

  dispose() {
    _adicionalesController?.close();
  }

  void obtenerAdicionales(String idProducto) async {
    final listGeneral = List<ItemAdicional>();
    final listAdicionales = await adicionalesDatabase.obtenerAdicionalesNumeroItem(idProducto);

    for (var i = 0; i < listAdicionales.length; i++) { 

      final listtsytdvufbu = List<AdicionalesModel>();

      ItemAdicional itemAdicional = ItemAdicional();
      itemAdicional.item = listAdicionales[i].adicionalItem;
      final adicionalesItem = await adicionalesDatabase.obtenerAdicionales( idProducto, listAdicionales[i].adicionalItem);

      for (var x = 0; x < adicionalesItem.length; x++) {
        final listProduct = await prodcutoDatase.consultarPorId(adicionalesItem[x].idProductoAdicional);

        if (listProduct.length > 0) {
          AdicionalesModel adicionalesModel = AdicionalesModel();
          adicionalesModel.idProducto = adicionalesItem[x].idProducto;
          adicionalesModel.adicionalesNombre = listProduct[0].productoNombre;
          adicionalesModel.adicionalesPrecio = listProduct[0].productoPrecio;
          adicionalesModel.adicionalSeleccionado = adicionalesItem[x].adicionalSeleccionado;
          adicionalesModel.idProductoAdicional = adicionalesItem[x].idProductoAdicional;
          adicionalesModel.titulo = adicionalesItem[x].titulo;

          listtsytdvufbu.add(adicionalesModel);
          //listGeneral.add(adicionalesModel);
          //listProduct.clear();
        }
      }

      itemAdicional.lista = listtsytdvufbu;
      listGeneral.add(itemAdicional);
    }

    _adicionalesController.sink.add(listGeneral);
  }
}

class ItemAdicional {
  String item;
  List<AdicionalesModel> lista;

  ItemAdicional({this.item, this.lista});
}
