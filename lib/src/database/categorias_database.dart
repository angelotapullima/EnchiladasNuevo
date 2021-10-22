import 'package:enchiladasapp/src/database/database_provider.dart';
import 'package:enchiladasapp/src/models/categoria_model.dart';

class CategoriasDatabase {
  final dbprovider = DatabaseProvider.db;

  insertarCategoriasDb(CategoriaData categoriaData) async {
    final db = await dbprovider.database;

    final res = await db.rawInsert('INSERT OR REPLACE INTO Categorias (id_categoria,categoria_nombre,categoria_estado,categoria_tipo,categoriaTipo2,categoria_orden,'
        'categoria_promocion,categoria_sonido,categoria_foto,categoria_icono,categoria_banner,categoria_mostrar_app) '
        'VALUES ("${categoriaData.idCategoria}","${categoriaData.categoriaNombre}","${categoriaData.categoriaEstado}",'
        '"${categoriaData.categoriaTipo}","${categoriaData.categoriaTipo2}","${categoriaData.categoriaOrden}", "${categoriaData.categoriaPromocion}",'
        '"${categoriaData.categoriaSonido}","${categoriaData.categoriaFoto}",'
        '"${categoriaData.categoriaIcono}","${categoriaData.categoriaBanner}","${categoriaData.categoriaMostrarApp}")');
    return res;
  }

  //Se usara para los categorias con tipo Unidos -- Delivery
  Future<List<CategoriaData>> obtenerCategoriasPorTipoUnidos(String tipo) async {
    final db = await dbprovider.database;
    final res = await db.rawQuery(
        "SELECT * FROM Categorias where  categoria_mostrar_app='1' and (categoria_tipo in (5,6,7) or categoriaTipo2 in (5,6,7) )     order by CAST(categoria_orden AS INT) ASC");

    List<CategoriaData> list = res.isNotEmpty ? res.map((c) => CategoriaData.fromJson(c)).toList() : [];

    return list;
  }

  //Se usara para los categorias con tipo Unidos -- Cafe-VAR-Salon
  Future<List<CategoriaData>> obtenerCategoriasPorTipo(String tipo) async {
    final db = await dbprovider.database;
    final res = await db.rawQuery(
        "SELECT * FROM Categorias where categoria_mostrar_app='1'  and  (categoria_tipo = '$tipo' or categoriaTipo2 = '$tipo' )   order by CAST(categoria_orden AS INT) ASC");

    List<CategoriaData> list = res.isNotEmpty ? res.map((c) => CategoriaData.fromJson(c)).toList() : [];

    return list;
  }

  //Se usara para los categorias con tipo desplegadas
  Future<List<CategoriaData>> obtenerCategoriasPromociones(String tipo) async {
    final db = await dbprovider.database;
    final res =
        await db.rawQuery("SELECT * FROM Categorias where  categoria_promocion = '1' and categoria_mostrar_app='1' and (categoria_tipo = '$tipo' or categoriaTipo2 = '$tipo')    ");

    List<CategoriaData> list = res.isNotEmpty ? res.map((c) => CategoriaData.fromJson(c)).toList() : [];

    return list;
  }

  //Se usara para los categorias con tipo unidas
  Future<List<CategoriaData>> obtenerCategoriasPromocionesUnidas(String tipo) async {
    final db = await dbprovider.database;
    final res =
        await db.rawQuery("SELECT * FROM Categorias where categoria_promocion = '1' and categoria_mostrar_app='1' and( categoria_tipo in (5,6,7) or categoriaTipo2 in (5,6,7) )  ");

    List<CategoriaData> list = res.isNotEmpty ? res.map((c) => CategoriaData.fromJson(c)).toList() : [];

    return list;
  }

  ///////////////////////////////////////////////////////////////////////////////////////////////

  Future<List<CategoriaData>> consultarPorId(String id) async {
    final db = await dbprovider.database;
    final res = await db.rawQuery("SELECT * FROM Categorias WHERE id_categoria='$id' and categoria_mostrar_app='1'");

    List<CategoriaData> list = res.isNotEmpty ? res.map((c) => CategoriaData.fromJson(c)).toList() : [];

    return list;
  }
}
