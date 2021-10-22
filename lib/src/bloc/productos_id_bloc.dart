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

  final _productosEnchiladasController = new BehaviorSubject<List<ProductosData>>();
  final _productosIDController = new BehaviorSubject<List<ProductosData>>();
  final _categoriaProductosController = new BehaviorSubject<List<CategoriaData>>();
  final _cargandoProductosController = BehaviorSubject<bool>();

  final _categoriaTemporizador = new BehaviorSubject<ValidarProducto>();

  Stream<List<ProductosData>> get productosEnchiladasStream => _productosEnchiladasController.stream;
  Stream<List<ProductosData>> get productosIdStream => _productosIDController.stream;

  Stream<List<CategoriaData>> get categoriasProductos => _categoriaProductosController.stream;
  Stream<bool> get cargandoProductosStream => _cargandoProductosController.stream;

  Stream<ValidarProducto> get categoriaTemporizador => _categoriaTemporizador.stream;

  dispose() {
    _productosEnchiladasController?.close();
    _productosIDController?.close();
    _cargandoProductosController?.close();
    _categoriaProductosController?.close();
    _categoriaTemporizador?.close();
  }

  void cargandoProductosFalse() {
    _cargandoProductosController.sink.add(false);
  }

  void obtenerProductosdeliveryEnchiladasPorCategoria(String categoria) async {
    _cargandoProductosController.sink.add(true);

    final List<ProductosData> listGeneral = [];
    final listProductos = await productoDatabase.obtenerProductosPorCategoria('$categoria');

    for (var x = 0; x < listProductos.length; x++) {
      final listCategorias = await categoriaDatabase.consultarPorId(listProductos[x].idCategoria);
      ProductosData productosData = ProductosData();
      productosData.idProducto = listProductos[x].idProducto;
      productosData.idCategoria = listProductos[x].idCategoria;
      productosData.productoNombre = listProductos[x].productoNombre;
      productosData.productoFoto = listProductos[x].productoFoto;
      productosData.productoOrden = listProductos[x].productoOrden;
      productosData.productoPrecio = listProductos[x].productoPrecio;
      productosData.productoCarta = listProductos[x].productoCarta;
      productosData.productoDelivery = listProductos[x].productoDelivery;
      productosData.sonido = listCategorias[0].categoriaSonido;
      productosData.productoUnidad = listProductos[x].productoUnidad;
      productosData.productoEstado = listProductos[x].productoEstado;
      productosData.productoDestacado = listProductos[x].productoDestacado;
      productosData.productoEstadoDestacado = listProductos[x].productoEstadoDestacado;
      productosData.productoTupper = listProductos[x].productoTupper;
      productosData.productoNuevo = listProductos[x].productoNuevo;
      productosData.numeroitem = x.toString();
      productosData.productoDescripcion = listProductos[x].productoDescripcion;
      productosData.productoComentario = listProductos[x].productoComentario;
      productosData.categoriaTipo = listProductos[x].categoriaTipo;
      productosData.categoriaTipo2 = listProductos[x].categoriaTipo2;
      productosData.validadoDelivery = listProductos[x].validadoDelivery;

      productosData.productoFavorito = listProductos[x].productoFavorito;
      listGeneral.add(productosData);
    }
    _productosEnchiladasController.sink.add(listGeneral);

    _cargandoProductosController.sink.add(false);
  }

  void obtenerProductoPorId(String id) async {
    _cargandoProductosController.sink.add(true);
    _productosIDController.sink.add(await productoDatabase.consultarPorId('$id'));
    _cargandoProductosController.sink.add(false);
  }

  void cargarCategoriaProductoDelivery(String idCategoria) async {
    List<CategoriaData> listFinal = [];
    List<ProductosData> listProductos = [];
    final listCategorias = await categoriaDatabase.consultarPorId(idCategoria);
    final listProductosPorCategoria = await productoDatabase.obtenerProductosPorCategoria(idCategoria);

    CategoriaData categoria = CategoriaData();

    categoria.categoriaNombre = listCategorias[0].categoriaNombre;
    categoria.categoriaBanner = listCategorias[0].categoriaBanner;

    if (listProductosPorCategoria.length > 0) {
      for (int x = 0; x < listProductosPorCategoria.length; x++) {
        ProductosData productosData = ProductosData();
        productosData.idProducto = listProductosPorCategoria[x].idProducto;
        productosData.idCategoria = listProductosPorCategoria[x].idCategoria;
        productosData.productoNombre = listProductosPorCategoria[x].productoNombre;
        productosData.productoFoto = listProductosPorCategoria[x].productoFoto;
        productosData.productoOrden = listProductosPorCategoria[x].productoOrden;
        productosData.productoPrecio = listProductosPorCategoria[x].productoPrecio;
        productosData.productoCarta = listProductosPorCategoria[x].productoCarta;
        productosData.productoDelivery = listProductosPorCategoria[x].productoDelivery;
        productosData.sonido = listCategorias[0].categoriaSonido;
        productosData.productoUnidad = listProductosPorCategoria[x].productoUnidad;
        productosData.productoEstado = listProductosPorCategoria[x].productoEstado;
        productosData.productoDestacado = listProductosPorCategoria[x].productoDestacado;
        productosData.productoEstadoDestacado = listProductosPorCategoria[x].productoEstadoDestacado;
        productosData.productoTupper = listProductosPorCategoria[x].productoTupper;
        productosData.productoNuevo = listProductosPorCategoria[x].productoNuevo;
        productosData.numeroitem = x.toString();
        productosData.productoDescripcion = listProductosPorCategoria[x].productoDescripcion;
        productosData.productoComentario = listProductosPorCategoria[x].productoComentario;
        productosData.productoFavorito = listProductosPorCategoria[x].productoFavorito;

        listProductos.add(productosData);
      }
    }

    categoria.productos = listProductos;
    listFinal.add(categoria);

    _categoriaProductosController.sink.add(listFinal);
  }

  void verificarDisponibilidad(String idProducto) async {
    var date = DateTime.now();

    final producto = await productoDatabase.consultarPorId(idProducto);
    final temporizadorList = await temporizadorDatabase.obtenerTemporizadorPorIdCategoria(producto[0].idCategoria);

    if (temporizadorList[0].temporizadorTipo == '1') {
      //1 cualquier día, en un rango de horas específicas
      _categoriaTemporizador.sink.add(_cualquierDiaEnRangoDeHorasEspecificas(date, temporizadorList));
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

      _categoriaTemporizador.sink.add(_rangoFechasYHorasEspecificas(temporizadorList, date));
    } else {
      //siempre disponible

      ValidarProducto validarProducto = ValidarProducto();
      validarProducto.valor = true;
      validarProducto.mensaje = temporizadorList[0].temporizadorMensaje;
      _categoriaTemporizador.sink.add(validarProducto);
    }
  }

  ValidarProducto _rangoFechasYHorasEspecificas(List<TemporizadorModel> temporizadorList, DateTime date) {
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

  void _ragoDeFechadEspecificas(List<TemporizadorModel> temporizadorList, DateTime date) {
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

  void _enDiasYHorasEspecificosDeLaSemana(DateTime date, List<TemporizadorModel> temporizadorList) {
    var week = date.weekday;

    ValidarProducto validarProducto = ValidarProducto();
    validarProducto.valor = false;
    validarProducto.mensaje = temporizadorList[0].temporizadorMensaje;

    if (week == 1) {
      if (temporizadorList[0].temporizadorLunes == '1') {
        _categoriaTemporizador.sink.add(_cualquierDiaEnRangoDeHorasEspecificas(date, temporizadorList));
      } else {
        _categoriaTemporizador.sink.add(validarProducto);
      }
    } else if (week == 2) {
      if (temporizadorList[0].temporizadorMartes == '1') {
        _categoriaTemporizador.sink.add(_cualquierDiaEnRangoDeHorasEspecificas(date, temporizadorList));
      } else {
        _categoriaTemporizador.sink.add(validarProducto);
      }
    } else if (week == 3) {
      if (temporizadorList[0].temporizadorMiercoles == '1') {
        _categoriaTemporizador.sink.add(_cualquierDiaEnRangoDeHorasEspecificas(date, temporizadorList));
      } else {
        _categoriaTemporizador.sink.add(validarProducto);
      }
    } else if (week == 4) {
      if (temporizadorList[0].temporizadorJueves == '1') {
        _categoriaTemporizador.sink.add(_cualquierDiaEnRangoDeHorasEspecificas(date, temporizadorList));
      } else {
        _categoriaTemporizador.sink.add(validarProducto);
      }
    } else if (week == 5) {
      if (temporizadorList[0].temporizadorViernes == '1') {
        _categoriaTemporizador.sink.add(_cualquierDiaEnRangoDeHorasEspecificas(date, temporizadorList));
      } else {
        _categoriaTemporizador.sink.add(validarProducto);
      }
    } else if (week == 6) {
      if (temporizadorList[0].temporizadorSabado == '1') {
        _categoriaTemporizador.sink.add(_cualquierDiaEnRangoDeHorasEspecificas(date, temporizadorList));
      } else {
        _categoriaTemporizador.sink.add(validarProducto);
      }
    } else if (week == 7) {
      if (temporizadorList[0].temporizadorDomingo == '1') {
        _categoriaTemporizador.sink.add(_cualquierDiaEnRangoDeHorasEspecificas(date, temporizadorList));
      } else {
        _categoriaTemporizador.sink.add(validarProducto);
      }
    }
  }

  ValidarProducto _cualquierDiaEnRangoDeHorasEspecificas(DateTime date, List<TemporizadorModel> temporizadorList) {
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

  void diasEspecificosDeLaSemana(DateTime date, List<TemporizadorModel> temporizadorList) {
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
