

import 'package:enchiladasapp/src/api/pedidos_asignados_api.dart';
import 'package:enchiladasapp/src/models/pedidos_asignados_model.dart';
import 'package:rxdart/subjects.dart';

class PedidosAsignadosBloc{

  final pedidosAsignadosApi = PedidosAsignadosApi();

  final _pedidoAsignadosController = new BehaviorSubject<List<PedidoAsignados>>();
  

  Stream<List<PedidoAsignados>> get pedidoAsignadosStream => _pedidoAsignadosController.stream;
  
  dispose() {
    _pedidoAsignadosController?.close(); 
  }

  void obteberPedidosAsignados( )async{

    _pedidoAsignadosController.sink.add(await pedidosAsignadosApi.obtenerPedidosAsignados());
 
  }

}