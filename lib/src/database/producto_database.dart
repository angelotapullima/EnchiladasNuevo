import 'package:enchiladasapp/src/database/database_provider.dart';
import 'package:enchiladasapp/src/models/productos_model.dart';

class ProductoDatabase {
  final dbprovider = DatabaseProvider.db;

    insertarProductosDb(ProductosData productos) async { 
    try {
      final db = await dbprovider.database;

      final res = await db.rawInsert(
          'INSERT OR REPLACE INTO Producto (id_producto,id_categoria,producto_nombre,producto_foto,producto_orden,'
          'producto_precio,producto_carta,producto_delivery,producto_sonido,'
          'producto_unidad,producto_destacado,producto_estado_destacado,categoriaTipo,categoriaTipo2,producto_tupper,producto_estado,producto_nuevo,'
          'producto_descripcion,producto_comentario,producto_favorito) '
          'VALUES ( "${productos.idProducto}" , "${productos.idCategoria}" , "${productos.productoNombre}" ,'
          ' "${productos.productoFoto}" ,"${productos.productoOrden}" , "${productos.productoPrecio}" ,'
          ' "${productos.productoCarta}" ,"${productos.productoDelivery}",'
          ' "${productos.sonido}" ,"${productos.productoUnidad}","${productos.productoDestacado}","${productos.productoEstadoDestacado}","${productos.categoriaTipo}","${productos.categoriaTipo2}",'
          '"${productos.productoTupper}","${productos.productoEstado}","${productos.productoNuevo}",'
          '"${productos.productoDescripcion}", "${productos.productoComentario}",${productos.productoFavorito} )');
      return res;
    } catch (exception) {
      print(exception);
    }
  }  

  updateProductosDb(ProductosData productos) async {
    final db = await dbprovider.database;

    final res = await db.rawUpdate('UPDATE Producto SET '
        'id_categoria="${productos.idCategoria}", '
        'producto_nombre="${productos.productoNombre}", '
        'producto_foto="${productos.productoFoto}", '
        'producto_orden="${productos.productoOrden}", '
        'producto_precio="${productos.productoPrecio}", '
        'producto_carta="${productos.productoCarta}", '
        'producto_delivery="${productos.productoDelivery}", '
        'producto_unidad="${productos.productoUnidad}", '
        'producto_estado="${productos.productoEstado}", '
        'producto_favorito="${productos.productoFavorito}",'
        'producto_destacado="${productos.productoDestacado}",'
        'categoriaTipo="${productos.categoriaTipo}",'
        'categoriaTipo2="${productos.categoriaTipo2}",'
        'producto_estado_destacado="${productos.productoEstadoDestacado}",'
        'producto_tupper="${productos.productoTupper}",'
        'producto_sonido="${productos.sonido}",'
        'producto_nuevo="${productos.productoNuevo}",'
        'producto_descripcion="${productos.productoDescripcion}", '
        'producto_comentario="${productos.productoComentario}" '
        'WHERE id_producto = "${productos.idProducto}"');

    return res;
  }

  Future<List<ProductosData>> consultarPorId(String id) async {
    final db = await dbprovider.database;
    final res = await db.rawQuery(
        "SELECT * FROM Producto WHERE id_producto='$id' and producto_estado='1' ");

    List<ProductosData> list = res.isNotEmpty
        ? res.map((c) => ProductosData.fromJson(c)).toList()
        : [];

    return list;
  }


  Future<List<ProductosData>> consultarPorQuery(String query,String tipo) async {
    final db = await dbprovider.database;
    final res = await db.rawQuery(
        "SELECT * FROM Producto WHERE producto_nombre LIKE '%$query%' and producto_estado='1' and (categoriaTipo = '$tipo' or categoriaTipo2 = '$tipo')");

    List<ProductosData> list = res.isNotEmpty
        ? res.map((c) => ProductosData.fromJson(c)).toList()
        : [];

    return list;
  }


  Future<List<ProductosData>> obtenerProductosPorCategoria(
      String id) async {
    final db = await dbprovider.database;
    final res = await db.rawQuery(
        "SELECT * FROM Producto WHERE id_categoria='$id' and producto_estado='1' and producto_delivery='1' order by CAST(producto_orden AS INT) ASC");

    List<ProductosData> list = res.isNotEmpty
        ? res.map((c) => ProductosData.fromJson(c)).toList()
        : [];

    return list;
  }

  Future<List<ProductosData>> obtenerPropinas(String id) async {
    final db = await dbprovider.database;
    final res = await db.rawQuery(
        "SELECT * FROM Producto WHERE id_categoria='$id'  order by CAST(producto_orden AS INT) ASC");

    List<ProductosData> list = res.isNotEmpty
        ? res.map((c) => ProductosData.fromJson(c)).toList()
        : [];

    return list;
  }


  Future<List<ProductosData>> obtenerFavoritos() async {
    final db = await dbprovider.database;
    final res = await db.rawQuery(
        "SELECT * FROM Producto WHERE producto_favorito = 1 and producto_estado='1' ");

    List<ProductosData> list = res.isNotEmpty
        ? res.map((c) => ProductosData.fromJson(c)).toList()
        : [];

    return list;
  }
}
