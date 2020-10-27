

import 'package:enchiladasapp/src/api/pedidos_asignados_api.dart';
import 'package:enchiladasapp/src/database/pedido_asignado_database.dart';
import 'package:enchiladasapp/src/models/pedidos_asignados_model.dart';
import 'package:rxdart/subjects.dart';

class PedidosAsignadosBloc{

  final pedidosAsignadosApi = PedidosAsignadosApi();
  final pedidoAsignadoDatabase=PedidoAsignadoDatabase();

  final _pedidoAsignadosController = new BehaviorSubject<List<PedidoAsignados>>();
  final _pedidoAsignadosPorIDController = new BehaviorSubject<List<PedidoAsignados>>();
  final _detallePedidosAsignadoController = new BehaviorSubject<List<DetallePedidoAsignados>>();
  

  Stream<List<PedidoAsignados>> get pedidoAsignadosStream => _pedidoAsignadosController.stream;
  Stream<List<DetallePedidoAsignados>> get detallePedidoAsignadosStream => _detallePedidosAsignadoController.stream;
  
  dispose() {
    _pedidoAsignadosController?.close(); 
    _pedidoAsignadosPorIDController?.close(); 
    _detallePedidosAsignadoController?.close(); 
  } 

  void obteberPedidosAsignados( )async{

    _pedidoAsignadosController.sink.add(await pedidosAsignadosApi.obtenerPedidosAsignados());
 
  }

  void obtenerPedidoAsignadoPorId(String id)async{ 
    
    _pedidoAsignadosPorIDController.sink.add(await pedidoAsignadoDatabase.obtenerPedidoPorID(id));
  }

  void obtenerDetalleAsignadoPedido(String id) async {
    _detallePedidosAsignadoController.sink
        .add(await pedidoAsignadoDatabase.obtenerDetallePedidoPorIdPedido(id));
  }

} 