import 'package:enchiladasapp/src/api/configuracion_api.dart';
import 'package:enchiladasapp/src/database/producto_database.dart';
import 'package:enchiladasapp/src/database/usuario_database.dart';
import 'package:enchiladasapp/src/database/zona_database.dart';
import 'package:enchiladasapp/src/models/zona_model.dart';
import 'package:rxdart/rxdart.dart';

class ZonaBloc {
  final zonaDatabase = ZonaDatabase();
  final productoDatabase = ProductoDatabase();
  final configuracionApi = ConfiguracionApi();

  final usuarioDatabase = UsuarioDatabase();

  final _zonaController = new BehaviorSubject<List<Zona>>();
  final _zonaUsuarioController = new BehaviorSubject<List<Zona>>();

  Stream<List<Zona>> get zonasStream => _zonaController.stream;
  Stream<List<Zona>> get zonaUsuarioStream => _zonaUsuarioController.stream;

  dispose() {
    _zonaController?.close();
    _zonaUsuarioController?.close();
  }

  void obtenerZonas() async {
    _zonaController.sink.add(await zonaDatabase.obtenerZonas());
    await configuracionApi.configuracion();
    _zonaController.sink.add(await zonaDatabase.obtenerZonas());
  }

  }