import 'package:enchiladasapp/src/database/database_provider.dart';
import 'package:enchiladasapp/src/models/carrito_model.dart';

class CarritoDatabase{

  final dbprovider = DatabaseProvider.db; 

  insertarCarritoDb(Carrito carrito) async {
    try {
      final db = await dbprovider.database;

      final res = await db.rawInsert(
          "INSERT OR REPLACE INTO Carrito (id_producto,producto_nombre,producto_foto,producto_cantidad,producto_precio,producto_tipo,producto_observacion) "
          "VALUES ('${carrito.idProducto}','${carrito.productoNombre}','${carrito.productoFoto}','${carrito.productoCantidad}',"
          "'${carrito.productoPrecio}','${carrito.productoTipo}','${carrito.productoObservacion}')");
      return res;
    } catch (exception) {
      print(exception);
    }
  }

  updateCarritoDb(Carrito carrito)async{
    final db = await dbprovider.database;

    final res = await db.rawUpdate("UPDATE Carrito SET " 
    "producto_nombre='${carrito.productoNombre}', "
    "producto_foto='${carrito.productoFoto}', "
    "producto_cantidad='${carrito.productoCantidad}', "
    "producto_precio='${carrito.productoPrecio}', "
    "producto_tipo='${carrito.productoTipo}', "
    "producto_observacion='${carrito.productoObservacion}' "
    "WHERE id_producto = '${carrito.idProducto}' " 
    );

    return res;
  }
  updateObservacion(String observacion,String id )async{
    final db = await dbprovider.database;

    final res = await db.rawUpdate("UPDATE Carrito SET " 
    
    "producto_observacion='$observacion' "
    "WHERE id_producto = '$id' " 
    );

    return res;
  }

  deleteCarritoDb()async{
    final db = await dbprovider.database;

    final res = await db.rawDelete('DELETE FROM Carrito');

    return res;
  }

  Future<List<Carrito>> consultarCarritoPorId(String id) async {
      final db = await dbprovider.database;
      final res =
          await db.rawQuery("SELECT * FROM Carrito WHERE id_producto='$id'");

      List<Carrito> list = res.isNotEmpty
          ? res.map((c) => Carrito.fromJson(c)).toList()
          : [];

      return list;
  } 

  Future<List<Carrito>> obtenerCarritoDB() async {
    final db = await dbprovider.database;
    final res = await db.query('Carrito');

    List<Carrito> list =
        res.isNotEmpty ? res.map((c) => Carrito.fromJson(c)).toList() : [];

    return list;
  }

  Future<int> deteleProductoCarrito(int id)async{
    final db = await dbprovider.database;
    final res = await db.delete('Carrito',where: 'id_producto = ?',whereArgs: [id]);
    return res;
  }
}