import 'package:enchiladasapp/src/database/database_provider.dart';
import 'package:enchiladasapp/src/models/productos_model.dart';

class AdicionalesDatabase {
  final dbprovider = DatabaseProvider.db;

  insertarProductosDb(ProductosData productos) async {
    final db = await dbprovider.database;

    final res = await db.rawInsert(
        'INSERT OR REPLACE INTO Adicionales (id_producto,id_categoria,producto_nombre,producto_foto,'
        'producto_precio,producto_carta,producto_seleccionado,producto_estado,producto_descripcion) '
        'VALUES ( "${productos.idProducto}" , "${productos.idCategoria}" , "${productos.productoNombre}" ,'
        ' "${productos.productoFoto}" , "${productos.productoPrecio}" , "${productos..productoCarta}",'
        '"${productos.productoSeleccionado}","${productos.productoEstado}","${productos.productoDescripcion}" )');
    return res;
  }

  updateAdicionalesEnFalseDb() async {
    final db = await dbprovider.database;

    final res =
        await db.rawUpdate('UPDATE Adicionales SET producto_seleccionado="0" ');

    return res;
  }


updateAdicionalesEnfalsePorId(ProductosData productos) async {
    final db = await dbprovider.database;

    final res = await db.rawUpdate('UPDATE Adicionales SET '
        'id_categoria="${productos.idCategoria}",'
        'producto_nombre="${productos.productoNombre}",'
        'producto_foto="${productos.productoFoto}",'
        'producto_precio="${productos.productoPrecio}",'
        'producto_carta="${productos.productoCarta}",'
        'producto_seleccionado="0",'
        'producto_estado="${productos.productoEstado}",'
        'producto_descripcion="${productos.productoDescripcion}" '
        'WHERE id_producto = "${productos.idProducto}"');

    return res;
  }

updateAdicionalesEnTrueDb(ProductosData productos) async {
    final db = await dbprovider.database;

    final res = await db.rawUpdate('UPDATE Adicionales SET '
        'id_categoria="${productos.idCategoria}",'
        'producto_nombre="${productos.productoNombre}",'
        'producto_foto="${productos.productoFoto}",'
        'producto_precio="${productos.productoPrecio}",'
        'producto_carta="${productos.productoCarta}",'
        'producto_seleccionado="1",'
        'producto_estado="${productos.productoEstado}",'
        'producto_descripcion="${productos.productoDescripcion}" '
        'WHERE id_producto = "${productos.idProducto}"');

    return res;
  }
  

  Future<List<ProductosData>> consultarAdicionalPorId(String id) async {
    final db = await dbprovider.database;
    final res =
        await db.rawQuery("SELECT * FROM Adicionales WHERE id_producto='$id' and  producto_estado='1'");

    List<ProductosData> list = res.isNotEmpty
        ? res.map((c) => ProductosData.fromJson(c)).toList()
        : [];

    return list;
  }

  Future<List<ProductosData>> obtenerAdicionales(String idCategoria) async {
    final db = await dbprovider.database;
    final res = await db.rawQuery("SELECT * FROM Adicionales where id_categoria='$idCategoria' and producto_estado='1'");

    List<ProductosData> list = res.isNotEmpty
        ? res.map((c) => ProductosData.fromJson(c)).toList()
        : [];

    return list;
  }



  deleteAdicionales() async {
    final db = await dbprovider.database;

    final res = await db.rawDelete("DELETE FROM Adicionales");

    return res;
  }

}
