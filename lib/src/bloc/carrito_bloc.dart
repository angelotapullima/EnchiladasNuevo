
import 'package:enchiladasapp/src/database/carrito_database.dart';
import 'package:enchiladasapp/src/models/carrito_model.dart';
import 'package:rxdart/rxdart.dart';



class CarritoBloc {
  final carritoDatabase =CarritoDatabase();
  final _carritosController = new BehaviorSubject<List<Carrito>>();

  Stream<List<Carrito>> get carritoIdStream => _carritosController.stream;

  dispose() {
    _carritosController?.close();
  }

  void obtenerCarrito( )async{ 
    _carritosController.sink.add(await carritoDatabase.obtenerCarritoDB()); 
  }
}
