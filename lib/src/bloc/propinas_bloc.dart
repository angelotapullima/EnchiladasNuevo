

import 'package:enchiladasapp/src/database/producto_database.dart';
import 'package:enchiladasapp/src/models/productos_model.dart';
import 'package:rxdart/subjects.dart';

class PropinasBloc {


  final productoDatabase =ProductoDatabase();



  final _propinasController =new BehaviorSubject<List<ProductosData>>();

  Stream<List<ProductosData>> get propinasStream => _propinasController.stream;


  dispose() {
    _propinasController?.close();
    
  }

  void obtenerPropinas()async{

    _propinasController.sink.add(await productoDatabase.obtenerPropinas('97'));


  }


}