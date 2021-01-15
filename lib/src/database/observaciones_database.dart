import 'package:enchiladasapp/src/database/database_provider.dart';
import 'package:enchiladasapp/src/models/observaciones_model.dart';

class ObservacionesFijasDatabase {
  final dbprovider = DatabaseProvider.db;

  insertarObservacionesFijas(ObservacionesFijas observacionesFijas) async {
    try {
      final db = await dbprovider.database;

      final res = await db.rawInsert(
          "INSERT OR REPLACE INTO ObservacionesFijas (idProducto,mostrar) "
          "VALUES ('${observacionesFijas.idProducto}','${observacionesFijas.mostrar}'"
          ")");
      return res;
    } catch (exception) {
      print(exception);
    }
  }

  Future<List<ObservacionesFijas>> obtenerObservacionesFijas(
      String idProducto) async {
    final db = await dbprovider.database;
    final res = await db.rawQuery(
        "SELECT * FROM ObservacionesFijas where idProducto='$idProducto'");

    List<ObservacionesFijas> list = res.isNotEmpty
        ? res.map((c) => ObservacionesFijas.fromJson(c)).toList()
        : [];

    return list;
  }

  deleteObservacionesFijas(String idProducto) async {
    final db = await dbprovider.database;

    final res = await db.rawDelete("DELETE FROM ObservacionesFijas where idProducto ='$idProducto'");

    return res;
  }
}


class ProductosFijosDatabase{


final dbprovider = DatabaseProvider.db;

  insertarProductosFijos(ProductosFijos productosFijos) async {
    try {
      final db = await dbprovider.database;

      final res = await db.rawInsert(
          'INSERT OR REPLACE INTO ProductosFijos (idProducto,nombreProducto,idRelacionado) '
          'VALUES ("${productosFijos.idProducto}","${productosFijos.nombreProducto}","${productosFijos.idRelacionado}"'
          ')');
      return res;
    } catch (exception) {
      print(exception);
    }
  }

  Future<List<ProductosFijos>> obtenerProductosFijos(
      String idProducto) async {
    final db = await dbprovider.database;
    final res = await db.rawQuery(
        "SELECT * FROM ProductosFijos where idProducto='$idProducto'");

    List<ProductosFijos> list = res.isNotEmpty
        ? res.map((c) => ProductosFijos.fromJson(c)).toList()
        : [];

    return list;
  }

  deleteProductosFijos(String idProducto) async {
    final db = await dbprovider.database;

    final res = await db.rawDelete("DELETE FROM ProductosFijos where idProducto='$idProducto'");

    return res;
  }
}



class SaboresDatabase{


final dbprovider = DatabaseProvider.db;

  insertarSabores(Sabores sabores) async {
    try {
      final db = await dbprovider.database;

      final res = await db.rawInsert(
          "INSERT OR REPLACE INTO Sabores (idProducto,tituloTextos,maximo) "
          "VALUES ('${sabores.idProducto}','${sabores.tituloTextos}','${sabores.maximo}'"
          ")");
      return res;
    } catch (exception) {
      print(exception);
    }
  }

  Future<List<Sabores>> obtenerSabores(
      String idProducto) async {
    final db = await dbprovider.database;
    final res = await db.rawQuery(
        "SELECT * FROM Sabores where idProducto='$idProducto'");

    List<Sabores> list = res.isNotEmpty
        ? res.map((c) => Sabores.fromJson(c)).toList()
        : [];

    return list;
  }

  deleteSabores(String idProducto) async {
    final db = await dbprovider.database;

    final res = await db.rawDelete("DELETE FROM Sabores where idProducto='$idProducto'");

    return res;
  }
}



class OpcionesSaboresDatabase{


final dbprovider = DatabaseProvider.db;

  insertarOpcionesSabores(OpcionesSabores opcionesSabores) async {
    try {
      final db = await dbprovider.database;

      final res = await db.rawInsert(
          "INSERT OR REPLACE INTO OpcionesSabores (idProducto,tituloTextos,nombreTexto) "
          "VALUES ('${opcionesSabores.idProducto}','${opcionesSabores.tituloTextos}','${opcionesSabores.nombreTexto}'"
          ")");
      return res;
    } catch (exception) {
      print(exception);
    }
  }

  Future<List<OpcionesSabores>> obtenerOpcionesSabores(
      String idProducto,String titulo) async {
    final db = await dbprovider.database;
    final res = await db.rawQuery(
        "SELECT * FROM OpcionesSabores where idProducto='$idProducto' and tituloTextos='$titulo'");

    List<OpcionesSabores> list = res.isNotEmpty
        ? res.map((c) => OpcionesSabores.fromJson(c)).toList()
        : [];

    return list;
  }

  deleteOpcionesSabores(String idProducto) async {
    final db = await dbprovider.database;

    final res = await db.rawDelete("DELETE FROM OpcionesSabores where idProducto='$idProducto' ");

    return res;
  }
}





class AcompanhamientosDatabase{


final dbprovider = DatabaseProvider.db;

  insertarAcompanhamientos(Acompanhamientos acompanhamientos) async {
    try {
      final db = await dbprovider.database;

      final res = await db.rawInsert(
          "INSERT OR REPLACE INTO Acompanhamientos (idProducto,tituloTextos) "
          "VALUES ('${acompanhamientos.idProducto}','${acompanhamientos.tituloTextos}'"
          ")");
      return res;
    } catch (exception) {
      print(exception);
    }
  }

  Future<List<Acompanhamientos>> obtenerAcompanhamientos(
      String idProducto) async {
    final db = await dbprovider.database;
    final res = await db.rawQuery(
        "SELECT * FROM Acompanhamientos where idProducto='$idProducto'");

    List<Acompanhamientos> list = res.isNotEmpty
        ? res.map((c) => Acompanhamientos.fromJson(c)).toList()
        : [];

    return list;
  }

  deleteAcompanhamientos(String idProducto) async {
    final db = await dbprovider.database;

    final res = await db.rawDelete("DELETE FROM Acompanhamientos where idProducto='$idProducto'");

    return res;
  }
}

class OpcionesAcompanhamientosDatabase{


final dbprovider = DatabaseProvider.db;

  insertarOpcionesAcompanhamientos(OpcionesAcompanhamientos opcionesSabores) async {
    try {
      final db = await dbprovider.database;

      final res = await db.rawInsert(
          "INSERT OR REPLACE INTO OpcionesAcompanhamientos (idProducto,tituloTextos,nombreTexto) "
          "VALUES ('${opcionesSabores.idProducto}','${opcionesSabores.tituloTextos}','${opcionesSabores.nombreTexto}'"
          ")");
      return res;
    } catch (exception) {
      print(exception);
    }
  }

  Future<List<OpcionesAcompanhamientos>> obtenerOpcionesAcompanhamientos(
      String idProducto,String titulo) async {
    final db = await dbprovider.database;
    final res = await db.rawQuery(
        "SELECT * FROM OpcionesAcompanhamientos where idProducto='$idProducto' and tituloTextos='$titulo'");

    List<OpcionesAcompanhamientos> list = res.isNotEmpty
        ? res.map((c) => OpcionesAcompanhamientos.fromJson(c)).toList()
        : [];

    return list;
  }

  deleteOpcionesAcompanhamientos(String idProducto) async {
    final db = await dbprovider.database;

    final res = await db.rawDelete("DELETE FROM OpcionesAcompanhamientos where idProducto='$idProducto' ");

    return res;
  }
}

//========================================================================================================
class ObservacionesVariablesDatabase{


final dbprovider = DatabaseProvider.db;

  insertarObservacionesVariables(ObservacionesVariables observacionesVariables) async {
    try {
      final db = await dbprovider.database;

      final res = await db.rawInsert(
          "INSERT OR REPLACE INTO ObservacionesVariables (idProducto,nombreVariable) "
          "VALUES ('${observacionesVariables.idProducto}','${observacionesVariables.nombreVariable}'"
          ")");
      return res; 
    } catch (exception) {
      print(exception);
    }
  }

  Future<List<ObservacionesVariables>> obtenerObservacionesVariables(
      String idProducto) async {
    final db = await dbprovider.database;
    final res = await db.rawQuery(
        "SELECT * FROM ObservacionesVariables where idProducto='$idProducto'");

    List<ObservacionesVariables> list = res.isNotEmpty
        ? res.map((c) => ObservacionesVariables.fromJson(c)).toList()
        : [];

    return list;
  }

  deleteObservacionesVariables(String idProducto) async {
    final db = await dbprovider.database;

    final res = await db.rawDelete("DELETE FROM ObservacionesVariables where idProducto='$idProducto'");

    return res;
  }
}


//=============================================================================================================================
//=============================================================================================================================



