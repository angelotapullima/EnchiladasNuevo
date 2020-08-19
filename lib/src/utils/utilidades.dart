
import 'package:enchiladasapp/src/bloc/provider.dart';
import 'package:enchiladasapp/src/database/carrito_database.dart';
import 'package:enchiladasapp/src/database/delivery_rapido_database.dart';
import 'package:enchiladasapp/src/database/producto_database.dart';
import 'package:enchiladasapp/src/database/direccion_database.dart';
import 'package:enchiladasapp/src/database/usuario_database.dart';
import 'package:enchiladasapp/src/models/carrito_model.dart';
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
  productos.productoFavorito = 1;

  final res = await productoDatabase.updateProductosDb(productos);
  print('Database response : $res');

  favoritosBloc.obtenerProductosFavoritos();
  //_mostrarAlert(context);
}

Future<bool> agregarDeliveryRapido(BuildContext context)async{
  final carritoBloc = ProviderBloc.carrito(context);
  final deliveryRapidoDatabase = DeliveryRapidoDatabase();
  final carritoDatabase = CarritoDatabase();
  final productoDatabase = ProductoDatabase();
  
  final delivery = await deliveryRapidoDatabase.obtenerDeliveryRapido();

  final producto = await productoDatabase.consultarPorId(delivery[0].idProducto);

  Carrito carrito = new Carrito();

    carrito.idProducto = int.parse(producto[0].idProducto);
    carrito.productoNombre = producto[0].productoNombre;
    carrito.productoFoto = producto[0].productoFoto;
    carrito.productoPrecio = producto[0].productoPrecio;
    carrito.productoObservacion = " ";
    carrito.productoTipo='1';
    carrito.productoCantidad = '1';
    final resInsertar = await carritoDatabase.insertarCarritoDb(carrito);
    print('Database response : $resInsertar');

    carritoBloc.obtenerCarrito();
    return true;
  
}
Future<bool> quitarDeliveryRapido(BuildContext context)async{

  final carritoBloc = ProviderBloc.carrito(context);
  final deliveryRapidoDatabase = DeliveryRapidoDatabase();
  final carritoDatabase = CarritoDatabase();

  final delivery = await deliveryRapidoDatabase.obtenerDeliveryRapido();

  final delete = await carritoDatabase
        .deteleProductoCarrito(int.parse(delivery[0].idProducto));
    print('Database response : $delete');
  carritoBloc.obtenerCarrito();
  return true;
}

Future<bool> agregarZona(BuildContext context,String idZona)async{

  final usuarioDatabase = UsuarioDatabase();
  final zonaBloc = ProviderBloc.zona(context);

  final res = await usuarioDatabase.updateZonaUsuario(idZona);
  print(res);
  zonaBloc.obtenerUsuarioZona();
  if(res>0){
    return true;
  }else{
    return false;
  }
}

void deleteProductoCarrito(BuildContext context,int idProdcuto){

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
    final delete = await carritoDatabase
        .deteleProductoCarrito(int.parse(productosData.idProducto));
    print('Database response : $delete');
  } else {
    final dato =
        await carritoDatabase.consultarCarritoPorId(productosData.idProducto);

    carrito.idProducto = int.parse(productosData.idProducto);
    carrito.productoNombre = productosData.productoNombre;
    carrito.productoFoto = productosData.productoFoto;
    carrito.productoPrecio = productosData.productoPrecio;
    carrito.productoObservacion = " ";
    carrito.productoTipo='0';
    carrito.productoCantidad = cantidad;

    if (dato.length > 0) {
      final resActualizar = await carritoDatabase.updateCarritoDb(carrito);
      print('Database response : $resActualizar');
    } else {
      final resInsertar = await carritoDatabase.insertarCarritoDb(carrito);
      print('Database response : $resInsertar');
    }
  }
  //showToast('Producto agregado correctamente', 1);

  carritoBloc.obtenerCarrito();
  //_mostrarAlert(context);
}

String format(double n) {
  return n.toStringAsFixed(n.truncateToDouble() == n ? 2 : 2);
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
  productos.productoFavorito = 0;

  final res = await productoDatabase.updateProductosDb(productos);
  print('Database response : $res');

  //_mostrarAlert(context);
  favoritosBloc.obtenerProductosFavoritos();
}

void agregarDireccion(BuildContext context, String addres, double latitud,
    double longitud, String referencia) async {
  final direccion = new Direccion();
  final direccionDatabase = DireccionDatabase();
  final usuarioDatabase = UsuarioDatabase();
  final direccionBloc = ProviderBloc.dire(context);
  await direccionDatabase.deleteDireccion();
  final dato = await direccionDatabase.obtenerdireccion();

  direccion.id = dato.length + 1;
  direccion.direccion = addres;
  direccion.latitud = latitud.toString();
  direccion.longitud = longitud.toString();
  direccion.referencia = referencia;
 
  await direccionDatabase.insertarDireccionDb(direccion);
  await usuarioDatabase.updateDireccionUsuario(direccion.id); 
  direccionBloc.obtenerDireccion();
}

void agregarTelefono(BuildContext context, String telefono) async {
  final usuarioDatabase = UsuarioDatabase();
  final usuarioBloc = ProviderBloc.user(context);

  final res = await usuarioDatabase.updateTelefonoUsuario(telefono);
  print(res);
  usuarioBloc.obtenerUsuario();
}

void actualizarObservacion(BuildContext context, String observacion, String id) async {
  final carritoBloc = ProviderBloc.carrito(context);
  final carritoDatabase = CarritoDatabase(); 

  final res = await carritoDatabase.updateObservacion(observacion,id);
  print(res);
  carritoBloc.obtenerCarrito();
}

void showToast( String msg, int duration) {
  Fluttertoast.showToast(
      msg:  '$msg',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
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
