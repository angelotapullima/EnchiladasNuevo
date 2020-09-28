import 'package:enchiladasapp/src/database/carrito_database.dart';
import 'package:enchiladasapp/src/database/direccion_database.dart';
import 'package:enchiladasapp/src/models/carrito_model.dart';
import 'package:rxdart/subjects.dart';

class CarritoCompletoBloc {
  final direccionDatabase = DireccionDatabase();
  final carritoDatabase = CarritoDatabase();

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

    for (int i = 0; i < carrito.length; i++) {
      monto = double.parse(carrito[i].productoPrecio) *
          double.parse(carrito[i].productoCantidad);

          subtotal = subtotal +monto;

      CarritoCompleto carritoCompleto = CarritoCompleto();
      carritoCompleto.producto = carrito[i].productoNombre;
      carritoCompleto.precio = carrito[i].productoPrecio;
      carritoCompleto.cantidad = carrito[i].productoCantidad;

      listCarritoCompleto.add(carritoCompleto);
    }
    

    if (direccion.length > 0) {
      var pedidoMinimo = double.parse(direccion[0].zonaPedidoMinimo);

      if (deliveryRapido.length > 0) {
        CarritoCompleto carritoCompleto = CarritoCompleto();
        carritoCompleto.producto = direccion[0].deliveryProductoNombre;
        carritoCompleto.precio = direccion[0].deliveryProductoPrecio;
        carritoCompleto.cantidad = '1';

        listCarritoCompleto.add(carritoCompleto);
      }

      if (subtotal < pedidoMinimo) {
        //no se agrega
        CarritoCompleto carritoCompleto = CarritoCompleto();
        carritoCompleto.producto = direccion[0].recargoProductoNombre;
        carritoCompleto.precio = direccion[0].recargoProductoPrecio;
        carritoCompleto.cantidad = '1';

        listCarritoCompleto.add(carritoCompleto);
      }

      carritoCompleto.sink.add(listCarritoCompleto);
    } else {
      carritoCompleto.sink.add(listCarritoCompleto);
    }
  }



}

class CarritoCompleto {
  String producto;
  String cantidad;
  String precio;

  CarritoCompleto({this.producto, this.cantidad, this.precio});
}
