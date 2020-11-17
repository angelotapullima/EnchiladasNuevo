import 'package:enchiladasapp/src/api/ordenes_api.dart';
import 'package:enchiladasapp/src/database/pedido_database.dart';
import 'package:enchiladasapp/src/models/pedido_server_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';

class PedidoBloc {
  final pedidosDatabase = PedidoDatabase();
  final pedidoApi = OrdenesApi();

  final _pedidosPendientesController = new BehaviorSubject<List<PedidoServer>>();
  final _pedidosPasadosController = new BehaviorSubject<List<PedidoServer>>();
  final _pedidoIdController = new BehaviorSubject<List<PedidoServer>>();
  final _detallePedidosController = new BehaviorSubject<List<ProductoServer>>();

  Stream<List<PedidoServer>> get pedidosPendientesStream => _pedidosPendientesController.stream;
  Stream<List<PedidoServer>> get pedidosPasadosStream => _pedidosPasadosController.stream;
  Stream<List<PedidoServer>> get pedidoIdStream => _pedidoIdController.stream;
  Stream<List<ProductoServer>> get detallePedidoStream =>
      _detallePedidosController.stream;

  dispose() {
    _pedidosPendientesController?.close();
    _pedidosPasadosController?.close();
    _detallePedidosController?.close(); 
    _pedidoIdController?.close();
  }

  void obtenerPedidosPendientes(BuildContext context) async {
    _pedidosPendientesController.sink.add(await pedidosDatabase.obtenerTodosLosPedidosPendientes());
    await pedidoApi.obtenerhistorialDePedidos();
    _pedidosPendientesController.sink.add(await pedidosDatabase.obtenerTodosLosPedidosPendientes());
  }
  void obtenerPedidosPasados(BuildContext context) async {
    _pedidosPasadosController.sink.add(await pedidosDatabase.obtenerTodosLosPedidosPasados());
    await pedidoApi.obtenerhistorialDePedidos();
    _pedidosPasadosController.sink.add(await pedidosDatabase.obtenerTodosLosPedidosPasados());
  }
  void obtenerPedidoPorId(String id)async{ 
    
    _pedidoIdController.sink.add(await pedidosDatabase.obtenerPedidoPorId(id));
    await pedidoApi.obtenerPedidoPorId(id);
    _pedidoIdController.sink.add(await pedidosDatabase.obtenerPedidoPorId(id));
  }

  void obtenerDetallePedido(String id) async {
    _detallePedidosController.sink
        .add(await pedidosDatabase.obtenerDetallePedidoPorIdPedido(id));
  }
}
