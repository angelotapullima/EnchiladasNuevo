import 'package:enchiladasapp/src/database/categorias_database.dart';
import 'package:enchiladasapp/src/database/pantalla_database.dart';
import 'package:enchiladasapp/src/database/producto_database.dart';
import 'package:enchiladasapp/src/models/pantalla_model.dart';
import 'package:rxdart/subjects.dart';

class PantallaBloc {
  final pantallaDatabase = PantallaDatabase();
  final categoriasDatabase = CategoriasDatabase();
  final productosDatabase = ProductoDatabase();

  final _pantallasController = new BehaviorSubject<List<PantallaModel>>(); 

  Stream<List<PantallaModel>> get pantallasStream => _pantallasController.stream;

  dispose() {
    _pantallasController?.close();
  }

  void obtenerPantallas(String tipo) async {
    final List<PantallaModel> listFinal = [];
    final listPantallas = await pantallaDatabase.obtenerPantallas(tipo);

    for (int i = 0; i < listPantallas.length; i++) {
      final List<ItemPantalla> listItemPantalla = [];

      PantallaModel pantalla = PantallaModel();

      pantalla.idPantalla = listPantallas[i].idPantalla;
      pantalla.pantallaNombre = listPantallas[i].pantallaNombre;
      pantalla.pantallaOrden = listPantallas[i].pantallaOrden;
      pantalla.pantallaFoto = listPantallas[i].pantallaFoto;
      pantalla.pantallaEstado = listPantallas[i].pantallaEstado;
      pantalla.pantallCategoria = listPantallas[i].pantallCategoria;
      pantalla.pantallaTipo = listPantallas[i].pantallaTipo;

      final listaProductos = await productosDatabase.obtenerProductosPorCategoria(pantalla.pantallCategoria);

      final categoriaLista = await categoriasDatabase.consultarPorId(pantalla.pantallCategoria);

      if (listaProductos.length > 10) {
        for (int x = 0; x < 10; x++) {
          ItemPantalla item = ItemPantalla();

          item.idProducto = listaProductos[x].idProducto;
          item.idCategoria = listaProductos[x].idCategoria;
          item.nombreItem = listaProductos[x].productoNombre;
          item.fotoItem = listaProductos[x].productoFoto;
          item.productoDestacado = listaProductos[x].productoDestacado;
          item.numeroItem = x.toString();
          item.categoriaNombre = listPantallas[i].pantallaNombre;
          item.categoriaIcono =(categoriaLista.length>0)?categoriaLista[0].categoriaIcono:'';
          item.cantidadItems = listaProductos.length.toString();

          listItemPantalla.add(item);
        }
      } else {
        for (int x = 0; x < listaProductos.length; x++) {
          ItemPantalla item = ItemPantalla();

          item.idProducto = listaProductos[x].idProducto;
          item.idCategoria = listaProductos[x].idCategoria;
          item.nombreItem = listaProductos[x].productoNombre;
          item.fotoItem = listaProductos[x].productoFoto;
          item.categoriaNombre = listPantallas[i].pantallaNombre;
          item.categoriaIcono =(categoriaLista.length>0)?categoriaLista[0].categoriaIcono:'';
          item.productoDestacado = listaProductos[x].productoDestacado;
          item.numeroItem = x.toString();
          item.cantidadItems = listaProductos.length.toString();
          item.productoNuevo = listaProductos[x].productoNuevo;

          listItemPantalla.add(item);
        }
        //}
      }
      pantalla.items = listItemPantalla;

      listFinal.add(pantalla);
    }

    _pantallasController.sink.add(listFinal);
  }
}
