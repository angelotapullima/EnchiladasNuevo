import 'package:enchiladasapp/src/database/categorias_database.dart';
import 'package:enchiladasapp/src/database/pantalla_database.dart';
import 'package:enchiladasapp/src/database/producto_database.dart';
import 'package:enchiladasapp/src/database/puzzle_database.dart';
import 'package:enchiladasapp/src/models/pantalla_model.dart';
import 'package:rxdart/subjects.dart';

class PantallaBloc {
  final pantallaDatabase = PantallaDatabase();
  final categoriasDatabase = CategoriasDatabase();
  final puzzleDatabase = PuzzleDatabase();
  final productosDatabase = ProductoDatabase();

  final _pantallasController = new BehaviorSubject<List<PantallaModel>>();
  final _estadoMarketDesicion = new BehaviorSubject<bool>();
  final _estadoCafeDesicion = new BehaviorSubject<bool>();

  Stream<List<PantallaModel>> get pantallasStream =>_pantallasController.stream;
  Stream<bool> get estadoMarketStream => _estadoMarketDesicion.stream;
  Stream<bool> get estadoCafeStream => _estadoCafeDesicion.stream;

  dispose() {
    _pantallasController?.close();
    _estadoMarketDesicion?.close();
    _estadoCafeDesicion?.close();
  }

  void obtenerPantallas() async {
    var listFinal = List<PantallaModel>();
    final listPantallas = await pantallaDatabase.obtenerPantallas();

    for (int i = 0; i < listPantallas.length; i++) {
      var listItemPantalla = List<ItemPantalla>();

      PantallaModel pantalla = PantallaModel();

      pantalla.idPantalla = listPantallas[i].idPantalla;
      pantalla.pantallaNombre = listPantallas[i].pantallaNombre;
      pantalla.pantallaOrden = listPantallas[i].pantallaOrden;
      pantalla.pantallaFoto = listPantallas[i].pantallaFoto;
      pantalla.pantallaEstado = listPantallas[i].pantallaEstado;
      pantalla.pantallCategoria = listPantallas[i].pantallCategoria;
     

      if (pantalla.idPantalla == '1') {
        //Categorias

        var listaCategorias =
            await categoriasDatabase.obtenerCategoriasEnchiladas();

        if (listaCategorias.length > 10) {
          for (int x = 0; x < 10; x++) {
            ItemPantalla item = ItemPantalla();

            item.idCategoria = listaCategorias[x].idCategoria;
            item.nombreItem = listaCategorias[x].categoriaNombre;
            item.fotoItem = listaCategorias[x].categoriaFoto;
            item.numeroItem = listaCategorias[x].categoriaOrden;

            listItemPantalla.add(item);
          }
        } else {
          for (int x = 0; x < listaCategorias.length; x++) {
            ItemPantalla item = ItemPantalla();

            item.idCategoria = listaCategorias[x].idCategoria;
            item.nombreItem = listaCategorias[x].categoriaNombre;
            item.fotoItem = listaCategorias[x].categoriaFoto;
            item.numeroItem = x.toString();

            listItemPantalla.add(item);
          }
        }
      } else if (pantalla.idPantalla == '2') {
        //market

        final listaCategorias =
            await categoriasDatabase.obtenerCategoriasPorTipo('2');

        if (listaCategorias.length > 10) {
          for (int x = 0; x < 10; x++) {
            ItemPantalla item = ItemPantalla();

            item.idCategoria = listaCategorias[x].idCategoria;
            item.nombreItem = listaCategorias[x].categoriaNombre;
            item.fotoItem = listaCategorias[x].categoriaFoto;
            item.numeroItem = x.toString();

            listItemPantalla.add(item);
          }
        } else {
          for (int x = 0; x < listaCategorias.length; x++) {
            ItemPantalla item = ItemPantalla();

            item.idCategoria = listaCategorias[x].idCategoria;
            item.nombreItem = listaCategorias[x].categoriaNombre;
            item.fotoItem = listaCategorias[x].categoriaFoto;
            item.numeroItem = x.toString();

            listItemPantalla.add(item);
          }
        }
      } else if (pantalla.idPantalla == '3') {
        //puzzle

        final listaPuzzle = await puzzleDatabase
            .obtenerPuzzle(); //puzzle.obtenerCategoriasTodos();

        if (listaPuzzle.length > 10) {
          for (int x = 0; x < 10; x++) {
            ItemPantalla item = ItemPantalla();

            item.nombreItem = listaPuzzle[x].imagenSubida;
            item.fotoItem = listaPuzzle[x].imagenRuta;
            item.numeroItem = x.toString();

            listItemPantalla.add(item);
          }
        } else {
          for (int x = 0; x < listaPuzzle.length; x++) {
            ItemPantalla item = ItemPantalla();

            item.nombreItem = listaPuzzle[x].imagenSubida;
            item.fotoItem = listaPuzzle[x].imagenRuta;

            listItemPantalla.add(item);
          }
        }
      } else {
        //resto
 
        final listaProductos = await productosDatabase
            .obtenerProductosPorCategoriaDelivery(pantalla.pantallCategoria);

        if (listaProductos.length > 10) {
          for (int x = 0; x < 10; x++) {
            ItemPantalla item = ItemPantalla();

            item.idProducto = listaProductos[x].idProducto;
            item.idCategoria = listaProductos[x].idCategoria;
            item.nombreItem = listaProductos[x].productoNombre;
            item.fotoItem = listaProductos[x].productoFoto;
            item.productoDestacado = listaProductos[x].productoDestacado;
            item.numeroItem = x.toString();
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
            item.productoDestacado = listaProductos[x].productoDestacado;
            item.numeroItem = x.toString();
            item.cantidadItems = listaProductos.length.toString();
            item.productoNuevo = listaProductos[x].productoNuevo;

            listItemPantalla.add(item);
          }
        }
      }
      pantalla.items = listItemPantalla;

      listFinal.add(pantalla);
    }

    _pantallasController.sink.add(listFinal);
  }

  void estadoPantallaMarket() async {
    bool estado = false;
    var estadoMarket = await pantallaDatabase.obtenerPantallaPorId('2');

    if (estadoMarket.length > 0) {
      if (estadoMarket[0].pantallaEstado == '0') {
        estado = false;
      } else {
        estado = true;
      }
    }

    _estadoMarketDesicion.sink.add(estado);
  }

  void estadoPantallaCafe() async {
    bool estado = false;
    var estadoCafe = await pantallaDatabase.obtenerPantallaPorId('4');

    if (estadoCafe.length > 0) {
      if (estadoCafe[0].pantallaEstado == '0') {
        estado = false;
      } else {
        estado = true;
      }
    }

    _estadoCafeDesicion.sink.add(estado);
  }
}



class MostarInicioDelivery{


  bool market;
  bool cafe;

  MostarInicioDelivery({

    this.market,
    this.cafe
  });
}