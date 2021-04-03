import 'package:enchiladasapp/src/api/categorias_api.dart';
import 'package:enchiladasapp/src/database/adicionales_database.dart';
import 'package:enchiladasapp/src/database/producto_database.dart';
import 'package:enchiladasapp/src/models/adicionales_model.dart';
import 'package:rxdart/subjects.dart';

class AdicionalesBloc {

  final categoriasApi =CategoriasApi();
  final adicionalesDatabase = AdicionalesDatabase();
  final prodcutoDatase = ProductoDatabase();

  final _adicionalesController = new BehaviorSubject<List<ItemAdicional>>();

  Stream<List<ItemAdicional>> get adicionalesStream =>
      _adicionalesController.stream;

  dispose() {
    _adicionalesController?.close();
  }

  void obtenerAdicionales(String idProducto) async { 
     
    _adicionalesController.sink.add(await obtenerAdicionales2(idProducto));
  }

  Future<List<ItemAdicional>> obtenerAdicionales2(String idProducto) async {
    final listGeneral = List<ItemAdicional>();
    final listAdicionales =
        await adicionalesDatabase.obtenerAdicionalesNumeroItem(idProducto);

    for (var i = 0; i < listAdicionales.length; i++) {
      final listtsytdvufbu = List<AdicionalesModel>();

      ItemAdicional itemAdicional = ItemAdicional();
      itemAdicional.item = listAdicionales[i].adicionalItem;
      final adicionalesItem = await adicionalesDatabase.obtenerAdicionales(
          idProducto, listAdicionales[i].adicionalItem);

      for (var x = 0; x < adicionalesItem.length; x++) {
        final listProduct = await prodcutoDatase
            .consultarPorId(adicionalesItem[x].idProductoAdicional);

        if (listProduct.length > 0) {
          AdicionalesModel adicionalesModel = AdicionalesModel();
          adicionalesModel.idProducto = adicionalesItem[x].idProducto;
          adicionalesModel.adicionalesNombre = listProduct[0].productoNombre;
          adicionalesModel.adicionalesPrecio = listProduct[0].productoPrecio;
          adicionalesModel.adicionalSeleccionado =
              adicionalesItem[x].adicionalSeleccionado;
          adicionalesModel.idProductoAdicional =
              adicionalesItem[x].idProductoAdicional;
          adicionalesModel.titulo = adicionalesItem[x].titulo;

          listtsytdvufbu.add(adicionalesModel);
          //listGeneral.add(adicionalesModel);
          //listProduct.clear();
        }
      }

      itemAdicional.lista = listtsytdvufbu;
      listGeneral.add(itemAdicional);
    }

    return listGeneral; 
  }
}

class ItemAdicional {
  String item;
  List<AdicionalesModel> lista;

  ItemAdicional({this.item, this.lista});
}
