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

  void obtenerUsuarioZona() async {
    final list = List<Zona>();
    final user = await usuarioDatabase.obtenerUsUario();
    if (user[0].idZona != "") {
      final zonas = await zonaDatabase.obtenerZonaPorId(user[0].idZona);
      final producto =
          await productoDatabase.consultarPorId(zonas[0].idProducto);

      Zona zona = Zona();
      zona.idZona = zonas[0].idZona;
      zona.zonaNombre = zonas[0].zonaNombre;
      zona.zonaPedidoMinimo = zonas[0].zonaPedidoMinimo;
      zona.zonaImagen = zonas[0].zonaImagen;
      zona.idProducto = zonas[0].idProducto;
      zona.zonaDescripcion = zonas[0].zonaDescripcion;
      zona.zonaPrecio = producto[0].productoPrecio;
      list.add(zona);
    }

    _zonaUsuarioController.sink.add(list);
  }
}
