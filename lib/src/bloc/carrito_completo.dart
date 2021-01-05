import 'package:enchiladasapp/src/database/carrito_database.dart';
import 'package:enchiladasapp/src/database/direccion_database.dart';
import 'package:enchiladasapp/src/database/producto_database.dart';
import 'package:enchiladasapp/src/models/carrito_model.dart';
import 'package:enchiladasapp/src/utils/preferencias_usuario.dart';
import 'package:rxdart/subjects.dart';

class CarritoCompletoBloc {
  final direccionDatabase = DireccionDatabase();
  final carritoDatabase = CarritoDatabase();
  final prefs = Preferences();
  final productoDatabase = ProductoDatabase();
  final carritoCompleto = new BehaviorSubject<List<CarritoCompleto>>();

  Stream<List<CarritoCompleto>> get carritoCompletoStream =>
      carritoCompleto.stream;

  dispose() {
    carritoCompleto?.close();
  }

  void obtenerCarritoCpmpleto() async {
    final listCarritoCompleto = List<CarritoCompleto>();
    double subtotal = 0.0;
    double monto = 0.0;
    List<Carrito> carrito = await carritoDatabase.obtenerCarritoDB();
    final direccion = await direccionDatabase.obtenerDireccionesConZonas();
    final deliveryRapido = await carritoDatabase.obtenerDeliveryRapido();

    int cantidadDeProductos = 0;
    int cantidadDeTupers = 0;
    for (int i = 0; i < carrito.length; i++) {
      cantidadDeProductos =
          cantidadDeProductos + int.parse(carrito[i].productoCantidad);
      monto = double.parse(carrito[i].productoPrecio) *
          double.parse(carrito[i].productoCantidad);

      subtotal = subtotal + monto;

      CarritoCompleto carritoCompleto1 = CarritoCompleto();
      carritoCompleto1.idCategoria = carrito[i].idCategoria;
      carritoCompleto1.producto = carrito[i].productoNombre;
      carritoCompleto1.precio = carrito[i].productoPrecio;
      carritoCompleto1.cantidad = carrito[i].productoCantidad;

      listCarritoCompleto.add(carritoCompleto1);

      if (carrito[i].productoTupper == '1') {
        cantidadDeTupers++;
      }
    }

    if (cantidadDeTupers > 0) {
      final tupperProduct =
          await productoDatabase.consultarPorId(prefs.idTupper);
      CarritoCompleto carritoCompletoTupper = CarritoCompleto();
      carritoCompletoTupper.idCategoria = carrito[0].idCategoria;
      carritoCompletoTupper.producto = tupperProduct[0].productoNombre;
      carritoCompletoTupper.precio = tupperProduct[0].productoPrecio;
      carritoCompletoTupper.cantidad = cantidadDeTupers.toString();

      listCarritoCompleto.add(carritoCompletoTupper);
    }

    final listBolsa = await productoDatabase.consultarPorId(prefs.idBolsa);
    int cantidadDeBolsas = (cantidadDeProductos / 3).ceil();

    CarritoCompleto carritoCompleto2 = CarritoCompleto();
    carritoCompleto2.idCategoria = carrito[0].idCategoria;
    carritoCompleto2.producto = listBolsa[0].productoNombre;
    carritoCompleto2.precio = listBolsa[0].productoPrecio;
    carritoCompleto2.cantidad = cantidadDeBolsas.toString();

    listCarritoCompleto.add(carritoCompleto2);

    if (direccion.length > 0) {
      var pedidoMinimo = double.parse(direccion[0].zonaPedidoMinimo);

      if (deliveryRapido.length > 0) {
        CarritoCompleto carritoCompleto3 = CarritoCompleto();
        carritoCompleto3.idCategoria = carrito[0].idCategoria;
        carritoCompleto3.producto = direccion[0].deliveryProductoNombre;
        carritoCompleto3.precio = direccion[0].deliveryProductoPrecio;
        carritoCompleto3.cantidad = '1';

        listCarritoCompleto.add(carritoCompleto3);
      }

      if (subtotal < pedidoMinimo) {
        //no se agrega
        CarritoCompleto carritoCompleto4 = CarritoCompleto();
        carritoCompleto4.idCategoria = carrito[0].idCategoria;
        carritoCompleto4.producto = direccion[0].recargoProductoNombre;
        carritoCompleto4.precio = direccion[0].recargoProductoPrecio;
        carritoCompleto4.cantidad = '1';

        listCarritoCompleto.add(carritoCompleto4);

        CarritoCompleto carritoCompleto5 = CarritoCompleto();
        carritoCompleto5.producto =
            'Tu pedido no cumple con el monto mínimo,para el distrito asignado que es de  S/.${direccion[0].zonaPedidoMinimo}, puedes añadir más productos al carrito para eliminar está comisión';
        carritoCompleto5.precio = '';
        carritoCompleto5.cantidad = '';

        listCarritoCompleto.add(carritoCompleto5);
      }

      carritoCompleto.sink.add(listCarritoCompleto);
    } else {
      carritoCompleto.sink.add(listCarritoCompleto);
    }
  }
}

class CarritoCompleto {
  String idCategoria;
  String producto;
  String cantidad;
  String precio;

  CarritoCompleto(
      {this.idCategoria, this.producto, this.cantidad, this.precio});
}
