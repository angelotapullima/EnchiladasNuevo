
import 'package:enchiladasapp/src/database/direccion_database.dart';
import 'package:enchiladasapp/src/models/direccion_model.dart';
import 'package:rxdart/rxdart.dart';
class DireccionBloc {

  final direccionDatabase = DireccionDatabase();


final _direccionController = new BehaviorSubject<List<Direccion>>();

  Stream<List<Direccion>> get direccionStream => _direccionController.stream;

  dispose() {
    _direccionController?.close();
  }

  void obtenerDireccion( )async{ 
    _direccionController.sink.add(await direccionDatabase.obtenerdireccion()); 
    
  }
}