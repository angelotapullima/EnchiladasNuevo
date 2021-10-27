





import 'package:enchiladasapp/src/database/publicidad_database.dart';
import 'package:enchiladasapp/src/models/publicidad_model.dart';
import 'package:rxdart/subjects.dart';

class PublicidadBloc {

  final publicidadDatabase= PublicidadDatabase();
  

  final _publicidadController = new BehaviorSubject<List<PublicidadModel>>();

  Stream<List<PublicidadModel>> get publicidadStream => _publicidadController.stream;

  dispose() {
    _publicidadController?.close();
  }

  void obtenerPublicidad(String dato) async {
    _publicidadController.sink.add(await publicidadDatabase.obtenerPublicidad(dato));
  }
}
