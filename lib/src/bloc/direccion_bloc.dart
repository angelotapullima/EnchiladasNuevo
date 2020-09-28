
import 'package:enchiladasapp/src/database/direccion_database.dart';
import 'package:enchiladasapp/src/models/direccion_model.dart';
import 'package:rxdart/rxdart.dart';
class DireccionBloc {

  final direccionDatabase = DireccionDatabase();


final _direccionesController = new BehaviorSubject<List<Direccion>>();
final _direccionZonaController = new BehaviorSubject<List<Direccion>>();
 
  Stream<List<Direccion>> get direccionZonaStream => _direccionZonaController.stream;
  Stream<List<Direccion>> get direccionesStream => _direccionesController.stream;

  dispose() {
    _direccionesController?.close();
    _direccionZonaController?.close();
  }
 

  void obtenerDireccionesConZonas()async{

    _direccionZonaController.sink.add(await direccionDatabase.obtenerDireccionesConZonas()); 
  }

   void obtenerDirecciones()async{

    _direccionesController.sink.add(await direccionDatabase.obtenerDirecciones()); 
  }
} 