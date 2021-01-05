import 'package:enchiladasapp/src/bloc/provider.dart';
import 'package:enchiladasapp/src/database/adicionales_database.dart';
import 'package:enchiladasapp/src/database/carrito_database.dart';
import 'package:enchiladasapp/src/database/item_observacion_database.dart';
import 'package:enchiladasapp/src/database/producto_database.dart';
import 'package:enchiladasapp/src/database/direccion_database.dart';
import 'package:enchiladasapp/src/database/usuario_database.dart';
import 'package:enchiladasapp/src/models/carrito_model.dart';
import 'package:enchiladasapp/src/models/delivery_rapido_model.dart';
import 'package:enchiladasapp/src/models/productos_model.dart';
import 'package:enchiladasapp/src/models/direccion_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void agregarFavoritos(BuildContext context, ProductosData productosData) async {
  final favoritosBloc = ProviderBloc.fav(context);
  ProductosData productos = new ProductosData();
  final productoDatabase = ProductoDatabase();

  productos.idProducto = productosData.idProducto;
  productos.idCategoria = productosData.idCategoria;
  productos.productoNombre = productosData.productoNombre;
  productos.productoFoto = productosData.productoFoto;
  productos.productoPrecio = productosData.productoPrecio;
  productos.productoUnidad = productosData.productoUnidad;
  productos.productoEstado = productosData.productoEstado;
  productos.productoCarta = productosData.productoCarta;
  productos.productoDelivery = productosData.productoDelivery;
  productos.productoDescripcion = productosData.productoDescripcion;
  productos.productoComentario = productosData.productoComentario;
  productos.productoDestacado = productosData.productoDestacado;
  productos.productoEstadoDestacado = productosData.productoEstadoDestacado;
  productos.productoTupper = productosData.productoTupper;
  productos.productoAdicionalTitulo = productosData.productoAdicionalTitulo;
  productos.productoAdicionalOpciones = productosData.productoAdicionalOpciones;
  productos.productoNuevo = productosData.productoNuevo;
  productos.productoFavorito = 1;

  await productoDatabase.updateProductosDb(productos);

  favoritosBloc.obtenerProductosFavoritos();
  //_mostrarAlert(context);
}

void quitarFavoritos(BuildContext context, ProductosData productosData) async {
  ProductosData productos = new ProductosData();
  final productoDatabase = ProductoDatabase();
  final favoritosBloc = ProviderBloc.fav(context);

  productos.idProducto = productosData.idProducto;
  productos.idCategoria = productosData.idCategoria;
  productos.productoNombre = productosData.productoNombre;
  productos.productoFoto = productosData.productoFoto;
  productos.productoPrecio = productosData.productoPrecio;
  productos.productoUnidad = productosData.productoUnidad;
  productos.productoEstado = productosData.productoEstado;
  productos.productoCarta = productosData.productoCarta;
  productos.productoDelivery = productosData.productoDelivery;
  productos.productoDescripcion = productosData.productoDescripcion;
  productos.productoDestacado = productosData.productoDestacado;
  productos.productoEstadoDestacado = productosData.productoEstadoDestacado;
  productos.productoTupper = productosData.productoTupper;
  productos.productoAdicionalTitulo = productosData.productoAdicionalTitulo;
  productos.productoAdicionalOpciones = productosData.productoAdicionalOpciones;
  productos.productoNuevo = productosData.productoNuevo;
  productos.productoFavorito = 0;

  await productoDatabase.updateProductosDb(productos);

  //_mostrarAlert(context);
  favoritosBloc.obtenerProductosFavoritos();
}

void agregarDeliveryRapido(BuildContext context) async {
  final carritoCompletoBloc = ProviderBloc.carritoCompleto(context);
  final carritoBloc = ProviderBloc.carrito(context);
  final carritoDatabase = CarritoDatabase();

  await carritoDatabase.deleteDeliveryRapido();
  DeliveryRapido deliveryRapido = DeliveryRapido();
  deliveryRapido.idDelivery = '1';
  deliveryRapido.estado = '1';

  await carritoDatabase.insertarDeliveryRapido(deliveryRapido);

  carritoCompletoBloc.obtenerCarritoCpmpleto();
  carritoBloc.obtenerDeliveryRapido();
}

void quitarDeliveryRapido(BuildContext context) async {
  final carritoBloc = ProviderBloc.carrito(context);
  final carritoCompletoBloc = ProviderBloc.carritoCompleto(context);
  final carritoDatabase = CarritoDatabase();

  await carritoDatabase.deleteDeliveryRapido();
  carritoCompletoBloc.obtenerCarritoCpmpleto();
  carritoBloc.obtenerDeliveryRapido();
}

Future<bool> agregarZona(BuildContext context, String idZona) async {
  final usuarioDatabase = UsuarioDatabase();

  final res = await usuarioDatabase.updateZonaUsuario(idZona);

  /* 
  zonaBloc.obtenerUsuarioZona(); */
  if (res > 0) {
    return true;
  } else {
    return false;
  }
}

void deleteProductoCarrito(BuildContext context, int idProdcuto) {
  //Carrito carrito = new Carrito();
  final carritoDatabase = CarritoDatabase();

  final carritoBloc = ProviderBloc.carrito(context);

  carritoDatabase.deteleProductoCarrito(idProdcuto);
  carritoBloc.obtenerCarrito();
}

void agregarCarrito(
    ProductosData productosData, BuildContext context, String cantidad) async {
  Carrito carrito = new Carrito();
  final carritoDatabase = CarritoDatabase();

  final carritoBloc = ProviderBloc.carrito(context);
  final carritoCompletoBloc = ProviderBloc.carritoCompleto(context);

  if (cantidad == "0") {
    await carritoDatabase.deteleProductoCarrito(
      int.parse(productosData.idProducto),
    );
  } else {
    final dato =
        await carritoDatabase.consultarCarritoPorId(productosData.idProducto);

    carrito.idProducto = int.parse(productosData.idProducto);
    carrito.productoNombre = productosData.productoNombre;
    carrito.idCategoria = productosData.idCategoria;
    carrito.productoFoto = productosData.productoFoto;
    carrito.productoPrecio = productosData.productoPrecio;
    carrito.productoTipo = '0';
    carrito.productoCantidad = cantidad;
    carrito.productoTupper = productosData.productoTupper;

    if (dato.length > 0) {
      carrito.productoObservacion = dato[0].productoObservacion;

      await carritoDatabase.updateCarritoDb(carrito);
    } else {
      carrito.productoObservacion = '';
      await carritoDatabase.insertarCarritoDb(carrito);
    }
  }
  //showToast('Producto agregado correctamente', 1);

  carritoBloc.obtenerCarrito();
  carritoCompletoBloc.obtenerCarritoCpmpleto();
  //_mostrarAlert(context);
}




void agregarPropinaCarrito(
    ProductosData productosData, BuildContext context, String cantidad) async {
  Carrito carrito = new Carrito();
  final carritoDatabase = CarritoDatabase();

  final carritoBloc = ProviderBloc.carrito(context);
  final carritoCompletoBloc = ProviderBloc.carritoCompleto(context);

  if (cantidad == "0") {
    await carritoDatabase.deletePropinaCarritoDb();
  } else {

    await carritoDatabase.deletePropinaCarritoDb();
    
    final dato =
        await carritoDatabase.consultarCarritoPorId(productosData.idProducto);

    carrito.idProducto = int.parse(productosData.idProducto);
    carrito.productoNombre = productosData.productoNombre;
    carrito.idCategoria = productosData.idCategoria;
    carrito.productoFoto = productosData.productoFoto;
    carrito.productoPrecio = productosData.productoPrecio;
    carrito.productoTipo = '0';
    carrito.productoCantidad = cantidad;
    carrito.productoTupper = productosData.productoTupper;

    if (dato.length > 0) {
      carrito.productoObservacion = dato[0].productoObservacion;

      await carritoDatabase.updateCarritoDb(carrito);
    } else {
      carrito.productoObservacion = '';
      await carritoDatabase.insertarCarritoDb(carrito);
    }
  }
  //showToast('Producto agregado correctamente', 1);

  carritoBloc.obtenerCarrito();
  carritoCompletoBloc.obtenerCarritoCpmpleto();
  //_mostrarAlert(context);
}


void agregarCarritoConAdicionales(ProductosData productosData,
    BuildContext context, String cantidad, String observacion) async {
  Carrito carrito = new Carrito();
  final carritoDatabase = CarritoDatabase();

  final carritoBloc = ProviderBloc.carrito(context);
  if (cantidad == "0") {
    await carritoDatabase
        .deteleProductoCarrito(int.parse(productosData.idProducto));
  } else {
    final dato =
        await carritoDatabase.consultarCarritoPorId(productosData.idProducto);

    carrito.idProducto = int.parse(productosData.idProducto);
    carrito.productoNombre = productosData.productoNombre;
    carrito.productoFoto = productosData.productoFoto;
    carrito.productoPrecio = productosData.productoPrecio;
    carrito.productoTipo = '0';
    carrito.productoObservacion = observacion;
    carrito.productoCantidad = cantidad;
    carrito.productoTupper = productosData.productoTupper;

    if (dato.length > 0) {
      await carritoDatabase.updateCarritoDb(carrito);
    } else {
      await carritoDatabase.insertarCarritoDb(carrito);
    }
  }
  //showToast('Producto agregado correctamente', 1);

  carritoBloc.obtenerCarrito();
  //_mostrarAlert(context);
}

String format(double n) {
  return n.toStringAsFixed(n.truncateToDouble() == n ? 2 : 2);
}

void quitarFavoritosMarket(
    BuildContext context, ProductosData productosData, String categotia) async {
  ProductosData productos = new ProductosData();
  final productoDatabase = ProductoDatabase();
  final productosIdBloc = ProviderBloc.prod(context);

  productos.idProducto = productosData.idProducto;
  productos.idCategoria = productosData.idCategoria;
  productos.productoNombre = productosData.productoNombre;
  productos.productoFoto = productosData.productoFoto;
  productos.productoPrecio = productosData.productoPrecio;
  productos.productoUnidad = productosData.productoUnidad;
  productos.productoEstado = productosData.productoEstado;
  productos.productoDestacado = productosData.productoDestacado;
  productos.productoEstadoDestacado = productosData.productoEstadoDestacado;
  productos.productoAdicionalTitulo = productosData.productoAdicionalTitulo;
  productos.productoTupper = productosData.productoTupper;
  productos.productoNuevo = productosData.productoNuevo;
  productos.productoAdicionalOpciones = productosData.productoAdicionalOpciones;
  productos.productoFavorito = 0;

  await productoDatabase.updateProductosDb(productos);

  //_mostrarAlert(context);
  productosIdBloc.obtenerProductosMarketPorCategoria(categotia);
}

void seleccionarDireccion(BuildContext context, String id) async {
  final direccionDatabase = DireccionDatabase();
  direccionDatabase.ponerTodos0();
  final direccionBloc = ProviderBloc.dire(context);

  await direccionDatabase.seleccionarDireccion(id);
  direccionBloc.obtenerDireccionesConZonas();
  direccionBloc.obtenerDirecciones();
}

void agregarDireccion(BuildContext context, String addres, double latitud,
    double longitud, String referencia, String idDistrito) async {
  final direccionDatabase = DireccionDatabase();
  direccionDatabase.ponerTodos0();
  final direccionBloc = ProviderBloc.dire(context);

  Direccion direccion = new Direccion();
  direccion.titulo = '';
  direccion.direccion = addres;
  direccion.latitud = latitud.toString();
  direccion.longitud = longitud.toString();
  direccion.referencia = referencia;
  direccion.idZona = idDistrito;
  direccion.seleccionado = '1';

  await direccionDatabase.insertarDireccionDb(direccion);
  direccionBloc.obtenerDireccionesConZonas();
  direccionBloc.obtenerDirecciones();
}

void cambiarEstadoSeleccionAdicional(
    BuildContext context, String idProducto, bool valor,String idCategoria) async {
  final adicionalesDatabase = AdicionalesDatabase();
  final adicionalesBloc = ProviderBloc.adicionales(context);
  if (valor) {
    //await adicionalesDatabase.updateAdicionalesEnFalseDb();
    final adicional =
        await adicionalesDatabase.consultarAdicionalPorId(idProducto);

    ProductosData productosData = ProductosData();
    productosData.idProducto = adicional[0].idProducto;
    productosData.idCategoria = adicional[0].idCategoria;
    productosData.productoNombre = adicional[0].productoNombre;
    productosData.productoFoto = adicional[0].productoFoto;
    productosData.productoPrecio = adicional[0].productoPrecio;
    productosData.productoCarta = adicional[0].productoCarta;
    productosData.productoDelivery = adicional[0].productoDelivery;
    productosData.productoSeleccionado = adicional[0].productoSeleccionado;
    productosData.productoEstado = adicional[0].productoEstado;
    productosData.productoDescripcion = adicional[0].productoDescripcion;

    await adicionalesDatabase.updateAdicionalesEnTrueDb(productosData);
  } else {
    final adicional =
        await adicionalesDatabase.consultarAdicionalPorId(idProducto);

    ProductosData productosData = ProductosData();
    productosData.idProducto = adicional[0].idProducto;
    productosData.idCategoria = adicional[0].idCategoria;
    productosData.productoNombre = adicional[0].productoNombre;
    productosData.productoFoto = adicional[0].productoFoto;
    productosData.productoPrecio = adicional[0].productoPrecio;
    productosData.productoCarta = adicional[0].productoCarta;
    productosData.productoDelivery = adicional[0].productoDelivery;
    productosData.productoSeleccionado = adicional[0].productoSeleccionado;
    productosData.productoEstado = adicional[0].productoEstado;
    productosData.productoDescripcion = adicional[0].productoDescripcion;

    await adicionalesDatabase.updateAdicionalesEnfalsePorId(productosData);
  }

  adicionalesBloc.obtenerAdicionales(idCategoria);
}

void deleteDireccion(BuildContext context, idDireccion) async {
  final direccionDatabase = DireccionDatabase();
  final direccionBloc = ProviderBloc.dire(context);

  await direccionDatabase.deleteDireccionPorId(idDireccion);
  direccionBloc.obtenerDireccionesConZonas();
  direccionBloc.obtenerDirecciones();
}

void agregarTelefono(BuildContext context, String telefono) async {
  final usuarioDatabase = UsuarioDatabase();
  final usuarioBloc = ProviderBloc.user(context);

  await usuarioDatabase.updateTelefonoUsuario(telefono);

  usuarioBloc.obtenerUsuario();
}

void actualizarObservacion(
    BuildContext context, String observacion, String id) async {
  final carritoBloc = ProviderBloc.carrito(context);
  final carritoDatabase = CarritoDatabase();

  await carritoDatabase.updateObservacion(observacion, id);

  carritoBloc.obtenerCarrito();
}

void showToast(String msg, int duration, ToastGravity gravity) {
  Fluttertoast.showToast(
      msg: '$msg',
      toastLength: Toast.LENGTH_SHORT,
      gravity: gravity,
      timeInSecForIosWeb: duration,
      backgroundColor: Colors.black,
      textColor: Colors.white,
      fontSize: 16.0);
}

void agregarItemObservacion(
    BuildContext context, String idProducto, bool valor) async {
  print(valor);
  final itemObservacionDatabase = ItemObservacionDatabase();
  final productoDatabase = ProductoDatabase();

  if (valor) {
    final producto = await productoDatabase.consultarPorId(idProducto);

    ProductosData productoData = ProductosData();
    productoData.idProducto = producto[0].idProducto;
    productoData.productoNombre = producto[0].productoNombre;
    productoData.productoFoto = producto[0].productoFoto;
    productoData.productoPrecio = producto[0].productoPrecio;
    productoData.productoObservacion = '';
    productoData.idCategoria = producto[0].idCategoria;
    productoData.productoTupper = producto[0].productoTupper;

    await itemObservacionDatabase.insertarItemObservacion(productoData);
  } else {
    await itemObservacionDatabase.deleteItemObservacionPorProducto(idProducto);
  }

  final itemObservacionBloc = ProviderBloc.itemOb(context);
  itemObservacionBloc.obtenerObservacionItem();
  //_mostrarAlert(context);
}

void agregarItemObservacionFijos(
    BuildContext context, String idProducto, bool valor) async {
  print(valor);
  final itemObservacionDatabase = ItemObservacionDatabase();
  final productoDatabase = ProductoDatabase();

  final itemsObservacion =
      await itemObservacionDatabase.obtenerItemObservacion();

  for (var i = 0; i < itemsObservacion.length; i++) {
    if (itemsObservacion[i].idCategoria != '16') {
      await itemObservacionDatabase
          .deleteItemObservacionPorProducto(itemsObservacion[i].idProducto);
    }
  }

  final producto = await productoDatabase.consultarPorId(idProducto);

  ProductosData productoData = ProductosData();
  productoData.idProducto = producto[0].idProducto;
  productoData.productoNombre = producto[0].productoNombre;
  productoData.productoFoto = producto[0].productoFoto;
  productoData.productoPrecio = producto[0].productoPrecio;
  productoData.productoObservacion = '';
  productoData.idCategoria = producto[0].idCategoria;
  productoData.productoTupper = producto[0].productoTupper;

  await itemObservacionDatabase.insertarItemObservacion(productoData);

  print(itemsObservacion.length);

  final itemObservacionBloc = ProviderBloc.itemOb(context);
  itemObservacionBloc.obtenerObservacionItem();
  //_mostrarAlert(context);
}

void agregarObservacionEnProductoObservacion(
    BuildContext context,
    List<String> sabores,
    List<String> variables,
    String acompanhamientos) async {
  final itemObservacionBloc = ProviderBloc.itemOb(context);

  final itemObservacionDatabase = ItemObservacionDatabase();
  String observaciones = "";

  if (sabores.length > 0) {
    observaciones += 'Sabores : ';
    for (var i = 0; i < sabores.length; i++) {
      observaciones += '${sabores[i]},';
    }
  }

  if (acompanhamientos != 'false') {
    observaciones += ' Acompañamiento: $acompanhamientos ';
  }

  if (variables.length > 0) {
    observaciones += '  variables : ';
    for (var i = 0; i < variables.length; i++) {
      observaciones += '${variables[i]},';
    }
  }

  final itemsObservacion =
      await itemObservacionDatabase.obtenerItemObservacion();

  for (var i = 0; i < itemsObservacion.length; i++) {
    if (itemsObservacion[i].idCategoria != '16') {
      ProductosData productoData = ProductosData();
      productoData.idProducto = itemsObservacion[i].idProducto;
      productoData.productoNombre = itemsObservacion[i].productoNombre;
      productoData.productoFoto = itemsObservacion[i].productoFoto;
      productoData.productoPrecio = itemsObservacion[i].productoPrecio;
      productoData.productoObservacion = observaciones;
      productoData.idCategoria = itemsObservacion[i].idCategoria;
      productoData.productoTupper = itemsObservacion[i].productoTupper;

      await itemObservacionDatabase.insertarItemObservacion(productoData);
    }
  }

  itemObservacionBloc.obtenerObservacionItem();

  print('jefbvuobrotr $observaciones');
}

void agregarProductosAlCarrito(BuildContext context) async {
  final itemObservacionDatabase = ItemObservacionDatabase();
  final carritoBloc = ProviderBloc.carrito(context);
  Carrito carrito = new Carrito();
  final carritoDatabase = CarritoDatabase();

  final itemsObservacion =
      await itemObservacionDatabase.obtenerItemObservacion();

  for (var i = 0; i < itemsObservacion.length; i++) {
    final dato = await carritoDatabase
        .consultarCarritoPorId(itemsObservacion[i].idProducto);

    carrito.idProducto = int.parse(itemsObservacion[i].idProducto);
    carrito.productoNombre = itemsObservacion[i].productoNombre;
    carrito.productoFoto = itemsObservacion[i].productoFoto;
    carrito.productoPrecio = itemsObservacion[i].productoPrecio;
    carrito.productoTipo = '0';
    carrito.productoObservacion = itemsObservacion[i].productoObservacion;
    carrito.productoTupper = itemsObservacion[i].productoTupper;
    carrito.productoCantidad = '1';

    if (dato.length > 0) {
      await carritoDatabase.updateCarritoDb(carrito);
    } else {
      await carritoDatabase.insertarCarritoDb(carrito);
    }
  }
  //showToast('Producto agregado correctamente', 1);

  carritoBloc.obtenerCarrito();
}


void deletePropinas(BuildContext context)async{


  final carritoBloc = ProviderBloc.carrito(context);

final carritoDatabase = CarritoDatabase();


  await carritoDatabase.deletePropinaCarritoDb();



  carritoBloc.obtenerCarrito();
}
