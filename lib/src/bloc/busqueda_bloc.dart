import 'package:enchiladasapp/src/database/categorias_database.dart';
import 'package:enchiladasapp/src/database/producto_database.dart';
import 'package:enchiladasapp/src/models/productos_model.dart';
import 'package:rxdart/rxdart.dart';

class BusquedaGeneralTab {
  final productoDatabase = ProductoDatabase();
  final categoriaDatabase = CategoriasDatabase();

  //instancia que captura el ultimo elemento agregado al controlador
  final selectTab = BehaviorSubject<int>();
  final cantidadEnchiladas = BehaviorSubject<int>();
  final cantidadCafe = BehaviorSubject<int>();
  final cantidadVar = BehaviorSubject<int>();
  final cantidadEnchiladasDelivery = BehaviorSubject<int>();
  final cantidadCafeDelivery = BehaviorSubject<int>();
  final cantidadVarDelivery = BehaviorSubject<int>();

  final _productosQueryEnchiladasController = new BehaviorSubject<List<ProductosData>>();
  final _productosQueryCafeController = new BehaviorSubject<List<ProductosData>>();
  final _productosQueryVarController = new BehaviorSubject<List<ProductosData>>();
  final _productosQueryEnchiladasDeliveryController = new BehaviorSubject<List<ProductosData>>();
  final _productosQueryCafeDeliveryController = new BehaviorSubject<List<ProductosData>>();
  final _productosQueryVarDeliveryController = new BehaviorSubject<List<ProductosData>>();

  Stream<int> get selectPageStream => selectTab.stream;
  Stream<int> get cantidadEnchiladasStream => cantidadEnchiladas.stream;
  Stream<int> get cantidadCafeStream => cantidadCafe.stream;
  Stream<int> get cantidadVarStream => cantidadVar.stream;
  Stream<int> get cantidadEnchiladasDeliveryStream => cantidadEnchiladasDelivery.stream;
  Stream<int> get cantidadCafeDeliveryStream => cantidadCafeDelivery.stream;
  Stream<int> get cantidadVarDeliveryStream => cantidadVarDelivery.stream;

  Stream<List<ProductosData>> get productosQueryEnchiladasStream => _productosQueryEnchiladasController.stream;
  Stream<List<ProductosData>> get productosQueryCafeStream => _productosQueryCafeController.stream;
  Stream<List<ProductosData>> get productosQueryVarStream => _productosQueryVarController.stream;
  Stream<List<ProductosData>> get productosQueryEnchiladasDeliveryStream => _productosQueryEnchiladasDeliveryController.stream;
  Stream<List<ProductosData>> get productosQueryCafeDeliveryStream => _productosQueryCafeDeliveryController.stream;
  Stream<List<ProductosData>> get productosQueryVarDeliveryStream => _productosQueryVarDeliveryController.stream;

  Function(int) get changePage => selectTab.sink.add;
  Function(int) get changecantidadEnchiladas => cantidadEnchiladas.sink.add;
  Function(int) get changecantidadCafe => cantidadCafe.sink.add;
  Function(int) get changecantidadVar => cantidadVar.sink.add;
  Function(int) get changecantidadEnchiladasDelivery => cantidadEnchiladasDelivery.sink.add;
  Function(int) get changecantidadCafeDelivery => cantidadCafeDelivery.sink.add;
  Function(int) get changecantidadVarDelivery => cantidadVarDelivery.sink.add;

  int get page => selectTab.value;

  dispose() {
    _productosQueryEnchiladasController?.close();
    _productosQueryCafeController?.close();
    _productosQueryVarController?.close();
    _productosQueryEnchiladasDeliveryController?.close();
    _productosQueryCafeDeliveryController?.close();
    _productosQueryVarDeliveryController?.close();
    selectTab?.close();
    cantidadEnchiladas?.close();
    cantidadCafe?.close();
    cantidadVar?.close();
    cantidadEnchiladasDelivery?.close();
    cantidadCafeDelivery?.close();
    cantidadVarDelivery?.close();
  }

  void queryEnchiladas(String query, String tipo) async {
    if (query.length > 0) {
      final List<ProductosData> listGeneral = [];
      final listProductos = await productoDatabase.consultarPorQuery(query, tipo);

      print('cantidad ${listProductos.length}');

      for (var x = 0; x < listProductos.length; x++) {
        //final listCategorias = await categoriaDatabase.consultarPorId(listProductos[x].idCategoria);

        /* if (listCategorias.length > 0) {
          
        } */

        ProductosData productosData = ProductosData();
        productosData.idProducto = listProductos[x].idProducto;
        //productosData.idCategoria = listCategorias[0].categoriaNombre;
        productosData.productoNombre = listProductos[x].productoNombre;
        productosData.productoFoto = listProductos[x].productoFoto;
        productosData.productoOrden = listProductos[x].productoOrden;
        productosData.productoPrecio = listProductos[x].productoPrecio;
        productosData.productoCarta = listProductos[x].productoCarta;
        productosData.productoDelivery = listProductos[x].productoDelivery;
        //productosData.sonido = listCategorias[0].categoriaSonido;
        productosData.productoUnidad = listProductos[x].productoUnidad;
        productosData.productoEstado = listProductos[x].productoEstado;
        productosData.productoDestacado = listProductos[x].productoDestacado;
        productosData.productoEstadoDestacado = listProductos[x].productoEstadoDestacado;
        productosData.productoTupper = listProductos[x].productoTupper;
        productosData.productoNuevo = listProductos[x].productoNuevo;
        productosData.numeroitem = x.toString();
        productosData.categoriaTipo =listProductos[x].categoriaTipo;
        productosData.categoriaTipo2 =listProductos[x].categoriaTipo2;
        productosData.numeroitem = x.toString();
        productosData.validadoDelivery =  listProductos[x].validadoDelivery;
        productosData.validadoLocal =  listProductos[x].validadoLocal;
        productosData.productoDescripcion = listProductos[x].productoDescripcion;
        productosData.productoComentario = listProductos[x].productoComentario;
        productosData.productoFavorito = listProductos[x].productoFavorito;
        listGeneral.add(productosData);
      }

      cantidadEnchiladas.sink.add(listGeneral.length);
      print('cantidad ${listGeneral.length}');
      _productosQueryEnchiladasController.sink.add(listGeneral);
    } else {
      cantidadEnchiladas.sink.add(20000);
      _productosQueryEnchiladasController.sink.add([]);
    }
  }

  void queryCafe(String query, String tipo) async {
    if (query.length > 0) {
      final List<ProductosData> listGeneral = [];
      final listProductos = await productoDatabase.consultarPorQuery(query, tipo);

      for (var x = 0; x < listProductos.length; x++) {
        ProductosData productosData = ProductosData();
        productosData.idProducto = listProductos[x].idProducto;
        productosData.productoNombre = listProductos[x].productoNombre;
        productosData.productoFoto = listProductos[x].productoFoto;
        productosData.productoOrden = listProductos[x].productoOrden;
        productosData.productoPrecio = listProductos[x].productoPrecio;
        productosData.productoCarta = listProductos[x].productoCarta;
        productosData.productoDelivery = listProductos[x].productoDelivery;
        productosData.productoUnidad = listProductos[x].productoUnidad;
        productosData.productoEstado = listProductos[x].productoEstado;
        productosData.productoDestacado = listProductos[x].productoDestacado;
        productosData.productoEstadoDestacado = listProductos[x].productoEstadoDestacado;
        productosData.productoTupper = listProductos[x].productoTupper;
        productosData.productoNuevo = listProductos[x].productoNuevo;
        productosData.numeroitem = x.toString();
        productosData.categoriaTipo =listProductos[x].categoriaTipo;
        productosData.categoriaTipo2 =listProductos[x].categoriaTipo2;
        productosData.validadoDelivery =  listProductos[x].validadoDelivery;
        productosData.validadoLocal =  listProductos[x].validadoLocal;
        productosData.productoDescripcion = listProductos[x].productoDescripcion;
        productosData.productoComentario = listProductos[x].productoComentario;
        productosData.productoFavorito = listProductos[x].productoFavorito;
        listGeneral.add(productosData);
      }

      cantidadCafe.sink.add(listGeneral.length);
      _productosQueryCafeController.sink.add(listGeneral);
    } else {
      cantidadCafe.sink.add(20000);
      _productosQueryCafeController.sink.add([]);
    }
  }

  void queryVar(String query, String tipo) async {
    if (query.length > 0) {
      final List<ProductosData> listGeneral = [];
      final listProductos = await productoDatabase.consultarPorQuery(query, tipo);

      for (var x = 0; x < listProductos.length; x++) {
        ProductosData productosData = ProductosData();
        productosData.idProducto = listProductos[x].idProducto;
        productosData.productoNombre = listProductos[x].productoNombre;
        productosData.productoFoto = listProductos[x].productoFoto;
        productosData.productoOrden = listProductos[x].productoOrden;
        productosData.productoPrecio = listProductos[x].productoPrecio;
        productosData.productoCarta = listProductos[x].productoCarta;
        productosData.productoDelivery = listProductos[x].productoDelivery;
        productosData.productoUnidad = listProductos[x].productoUnidad;
        productosData.productoEstado = listProductos[x].productoEstado;
        productosData.productoDestacado = listProductos[x].productoDestacado;
        productosData.productoEstadoDestacado = listProductos[x].productoEstadoDestacado;
        productosData.productoTupper = listProductos[x].productoTupper;
        productosData.productoNuevo = listProductos[x].productoNuevo;
        productosData.numeroitem = x.toString();
        productosData.categoriaTipo =listProductos[x].categoriaTipo;
        productosData.categoriaTipo2 =listProductos[x].categoriaTipo2;
        productosData.validadoDelivery =  listProductos[x].validadoDelivery;
        productosData.validadoLocal =  listProductos[x].validadoLocal;
        productosData.productoDescripcion = listProductos[x].productoDescripcion;
        productosData.productoComentario = listProductos[x].productoComentario;
        productosData.productoFavorito = listProductos[x].productoFavorito;
        listGeneral.add(productosData);
      }
      cantidadVar.sink.add(listGeneral.length);
      _productosQueryVarController.sink.add(listGeneral);
    } else {
      cantidadVar.sink.add(20000);
      _productosQueryVarController.sink.add([]);
    }
  }

  void queryEnchiladasDelivery(String query, String tipo) async {
    if (query.length > 0) {
      final List<ProductosData> listGeneral = [];
      final listProductos = await productoDatabase.consultarPorQuery(query, tipo);

      for (var x = 0; x < listProductos.length; x++) {
        ProductosData productosData = ProductosData();
        productosData.idProducto = listProductos[x].idProducto;
        productosData.productoNombre = listProductos[x].productoNombre;
        productosData.productoFoto = listProductos[x].productoFoto;
        productosData.productoOrden = listProductos[x].productoOrden;
        productosData.productoPrecio = listProductos[x].productoPrecio;
        productosData.productoCarta = listProductos[x].productoCarta;
        productosData.productoDelivery = listProductos[x].productoDelivery;
        productosData.productoUnidad = listProductos[x].productoUnidad;
        productosData.productoEstado = listProductos[x].productoEstado;
        productosData.productoDestacado = listProductos[x].productoDestacado;
        productosData.productoEstadoDestacado = listProductos[x].productoEstadoDestacado;
        productosData.productoTupper = listProductos[x].productoTupper;
        productosData.productoNuevo = listProductos[x].productoNuevo;
        productosData.numeroitem = x.toString();
        productosData.categoriaTipo =listProductos[x].categoriaTipo;
        productosData.categoriaTipo2 =listProductos[x].categoriaTipo2;
        productosData.validadoDelivery =  listProductos[x].validadoDelivery;
        productosData.validadoLocal =  listProductos[x].validadoLocal;
        productosData.productoDescripcion = listProductos[x].productoDescripcion;
        productosData.productoComentario = listProductos[x].productoComentario;
        productosData.productoFavorito = listProductos[x].productoFavorito;
        listGeneral.add(productosData);
      }
      cantidadEnchiladasDelivery.sink.add(listGeneral.length);
      _productosQueryEnchiladasDeliveryController.sink.add(listGeneral);
    } else {
      cantidadEnchiladasDelivery.sink.add(20000);
      _productosQueryEnchiladasDeliveryController.sink.add([]);
    }
  }

  void queryCafeDelivery(String query, String tipo) async {
    if (query.length > 0) {
      final List<ProductosData> listGeneral = [];
      final listProductos = await productoDatabase.consultarPorQuery(query, tipo);

      for (var x = 0; x < listProductos.length; x++) {
        ProductosData productosData = ProductosData();
        productosData.idProducto = listProductos[x].idProducto;
        productosData.productoNombre = listProductos[x].productoNombre;
        productosData.productoFoto = listProductos[x].productoFoto;
        productosData.productoOrden = listProductos[x].productoOrden;
        productosData.productoPrecio = listProductos[x].productoPrecio;
        productosData.productoCarta = listProductos[x].productoCarta;
        productosData.productoDelivery = listProductos[x].productoDelivery;
        productosData.productoUnidad = listProductos[x].productoUnidad;
        productosData.productoEstado = listProductos[x].productoEstado;
        productosData.productoDestacado = listProductos[x].productoDestacado;
        productosData.productoEstadoDestacado = listProductos[x].productoEstadoDestacado;
        productosData.productoTupper = listProductos[x].productoTupper;
        productosData.validadoDelivery =  listProductos[x].validadoDelivery;
        productosData.validadoLocal =  listProductos[x].validadoLocal;
        productosData.productoNuevo = listProductos[x].productoNuevo;
        productosData.numeroitem = x.toString();
        productosData.categoriaTipo =listProductos[x].categoriaTipo;
        productosData.categoriaTipo2 =listProductos[x].categoriaTipo2;
        productosData.productoDescripcion = listProductos[x].productoDescripcion;
        productosData.productoComentario = listProductos[x].productoComentario;
        productosData.productoFavorito = listProductos[x].productoFavorito;
        listGeneral.add(productosData);
      }

      cantidadCafeDelivery.sink.add(listGeneral.length);
      _productosQueryCafeDeliveryController.sink.add(listGeneral);
    } else {
      cantidadCafeDelivery.sink.add(20000);
      _productosQueryCafeDeliveryController.sink.add([]);
    }
  }

  void queryVarDelivery(String query, String tipo) async {
    if (query.length > 0) {
      final List<ProductosData> listGeneral = [];
      final listProductos = await productoDatabase.consultarPorQuery(query, tipo);

      for (var x = 0; x < listProductos.length; x++) {
        ProductosData productosData = ProductosData();
        productosData.idProducto = listProductos[x].idProducto;
        productosData.productoNombre = listProductos[x].productoNombre;
        productosData.productoFoto = listProductos[x].productoFoto;
        productosData.productoOrden = listProductos[x].productoOrden;
        productosData.productoPrecio = listProductos[x].productoPrecio;
        productosData.productoCarta = listProductos[x].productoCarta;
        productosData.productoDelivery = listProductos[x].productoDelivery;
        productosData.productoUnidad = listProductos[x].productoUnidad;
        productosData.productoEstado = listProductos[x].productoEstado;
        productosData.productoDestacado = listProductos[x].productoDestacado;
        productosData.productoEstadoDestacado = listProductos[x].productoEstadoDestacado;
        productosData.productoTupper = listProductos[x].productoTupper;
        productosData.productoNuevo = listProductos[x].productoNuevo;
        productosData.numeroitem = x.toString();
        productosData.categoriaTipo =listProductos[x].categoriaTipo;
        productosData.categoriaTipo2 =listProductos[x].categoriaTipo2;
        productosData.validadoDelivery =  listProductos[x].validadoDelivery;
        productosData.validadoLocal =  listProductos[x].validadoLocal;
        productosData.productoDescripcion = listProductos[x].productoDescripcion;
        productosData.productoComentario = listProductos[x].productoComentario;
        productosData.productoFavorito = listProductos[x].productoFavorito;
        listGeneral.add(productosData);
      }

      cantidadVarDelivery.sink.add(listGeneral.length);
      _productosQueryVarDeliveryController.sink.add(listGeneral);
    } else {
      cantidadVarDelivery.sink.add(20000);
      _productosQueryVarDeliveryController.sink.add([]);
    }
  }

  void resetearCantidades() async {
    cantidadEnchiladas.sink.add(20000);
    cantidadCafe.sink.add(20000);
    cantidadVar.sink.add(20000);
    cantidadEnchiladasDelivery.sink.add(20000);
    cantidadCafeDelivery.sink.add(20000);
    cantidadVarDelivery.sink.add(20000);

    _productosQueryEnchiladasController.sink.add([]);
    _productosQueryEnchiladasDeliveryController.sink.add([]);
    _productosQueryCafeController.sink.add([]);
    _productosQueryCafeDeliveryController.sink.add([]);
    _productosQueryVarController.sink.add([]);
    _productosQueryVarDeliveryController.sink.add([]);
  }
}
