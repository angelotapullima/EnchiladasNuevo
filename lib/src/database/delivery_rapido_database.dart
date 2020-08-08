

import 'package:enchiladasapp/src/database/database_provider.dart';
import 'package:enchiladasapp/src/models/delivery_rapido_model.dart';

class DeliveryRapidoDatabase{

  final dbprovider = DatabaseProvider.db;

  insertarDeliveryRapidoDb(DeliveryRapido delivery) async {
    final db = await dbprovider.database;

    final res = await db.rawInsert(
        "INSERT OR REPLACE INTO DeliveryRapido (id_delivery,id_producto) "
        "VALUES ('${delivery.idDelivery}','${delivery.idProducto}')");
    return res;
  }

  Future<List<DeliveryRapido>> obtenerDeliveryRapido() async {
    final db = await dbprovider.database;
    final res = await db.rawQuery("SELECT * FROM DeliveryRapido ");

    List<DeliveryRapido> list = res.isNotEmpty
        ? res.map((c) => DeliveryRapido.fromJson(c)).toList()
        : [];

    return list;
  }

  deleteDeliveryRapido() async {
    final db = await dbprovider.database;

    final res = await db.rawDelete('DELETE FROM DeliveryRapido');

    return res;
  }
}