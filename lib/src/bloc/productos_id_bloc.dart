import 'package:enchiladasapp/src/api/categorias_api.dart';
import 'package:enchiladasapp/src/database/categorias_database.dart';
import 'package:enchiladasapp/src/database/producto_database.dart';
import 'package:enchiladasapp/src/database/temporizador_database.dart';
import 'package:enchiladasapp/src/models/categoria_model.dart';
import 'package:enchiladasapp/src/models/productos_model.dart';
import 'package:enchiladasapp/src/models/temporizador_model.dart';
import 'package:enchiladasapp/src/models/validar_producto.dart';
import 'package:rxdart/rxdart.dart';

class ProductosBloc {
  final categoriasApi = CategoriasApi();
  final productoDatabase = ProductoDatabase();
  final categoriaDatabase = CategoriasDatabase();
  final temporizadorDatabase = TemporizadorDatabase();

  final _productosEnchiladasController =
      new BehaviorSubject<List<ProductosData>>();
  final _productosMarketController = new BehaviorSubject<List<ProductosData>>();
  final _productosIDController = new BehaviorSubject<List<ProductosData>>();
  final _productosQueryController = new BehaviorSubject<List<ProductosData>>();
  final _categoriaProductosController =
      new BehaviorSubject<List<CategoriaData>>();
  final _cargandoProductosController = BehaviorSubject<bool>();

  final _categoriaTemporizador = new BehaviorSubject<ValidarProducto>();

  Stream<List<ProductosData>> get productosEnchiladasStream =>
      _productosEnchiladasController.stream;
  Stream<List<ProductosData>> get productosMarketStream =>
      _productosMarketController.stream;
  Stream<List<ProductosData>> get productosIdStream =>
      _productosIDController.stream;
  Stream<List<ProductosData>> get productosQueryStream =>
      _productosQueryController.stream;

  Stream<List<CategoriaData>> get categoriasProductos =>
      _categoriaProductosController.stream;
  Stream<bool> get cargandoProductosStream =>
      _cargandoProductosController.stream;

  Stream<ValidarProducto> get categoriaTemporizador =>
      _categoriaTemporizador.stream;

  dispose() {
    _productosEnchiladasController?.close();
    _productosIDController?.close();
    _productosQueryController?.close();
    _cargandoProductosController?.close();
    _productosMarketController?.close();
    _categoriaProductosController?.close();
    _categoriaTemporizador?.close();
  }

  void cargandoProductosFalse() {
    _cargandoProductosController.sink.add(false);
  }

  void obtenerProductosEnchiladasPorCategoria(String categoria) async {
    _cargandoProductosController.sink.add(true);

    final listGeneral = List<ProductosData>();
    final listProductos =
        await productoDatabase.obtenerProductosPorCategoria('$categoria');

    for (var x = 0; x < listProductos.length; x++) {
      final listCategorias =
          await categoriaDatabase.consultarPorId(listProductos[x].idCategoria);
      ProductosData productosData = ProductosData();
      productosData.idProducto = listProductos[x].idProducto;
      productosData.idCategoria = listProductos[x].idCategoria;
      productosData.productoNombre = listProductos[x].productoNombre;
      productosData.productoFoto = listProductos[x].productoFoto;
      productosData.productoPrecio = listProductos[x].productoPrecio;
      productosData.productoUnidad = listProductos[x].productoUnidad;
      productosData.productoEstado = listProductos[x].productoEstado;
      productosData.numeroitem = x.toString();
      productosData.productoDescripcion = listProductos[x].productoDescripcion;
      productosData.productoComentario = listProductos[x].productoComentario;
      productosData.sonido = listCategorias[0].categoriaSonido;
      listGeneral.add(productosData);
    }
    _productosEnchiladasController.sink.add(listGeneral);

    _cargandoProductosController.sink.add(false);
  }

  void obtenerProductosMarketPorCategoria(String categoria) async {
    _cargandoProductosController.sink.add(true);
    _productosMarketController.sink
        .add(await productoDatabase.obtenerProductosPorCategoria('$categoria'));

    /* _productosMarketController.sink.add(await categoriasApi.obtenerProductoCategoria('$categoria'));
    _productosMarketController.sink.add(await productoDatabase.obtenerProductosPorCategoria('$categoria')); */
    _cargandoProductosController.sink.add(false);
  }

  void obtenerProductoPorId(String id) async {
    _cargandoProductosController.sink.add(true);
    _productosIDController.sink
        .add(await productoDatabase.consultarPorId('$id'));
    _cargandoProductosController.sink.add(false);
  }

  void obtenerProductoPorQuery(String query) async {
    final listGeneral = List<ProductosData>();
    final listProductos = await productoDatabase.consultarPorQuery('$query');

    for (var x = 0; x < listProductos.length; x++) {
      final listCategorias =
          await categoriaDatabase.consultarPorId(listProductos[x].idCategoria);

      if (listCategorias.length > 0) {
        ProductosData productosData = ProductosData();
        productosData.idProducto = listProductos[x].idProducto;
        productosData.idCategoria = listProductos[x].idCategoria;
        productosData.productoNombre = listProductos[x].productoNombre;
        productosData.productoFoto = listProductos[x].productoFoto;
        productosData.productoPrecio = listProductos[x].productoPrecio;
        productosData.productoUnidad = listProductos[x].productoUnidad;
        productosData.productoEstado = listProductos[x].productoEstado;
        productosData.numeroitem = x.toString();
        productosData.productoDescripcion =
            listProductos[x].productoDescripcion;
        productosData.productoComentario = listProductos[x].productoComentario;
        productosData.sonido = listCategorias[0].categoriaSonido;
        listGeneral.add(productosData);
      }
    }
    _productosQueryController.sink.add(listGeneral);
    //_productosQueryController.sink.add(await productoDatabase.consultarPorQuery('$query'));
  }

  void cargarCategoriaProducto(String idCategoria) async {
    var listFinal = List<CategoriaData>();
    var listProductos = List<ProductosData>();
    final listCategorias = await categoriaDatabase.consultarPorId(idCategoria);
    final listProductosPorCategoria =
        await productoDatabase.obtenerProductosPorCategoria(idCategoria);

    CategoriaData categoria = CategoriaData();

    categoria.categoriaNombre = listCategorias[0].categoriaNombre;
    categoria.categoriaBanner = listCategorias[0].categoriaBanner;

    if (listProductosPorCategoria.length > 0) {
      for (int i = 0; i < listProductosPorCategoria.length; i++) {
        ProductosData productos = ProductosData();
        productos.idProducto = listProductosPorCategoria[i].idProducto;
        productos.productoNombre = listProductosPorCategoria[i].productoNombre;
        productos.productoDescripcion =
            listProductosPorCategoria[i].productoDescripcion;
        productos.idCategoria = listProductosPorCategoria[i].idCategoria;
        productos.productoFoto = listProductosPorCategoria[i].productoFoto;
        productos.productoUnidad = listProductosPorCategoria[i].productoUnidad;
        productos.productoEstado = listProductosPorCategoria[i].productoEstado;
        productos.productoFavorito =
            listProductosPorCategoria[i].productoFavorito;
        productos.idCategoria = listProductosPorCategoria[i].idCategoria;
        productos.productoPrecio = listProductosPorCategoria[i].productoPrecio;

        listProductos.add(productos);
      }
    }

    categoria.productos = listProductos;
    listFinal.add(categoria);

    _categoriaProductosController.sink.add(listFinal);
  }

  void verificarDisponibilidad(String idProducto) async {
    var date = DateTime.now();

    final producto = await productoDatabase.consultarPorId(idProducto);
    final temporizadorList = await temporizadorDatabase
        .obtenerTemporizadorPorIdCategoria(producto[0].idCategoria);

    if (temporizadorList[0].temporizadorTipo == '1') {
      //1 cualquier día, en un rango de horas específicas
      _categoriaTemporizador.sink
          .add(_cualquierDiaEnRangoDeHorasEspecificas(date, temporizadorList));
    } else if (temporizadorList[0].temporizadorTipo == '2') {
      //2 en días específicos de la semana

      diasEspecificosDeLaSemana(date, temporizadorList);
    } else if (temporizadorList[0].temporizadorTipo == '3') {
      //3 en días y horas específicos de la semana

      _enDiasYHorasEspecificosDeLaSemana(date, temporizadorList);
    } else if (temporizadorList[0].temporizadorTipo == '4') {
      //4 en un rango de fechas específicas

      _ragoDeFechadEspecificas(temporizadorList, date);
    } else if (temporizadorList[0].temporizadorTipo == '5') {
      //5 en un rango de fechas en específico en una hora específica

      _categoriaTemporizador.sink
          .add(_rangoFechasYHorasEspecificas(temporizadorList, date));
    } else {
      //siempre disponible

      ValidarProducto validarProducto = ValidarProducto();
      validarProducto.valor = true;
      validarProducto.mensaje = temporizadorList[0].temporizadorMensaje;
      _categoriaTemporizador.sink.add(validarProducto);
    }
  }

  ValidarProducto _rangoFechasYHorasEspecificas(
      List<TemporizadorModel> temporizadorList, DateTime date) {
    var fechaInicio = temporizadorList[0].temporizadorFechainicio;
    var fechaFin = temporizadorList[0].temporizadorFechafin;

    DateTime fechaInicioPromo = DateTime.parse(fechaInicio);
    DateTime fechaFinPromo = DateTime.parse(fechaFin);
    fechaFinPromo = fechaFinPromo.add(new Duration(days: 1));

    if (date.isAfter(fechaInicioPromo)) {
      if (date.isBefore(fechaFinPromo)) {
        return _cualquierDiaEnRangoDeHorasEspecificas(date, temporizadorList);
      } else {
        ValidarProducto validarProducto = ValidarProducto();
        validarProducto.valor = false;
        validarProducto.mensaje = temporizadorList[0].temporizadorMensaje;
        return validarProducto;
      }
    } else {
      ValidarProducto validarProducto = ValidarProducto();
      validarProducto.valor = false;
      validarProducto.mensaje = temporizadorList[0].temporizadorMensaje;
      return validarProducto;
    }
  }

  void _ragoDeFechadEspecificas(
      List<TemporizadorModel> temporizadorList, DateTime date) {
    var fechaInicio = temporizadorList[0].temporizadorFechainicio;
    var fechaFin = temporizadorList[0].temporizadorFechafin;

    DateTime fechaInicioPromo = DateTime.parse(fechaInicio);
    DateTime fechaFinPromo = DateTime.parse(fechaFin);

    fechaFinPromo = fechaFinPromo.add(new Duration(days: 1));

    if (date.isAfter(fechaInicioPromo)) {
      if (date.isBefore(fechaFinPromo)) {
        ValidarProducto validarProducto = ValidarProducto();
        validarProducto.valor = true;
        validarProducto.mensaje = temporizadorList[0].temporizadorMensaje;
        _categoriaTemporizador.sink.add(validarProducto);
      } else {
        ValidarProducto validarProducto = ValidarProducto();
        validarProducto.valor = false;
        validarProducto.mensaje = temporizadorList[0].temporizadorMensaje;
        _categoriaTemporizador.sink.add(validarProducto);
      }
    } else {
      ValidarProducto validarProducto = ValidarProducto();
      validarProducto.valor = false;
      validarProducto.mensaje = temporizadorList[0].temporizadorMensaje;
      _categoriaTemporizador.sink.add(validarProducto);
    }
  }

  void _enDiasYHorasEspecificosDeLaSemana(
      DateTime date, List<TemporizadorModel> temporizadorList) {
    var week = date.weekday;

    ValidarProducto validarProducto = ValidarProducto();
    validarProducto.valor = false;
    validarProducto.mensaje = temporizadorList[0].temporizadorMensaje;

    if (week == 1) {
      if (temporizadorList[0].temporizadorLunes == '1') {
        _categoriaTemporizador.sink.add(
            _cualquierDiaEnRangoDeHorasEspecificas(date, temporizadorList));
      } else {
        _categoriaTemporizador.sink.add(validarProducto);
      }
    } else if (week == 2) {
      if (temporizadorList[0].temporizadorMartes == '1') {
        _categoriaTemporizador.sink.add(
            _cualquierDiaEnRangoDeHorasEspecificas(date, temporizadorList));
      } else {
        _categoriaTemporizador.sink.add(validarProducto);
      }
    } else if (week == 3) {
      if (temporizadorList[0].temporizadorMiercoles == '1') {
        _categoriaTemporizador.sink.add(
            _cualquierDiaEnRangoDeHorasEspecificas(date, temporizadorList));
      } else {
        _categoriaTemporizador.sink.add(validarProducto);
      }
    } else if (week == 4) {
      if (temporizadorList[0].temporizadorJueves == '1') {
        _categoriaTemporizador.sink.add(
            _cualquierDiaEnRangoDeHorasEspecificas(date, temporizadorList));
      } else {
        _categoriaTemporizador.sink.add(validarProducto);
      }
    } else if (week == 5) {
      if (temporizadorList[0].temporizadorViernes == '1') {
        _categoriaTemporizador.sink.add(
            _cualquierDiaEnRangoDeHorasEspecificas(date, temporizadorList));
      } else {
        _categoriaTemporizador.sink.add(validarProducto);
      }
    } else if (week == 6) {
      if (temporizadorList[0].temporizadorSabado == '1') {
        _categoriaTemporizador.sink.add(
            _cualquierDiaEnRangoDeHorasEspecificas(date, temporizadorList));
      } else {
        _categoriaTemporizador.sink.add(validarProducto);
      }
    } else if (week == 7) {
      if (temporizadorList[0].temporizadorDomingo == '1') {
        _categoriaTemporizador.sink.add(
            _cualquierDiaEnRangoDeHorasEspecificas(date, temporizadorList));
      } else {
        _categoriaTemporizador.sink.add(validarProducto);
      }
    }
  }

  ValidarProducto _cualquierDiaEnRangoDeHorasEspecificas(
      DateTime date, List<TemporizadorModel> temporizadorList) {
    var horaInicio =
        '${date.year.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')} ${temporizadorList[0].temporizadorHorainicio}';
    var horaFin =
        '${date.year.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')} ${temporizadorList[0].temporizadorHorafin}';

    DateTime horaInicioDate = DateTime.parse(horaInicio);
    DateTime horaFinDate = DateTime.parse(horaFin);

    if (date.isAfter(horaInicioDate)) {
      if (date.isBefore(horaFinDate)) {
        ValidarProducto validarProducto = ValidarProducto();
        validarProducto.valor = true;
        validarProducto.mensaje = temporizadorList[0].temporizadorMensaje;

        return validarProducto;
      } else {
        ValidarProducto validarProducto = ValidarProducto();
        validarProducto.valor = false;
        validarProducto.mensaje = temporizadorList[0].temporizadorMensaje;
        return validarProducto;
      }
    } else {
      ValidarProducto validarProducto = ValidarProducto();
      validarProducto.valor = false;
      validarProducto.mensaje = temporizadorList[0].temporizadorMensaje;
      return validarProducto;
    }
  }

  void diasEspecificosDeLaSemana(
      DateTime date, List<TemporizadorModel> temporizadorList) {
    var week = date.weekday;

    ValidarProducto validarProducto = ValidarProducto();
    validarProducto.valor = false;
    validarProducto.mensaje = temporizadorList[0].temporizadorMensaje;

    if (week == 1) {
      if (temporizadorList[0].temporizadorLunes == '1') {
        ValidarProducto validarProducto = ValidarProducto();
        validarProducto.valor = true;
        validarProducto.mensaje = temporizadorList[0].temporizadorMensaje;
        _categoriaTemporizador.sink.add(validarProducto);
      } else {
        _categoriaTemporizador.sink.add(validarProducto);
      }
    } else if (week == 2) {
      if (temporizadorList[0].temporizadorMartes == '1') {
        ValidarProducto validarProducto = ValidarProducto();
        validarProducto.valor = true;
        validarProducto.mensaje = temporizadorList[0].temporizadorMensaje;
        _categoriaTemporizador.sink.add(validarProducto);
      } else {
        _categoriaTemporizador.sink.add(validarProducto);
      }
    } else if (week == 3) {
      if (temporizadorList[0].temporizadorMiercoles == '1') {
        ValidarProducto validarProducto = ValidarProducto();
        validarProducto.valor = true;
        validarProducto.mensaje = temporizadorList[0].temporizadorMensaje;
        _categoriaTemporizador.sink.add(validarProducto);
      } else {
        _categoriaTemporizador.sink.add(validarProducto);
      }
    } else if (week == 4) {
      if (temporizadorList[0].temporizadorJueves == '1') {
        ValidarProducto validarProducto = ValidarProducto();
        validarProducto.valor = true;
        validarProducto.mensaje = temporizadorList[0].temporizadorMensaje;
        _categoriaTemporizador.sink.add(validarProducto);
      } else {
        _categoriaTemporizador.sink.add(validarProducto);
      }
    } else if (week == 5) {
      if (temporizadorList[0].temporizadorViernes == '1') {
        ValidarProducto validarProducto = ValidarProducto();
        validarProducto.valor = true;
        validarProducto.mensaje = temporizadorList[0].temporizadorMensaje;
        _categoriaTemporizador.sink.add(validarProducto);
      } else {
        _categoriaTemporizador.sink.add(validarProducto);
      }
    } else if (week == 6) {
      if (temporizadorList[0].temporizadorSabado == '1') {
        ValidarProducto validarProducto = ValidarProducto();
        validarProducto.valor = true;
        validarProducto.mensaje = temporizadorList[0].temporizadorMensaje;
        _categoriaTemporizador.sink.add(validarProducto);
      } else {
        _categoriaTemporizador.sink.add(validarProducto);
      }
    } else if (week == 7) {
      if (temporizadorList[0].temporizadorDomingo == '1') {
        ValidarProducto validarProducto = ValidarProducto();
        validarProducto.valor = true;
        validarProducto.mensaje = temporizadorList[0].temporizadorMensaje;
        _categoriaTemporizador.sink.add(validarProducto);
      } else {
        _categoriaTemporizador.sink.add(validarProducto);
      }
    }
  }
}
