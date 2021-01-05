import 'package:enchiladasapp/src/database/database_provider.dart';
import 'package:enchiladasapp/src/models/productos_model.dart';

class ItemObservacionDatabase {
  final dbprovider = DatabaseProvider.db;

  insertarItemObservacion(ProductosData productos) async {
    final db = await dbprovider.database;
 
    final res = await db.rawInsert(
        'INSERT OR REPLACE INTO ItemObservacion (id_producto,id_categoria,producto_nombre,producto_foto,'
        'producto_precio,producto_tupper,producto_observacion) '
        'VALUES ( "${productos.idProducto}" ,   "${productos.idCategoria}" ,"${productos.productoNombre}" ,'
        ' "${productos.productoFoto}" , "${productos.productoPrecio}" ,"${productos.productoTupper}","${productos.productoObservacion}" )');
    return res;
  }

  deleteItemObservacion() async {
    final db = await dbprovider.database;

    final res = await db.rawDelete("DELETE FROM ItemObservacion ");

    return res;
  }


  deleteItemObservacionPorProducto(String idProdcuto) async {
    final db = await dbprovider.database;

    final res = await db.rawDelete("DELETE FROM ItemObservacion where id_producto='$idProdcuto'");

    return res;
  }



updateObservacion(String observacion,String idProducto) async {
    final db = await dbprovider.database;

    final res = await db.rawUpdate('UPDATE ItemObservacion SET '
        'producto_observacion="$observacion" '
        'WHERE id_producto = "$idProducto"');

    return res;
  }


  Future<List<ProductosData>> obtenerItemObservacion() async {
    final db = await dbprovider.database;
    final res = await db.rawQuery("SELECT * FROM ItemObservacion ");

    List<ProductosData> list = res.isNotEmpty
        ? res.map((c) => ProductosData.fromJson(c)).toList()
        : [];

    return list;
  }
}
