import 'package:enchiladasapp/src/database/database_provider.dart';
import 'package:enchiladasapp/src/models/productos._model.dart';

class ProductoDatabase{

  final dbprovider = DatabaseProvider.db;

  insertarProductosDb(ProductosData productos) async {
    final db = await dbprovider.database;

    
    final res = await db.rawInsert(
        "INSERT OR REPLACE INTO Producto (id_producto,id_categoria,producto_nombre,producto_foto,producto_precio,producto_unidad,producto_estado,producto_descripcion,producto_favorito) "
        "VALUES ( '${productos.idProducto}' , '${productos.idCategoria}' , '${productos.productoNombre}' ,"
        " '${productos.productoFoto}' , '${productos.productoPrecio}' , '${productos.productoUnidad}' ,"
        " '${productos.productoEstado}','${productos.productoDescripcion}', ${productos.productoFavorito} )");
    return res;
  } 

  updateProductosDb(ProductosData productos)async{
    final db = await dbprovider.database;

    final res = await db.rawUpdate("UPDATE Producto SET "
    "id_categoria='${productos.idCategoria}', "
    "producto_nombre='${productos.productoNombre}', "
    "producto_foto='${productos.productoFoto}', "
    "producto_precio='${productos.productoPrecio}', "
    "producto_unidad='${productos.productoUnidad}', "
    "producto_estado='${productos.productoEstado}', "
    "producto_favorito='${productos.productoFavorito}' "
    "WHERE id_producto = '${productos.idProducto}'" 
    );

    return res;
  } 

  

  Future<List<ProductosData>> consultarPorId(String id) async {
      final db = await dbprovider.database;
      final res =
          await db.rawQuery("SELECT * FROM Producto WHERE id_producto='$id' and producto_estado='1' ");

      List<ProductosData> list = res.isNotEmpty
          ? res.map((c) => ProductosData.fromJson(c)).toList()
          : [];

      return list;
    }
    Future<List<ProductosData>> consultarPorQuery(String query) async {
      final db = await dbprovider.database;
      final res =
          await db.rawQuery("SELECT * FROM Producto WHERE producto_nombre LIKE '$query%' and producto_estado='1' ");

      List<ProductosData> list = res.isNotEmpty
          ? res.map((c) => ProductosData.fromJson(c)).toList()
          : [];

      return list;
    }
   
  Future<List<ProductosData>> obtenerProductosPorCategoria(String id) async {
    final db = await dbprovider.database;
    final res =
        await db.rawQuery("SELECT * FROM Producto WHERE id_categoria='$id' and producto_estado='1' ");

    List<ProductosData> list = res.isNotEmpty
        ? res.map((c) => ProductosData.fromJson(c)).toList()
        : [];

    return list;
  }

  Future<List<ProductosData>> obtenerFavoritos() async {
    final db = await dbprovider.database;
    final res =
        await db.rawQuery("SELECT * FROM Producto WHERE producto_favorito = 1 and producto_estado='1' ");

    List<ProductosData> list = res.isNotEmpty
        ? res.map((c) => ProductosData.fromJson(c)).toList()
        : [];

    return list;
  }
  
}