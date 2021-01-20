import 'package:enchiladasapp/src/database/database_provider.dart';
import 'package:enchiladasapp/src/models/adicionales_model.dart';

class AdicionalesDatabase { 
  final dbprovider = DatabaseProvider.db; 

  insertarAdicionales(AdicionalesModel adicionalesModel) async {
    final db = await dbprovider.database;

    final res = await db.rawInsert(
        'INSERT OR REPLACE INTO Adicionales (id_producto,id_producto_adicional,adicional_item,titulo,adicional_seleccionado) '
        'VALUES ( "${adicionalesModel.idProducto}" , "${adicionalesModel.idProductoAdicional}" ,  "${adicionalesModel.adicionalItem}" ,"${adicionalesModel.titulo}" ,"${adicionalesModel.adicionalSeleccionado}"  )');
    return res;
  }

  Future<List<AdicionalesModel>> obtenerAdicionales(String idProducto,String item) async {
    final db = await dbprovider.database;
    final res = await db
        .rawQuery("SELECT * FROM Adicionales where id_producto='$idProducto' and  adicional_item='$item'");

    List<AdicionalesModel> list = res.isNotEmpty
        ? res.map((c) => AdicionalesModel.fromJson(c)).toList()
        : [];

    return list;
  }


Future<List<AdicionalesModel>> obtenerAdicionalesNumeroItem(String idProducto) async {
    final db = await dbprovider.database;
    final res = await db
        .rawQuery("SELECT * FROM Adicionales where id_producto='$idProducto' group by adicional_item");

    List<AdicionalesModel> list = res.isNotEmpty
        ? res.map((c) => AdicionalesModel.fromJson(c)).toList()
        : [];

    return list;
  }

  updateAdicionalesEnfalsePorId(String  idProducto,String idProductoAdicional ,String numeroItem) async {
    final db = await dbprovider.database;

    final res = await db.rawUpdate('UPDATE Adicionales SET '
       
        'adicional_seleccionado="0" '
        'WHERE id_producto = "$idProducto" and id_producto_adicional="$idProductoAdicional"  and adicional_item="$numeroItem"');

    return res;
  }


  updateAdicionalesEnFalseDb() async {
    final db = await dbprovider.database;

    final res = await db.rawUpdate('UPDATE Adicionales SET '
       
        'adicional_seleccionado="0"');

    return res;
  }

  updateAdicionalesEnTrueDb(String  idProducto,String idProductoAdicional,String item) async {
    final db = await dbprovider.database;

    final res = await db.rawUpdate('UPDATE Adicionales SET '
       
          'adicional_seleccionado="1" '
        'WHERE id_producto = "$idProducto" and id_producto_adicional="$idProductoAdicional" and adicional_item="$item" ');


    return res;
  }


  deleteAdicionalesPorId(String idProducto,String numeroItem) async {
    final db = await dbprovider.database;

    final res = await db.rawDelete("DELETE FROM Adicionales where id_producto = '$idProducto' and adicional_item='$numeroItem' ");

    return res;
  }
}
