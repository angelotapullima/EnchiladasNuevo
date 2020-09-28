
 
import 'package:enchiladasapp/src/database/database_provider.dart';
import 'package:enchiladasapp/src/models/categoria_model.dart';


class CategoriasDatabase{

  final dbprovider = DatabaseProvider.db;


 
  insertarCategoriasDb(CategoriaData categoriaData) async {
    final db = await dbprovider.database;

    final res = await db.rawInsert(
        "INSERT OR REPLACE INTO Categorias (id_categoria,categoria_nombre,categoria_estado,categoria_tipo,"
        "categoria_promocion,categoria_foto,categoria_icono,categoria_banner,categoria_mostrar_app) "
        "VALUES ('${categoriaData.idCategoria}','${categoriaData.categoriaNombre}','${categoriaData.categoriaEstado}',"
        "'${categoriaData.categoriaTipo}', '${categoriaData.categoriaPromocion}','${categoriaData.categoriaFoto}',"
        "'${categoriaData.categoriaIcono}','${categoriaData.categoriaBanner}','${categoriaData.categoriaMostrarApp}')");
    return res;
  }

    /* updateCategoriaDb(CategoriaData categorias)async{
    final db = await dbprovider.database;

    final res = await db.rawUpdate("UPDATE Categorias SET " 
    "categoria_nombre='${categorias.categoriaNombre}', "
    "categoria_estado='${categorias.categoriaEstado}', "
    "categoria_tipo='${categorias.categoriaTipo}', "
    "categoria_mostrar_app='${categorias.categoriaMostrarApp}' "
    "WHERE id_categoria = '${categorias.idCategoria}'" 
    );

    return res;
  }  */

  Future<List<CategoriaData>> obtenerCategoriasEnchiladas() async {
    final db = await dbprovider.database;
    final res = await db.rawQuery("SELECT * FROM Categorias where categoria_tipo = '1' and categoria_mostrar_app='1'");

    List<CategoriaData> list = res.isNotEmpty
        ? res.map((c) => CategoriaData.fromJson(c)).toList()
        : [];

    return list; 
  }

  Future<List<CategoriaData>> obtenerCategoriasMarket() async {
    final db = await dbprovider.database;
    final res = await db.rawQuery("SELECT * FROM Categorias where categoria_tipo = '2' and categoria_mostrar_app='1'");

    List<CategoriaData> list = res.isNotEmpty
        ? res.map((c) => CategoriaData.fromJson(c)).toList()
        : [];

    return list;
  }

  Future<List<CategoriaData>> obtenerCategoriasPromociones() async {
    final db = await dbprovider.database;
    final res = await db.rawQuery("SELECT * FROM Categorias where categoria_promocion = '1' and categoria_mostrar_app='1'");

    List<CategoriaData> list = res.isNotEmpty
        ? res.map((c) => CategoriaData.fromJson(c)).toList()
        : [];

    return list;
  }


  Future<List<CategoriaData>> obtenerCategoriasTodos() async {
    final db = await dbprovider.database;
    final res = await db.rawQuery("SELECT * FROM Categorias where categoria_mostrar_app='1' ORDER BY id_categoria DESC");

    List<CategoriaData> list = res.isNotEmpty
        ? res.map((c) => CategoriaData.fromJson(c)).toList()
        : [];

    return list;
  }

  Future<List<CategoriaData>> consultarPorId(String id) async {
      final db = await dbprovider.database;
      final res =
          await db.rawQuery("SELECT * FROM Categorias WHERE id_categoria='$id' and categoria_mostrar_app='1'");

      List<CategoriaData> list = res.isNotEmpty
          ? res.map((c) => CategoriaData.fromJson(c)).toList()
          : [];

      return list;
  }
}