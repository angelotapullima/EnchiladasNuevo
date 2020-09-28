


import 'package:enchiladasapp/src/database/database_provider.dart';
import 'package:enchiladasapp/src/models/zona_model.dart';

class ZonaDatabase{

  final dbprovider = DatabaseProvider.db;

  insertarZonaDb(Zona zona) async {
    try {
      final db = await dbprovider.database;

      final res = await db.rawInsert(
          "INSERT OR REPLACE INTO Zona (id_zona,zona_nombre,zona_pedido_minimo,zona_imagen,zona_tiempo,recargo_producto_nombre,recargo_producto_precio,delivery_producto_nombre,delivery_producto_precio,zona_descripcion) "
              "VALUES ('${zona.idZona}','${zona.zonaNombre}','${zona.zonaPedidoMinimo}','${zona.zonaImagen}','${zona.zonaTiempo}','${zona.recargoProductoNombre}','${zona.recargoProductoPrecio}','${zona.deliveryProductoNombre}','${zona.deliveryProductoPrecio}','${zona.zonaDescripcion}'"
              ")");
      return res;
    } catch (exception) {
      print(exception);
    }
  }

  Future<List<Zona>> obtenerZonas() async {
    final db = await dbprovider.database;
    final res = await db.rawQuery("SELECT * FROM Zona ");

    List<Zona> list = res.isNotEmpty
        ? res.map((c) => Zona.fromJson(c)).toList()
        : [];

    return list;
  }

  Future<List<Zona>> obtenerZonaPorId(String id) async {
    final db = await dbprovider.database;
    final res = await db.rawQuery("SELECT * FROM Zona where id_zona = '$id'");

    List<Zona> list = res.isNotEmpty
        ? res.map((c) => Zona.fromJson(c)).toList()
        : [];

    return list;
  }

}