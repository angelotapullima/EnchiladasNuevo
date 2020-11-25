import 'package:enchiladasapp/src/bloc/provider.dart';
import 'package:enchiladasapp/src/database/carrito_database.dart';
import 'package:enchiladasapp/src/database/producto_database.dart';
import 'package:enchiladasapp/src/database/direccion_database.dart';
import 'package:enchiladasapp/src/database/usuario_database.dart';
import 'package:enchiladasapp/src/models/carrito_model.dart';
import 'package:enchiladasapp/src/models/delivery_rapido_model.dart';
import 'package:enchiladasapp/src/models/productos._model.dart';
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
  productos.productoDescripcion = productosData.productoDescripcion; 
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
  productos.productoDescripcion = productosData.productoDescripcion;
  productos.productoFavorito = 0;

  await productoDatabase.updateProductosDb(productos);
  

  //_mostrarAlert(context);
  favoritosBloc.obtenerProductosFavoritos();
}

void agregarFavoritosMarket(
    BuildContext context, ProductosData productosData, String categoria) async {
  final productosIdBloc = ProviderBloc.prod(context);
  ProductosData productos = new ProductosData();
  final productoDatabase = ProductoDatabase();

  productos.idProducto = productosData.idProducto;
  productos.idCategoria = productosData.idCategoria;
  productos.productoNombre = productosData.productoNombre;
  productos.productoFoto = productosData.productoFoto;
  productos.productoPrecio = productosData.productoPrecio;
  productos.productoUnidad = productosData.productoUnidad;
  productos.productoEstado = productosData.productoEstado;
  productos.productoDescripcion = productosData.productoDescripcion;
  productos.productoFavorito = 1;

   await productoDatabase.updateProductosDb(productos);


  productosIdBloc.obtenerProductosMarketPorCategoria(categoria);
  //_mostrarAlert(context);
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
    carrito.productoObservacion = " ";
    carrito.productoTipo = '0';
    carrito.productoCantidad = cantidad;

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

void deleteDireccion(BuildContext context, idDireccion) async {
  final direccionDatabase = DireccionDatabase();
  final direccionBloc = ProviderBloc.dire(context);

  await direccionDatabase.deleteDireccionPorId(idDireccion);
  direccionBloc.obtenerDireccionesConZonas();
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

/*
void _mostrarAlert(BuildContext context) {
  //_image=null;
  showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          title: Text('Congratulations!!!'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text('Producto agregado al carrito correctamente'),
              SizedBox(
                height: 20.0,
              ),
            ],
          ),
          actions: <Widget>[
            FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.pop(context);
                  /* _startStopButtonPressed();
                _resetButtonPressed();

                _image=null; */
                },
                child: Text('ok')),
          ],
        );
      }
  );
}

 */
