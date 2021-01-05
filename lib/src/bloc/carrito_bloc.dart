import 'package:enchiladasapp/src/database/carrito_database.dart';
import 'package:enchiladasapp/src/models/carrito_model.dart';
import 'package:rxdart/rxdart.dart';

class CarritoBloc {
  final carritoDatabase = CarritoDatabase();
  final _carritosController = new BehaviorSubject<List<Carrito>>();
  final _deliveryController = new BehaviorSubject<bool>();

  Stream<List<Carrito>> get carritoIdStream => _carritosController.stream;
  Stream<bool> get estadoDeliveryStream => _deliveryController.stream;

  dispose() { 
    _carritosController?.close();
    _deliveryController?.close();
  }

  void obtenerCarrito() async {
    _carritosController.sink.add(await carritoDatabase.obtenerCarritoDB());
  }

  void obtenerDeliveryRapido() async {
    final estado = await carritoDatabase.obtenerDeliveryRapido();
    if (estado.length > 0) {
      _deliveryController.sink.add(true);
    } else {
      _deliveryController.sink.add(false);
    }
  }
}
