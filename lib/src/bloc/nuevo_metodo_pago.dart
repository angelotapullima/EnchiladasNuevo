

import 'package:enchiladasapp/src/database/pedido_database.dart';
import 'package:rxdart/rxdart.dart';

class NuevoMetodoPagoBloc {
  final pedidoDatabase = PedidoDatabase();

  final _valorRadioController = BehaviorSubject<int>();
  final _vueltoController = BehaviorSubject<double>();
  final _telefonoController = BehaviorSubject<bool>();
  final _montoCarritoController = BehaviorSubject<double>();

  final _estadoWebviewController = BehaviorSubject<bool>();

  Stream<int> get selectValorRadioStream => _valorRadioController.stream;
  Stream<double> get vueltoStream => _vueltoController.stream;
  Stream<bool> get telefonoStream => _telefonoController.stream;
  Stream<double> get montoCarritoStream => _montoCarritoController.stream;
  Stream<bool> get estadoWebview =>_estadoWebviewController.stream;

  //funciones para cambio
  Function(int) get changeValorRadio => _valorRadioController.sink.add;
  Function(bool) get changeEstadoWebview => _estadoWebviewController.sink.add;

  // Obtener el último valor ingresado a los streams
  int get valorRadio => _valorRadioController.value;
  double get valorVuelto => _vueltoController.value;
  bool get valorValidacionTelefono => _telefonoController.value;
  double get montoCarrito => _montoCarritoController.value;
  bool get valorEstadoWe =>_estadoWebviewController.value;

  void validarPago(String idpedido, String monto) async {
    final pedido = await pedidoDatabase.obtenerPedidoPorId(idpedido);
    double res = 0;
    double precio = double.parse(pedido[0].pedidoTotal);
    res = double.parse(monto) - precio;
    _vueltoController.sink.add(res);
  }

  /* void obtenerMontoCarrito() async {
    double precio = 0;

    final carritoDatabase = CarritoDatabase();
    final usuarioDatabase = UsuarioDatabase();
    final zonaDatabase = ZonaDatabase();/* 
    final productoDatabase = ProductoDatabase(); */
    final carrito = await carritoDatabase.obtenerCarritoDB();

    for (int i = 0; i < carrito.length; i++) {
      precio = precio + double.parse(carrito[i].productoPrecio);
    }

    final user = await usuarioDatabase.obtenerUsUario();

    if (user[0].idZona != " ") {
      final zona = await zonaDatabase.obtenerZonaPorId(user[0].idZona);
      if (zona.length > 0) {
       /*  final producto =
            await productoDatabase.consultarPorId(zona[0].idProducto); */

        if (precio > double.parse(zona[0].zonaPedidoMinimo)) {
          _montoCarritoController.sink.add(precio);
        } else {/* 
          precio = precio + double.parse(producto[0].productoPrecio); */
          _montoCarritoController.sink.add(precio);
        }
      }else{

      _montoCarritoController.sink.add(precio);
      }
    } else {
      _montoCarritoController.sink.add(precio);
    }
  }

  */ void validarPago2(String montoIngresado, String precioPedido) async {
    double res = 0;
    double costo = double.parse(montoIngresado);
    res = costo - double.parse(precioPedido);
    _vueltoController.sink.add(res);
  }

  void validarTelefono(String telefono) async {
    if (telefono.length > 8) {
      _telefonoController.sink.add(true);
    } else {
      _telefonoController.sink.add(false);
    }
  }

  dispose() {
    _valorRadioController?.close();
    _vueltoController?.close();
    _telefonoController?.close();
    _montoCarritoController?.close();
    _estadoWebviewController?.close();
  }
}
