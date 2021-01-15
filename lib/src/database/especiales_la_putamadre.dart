

import 'package:enchiladasapp/src/database/database_provider.dart';
import 'package:enchiladasapp/src/models/observaciones_model.dart';

class EspecialesADatabase{


final dbprovider = DatabaseProvider.db;

  insertarEspecialesA(Sabores especialesA) async {
    try {
      final db = await dbprovider.database;

      final res = await db.rawInsert(
          "INSERT OR REPLACE INTO EspecialesA (idProducto,tituloTextos,maximo) "
          "VALUES ('${especialesA.idProducto}','${especialesA.tituloTextos}','${especialesA.maximo}'"
          ")");
      return res;
    } catch (exception) {
      print(exception);
    }
  }

  Future<List<Sabores>> obtenerEspecialesA(
      String idProducto) async {
    final db = await dbprovider.database;
    final res = await db.rawQuery(
        "SELECT * FROM EspecialesA where idProducto='$idProducto'");

    List<Sabores> list = res.isNotEmpty
        ? res.map((c) => Sabores.fromJson(c)).toList()
        : [];

    return list;
  }

  deleteEspecialesA(String idProducto) async {
    final db = await dbprovider.database;

    final res = await db.rawDelete("DELETE FROM EspecialesA where idProducto='$idProducto'");

    return res;
  }
}



class OpcionesEspecialesADatabase{


final dbprovider = DatabaseProvider.db;

  insertarOpcionesEspecialesA(OpcionesSabores opcionesEspecialesA) async {
    try {
      final db = await dbprovider.database;

      final res = await db.rawInsert(
          "INSERT OR REPLACE INTO OpcionesEspecialesA (idProducto,tituloTextos,nombreTexto) "
          "VALUES ('${opcionesEspecialesA.idProducto}','${opcionesEspecialesA.tituloTextos}','${opcionesEspecialesA.nombreTexto}'"
          ")");
      return res;
    } catch (exception) {
      print(exception);
    }
  }

  Future<List<OpcionesSabores>> obtenerOpcionesEspecialesA(
      String idProducto,String titulo) async {
    final db = await dbprovider.database;
    final res = await db.rawQuery(
        "SELECT * FROM OpcionesEspecialesA where idProducto='$idProducto' and tituloTextos='$titulo'");

    List<OpcionesSabores> list = res.isNotEmpty
        ? res.map((c) => OpcionesSabores.fromJson(c)).toList()
        : [];

    return list;
  }

  deleteOpcionesEspecialesA(String idProducto) async {
    final db = await dbprovider.database;

    final res = await db.rawDelete("DELETE FROM OpcionesEspecialesA where idProducto='$idProducto' ");

    return res;
  }
}

//especialesB
class EspecialesBDatabase{


final dbprovider = DatabaseProvider.db;

  insertarEspecialesB(Sabores especialesB) async {
    try {
      final db = await dbprovider.database;

      final res = await db.rawInsert(
          "INSERT OR REPLACE INTO EspecialesB (idProducto,tituloTextos,maximo) "
          "VALUES ('${especialesB.idProducto}','${especialesB.tituloTextos}','${especialesB.maximo}'"
          ")");
      return res;
    } catch (exception) {
      print(exception);
    }
  }

  Future<List<Sabores>> obtenerEspecialesB(
      String idProducto) async {
    final db = await dbprovider.database;
    final res = await db.rawQuery(
        "SELECT * FROM EspecialesB where idProducto='$idProducto'");

    List<Sabores> list = res.isNotEmpty
        ? res.map((c) => Sabores.fromJson(c)).toList()
        : [];

    return list;
  }

  deleteEspecialesB(String idProducto) async {
    final db = await dbprovider.database;

    final res = await db.rawDelete("DELETE FROM EspecialesB where idProducto='$idProducto'");

    return res;
  }
}

class OpcionesEspecialesBDatabase{


final dbprovider = DatabaseProvider.db;

  insertarOpcionesEspecialesB(OpcionesSabores opcionesEspecialesB) async {
    try {
      final db = await dbprovider.database;

      final res = await db.rawInsert(
          "INSERT OR REPLACE INTO OpcionesEspecialesB (idProducto,tituloTextos,nombreTexto) "
          "VALUES ('${opcionesEspecialesB.idProducto}','${opcionesEspecialesB.tituloTextos}','${opcionesEspecialesB.nombreTexto}'"
          ")");
      return res;
    } catch (exception) {
      print(exception);
    }
  }

  Future<List<OpcionesSabores>> obtenerOpcionesEspecialesB(
      String idProducto,String titulo) async {
    final db = await dbprovider.database;
    final res = await db.rawQuery(
        "SELECT * FROM OpcionesEspecialesB where idProducto='$idProducto' and tituloTextos='$titulo'");

    List<OpcionesSabores> list = res.isNotEmpty
        ? res.map((c) => OpcionesSabores.fromJson(c)).toList()
        : [];

    return list;
  }

  deleteOpcionesEspecialesB(String idProducto) async {
    final db = await dbprovider.database;

    final res = await db.rawDelete("DELETE FROM OpcionesEspecialesB where idProducto='$idProducto' ");

    return res;
  }
}



//especialesC
class EspecialesCDatabase{


final dbprovider = DatabaseProvider.db;

  insertarEspecialesC(Sabores especialesC) async {
    try {
      final db = await dbprovider.database;

      final res = await db.rawInsert(
          "INSERT OR REPLACE INTO EspecialesC (idProducto,tituloTextos,maximo) "
          "VALUES ('${especialesC.idProducto}','${especialesC.tituloTextos}','${especialesC.maximo}'"
          ")");
      return res;
    } catch (exception) {
      print(exception);
    }
  }

  Future<List<Sabores>> obtenerEspecialesC(
      String idProducto) async {
    final db = await dbprovider.database;
    final res = await db.rawQuery(
        "SELECT * FROM EspecialesC where idProducto='$idProducto'");

    List<Sabores> list = res.isNotEmpty
        ? res.map((c) => Sabores.fromJson(c)).toList()
        : [];

    return list;
  }

  deleteEspecialesC(String idProducto) async {
    final db = await dbprovider.database;

    final res = await db.rawDelete("DELETE FROM EspecialesC where idProducto='$idProducto'");

    return res;
  }
}

class OpcionesEspecialesCDatabase{


final dbprovider = DatabaseProvider.db;

  insertarOpcionesEspecialesC(OpcionesSabores opcionesEspecialesC) async {
    try {
      final db = await dbprovider.database;

      final res = await db.rawInsert(
          "INSERT OR REPLACE INTO OpcionesEspecialesC (idProducto,tituloTextos,nombreTexto) "
          "VALUES ('${opcionesEspecialesC.idProducto}','${opcionesEspecialesC.tituloTextos}','${opcionesEspecialesC.nombreTexto}'"
          ")");
      return res;
    } catch (exception) {
      print(exception);
    }
  }

  Future<List<OpcionesSabores>> obtenerOpcionesEspecialesC(
      String idProducto,String titulo) async {
    final db = await dbprovider.database;
    final res = await db.rawQuery(
        "SELECT * FROM OpcionesEspecialesC where idProducto='$idProducto' and tituloTextos='$titulo'");

    List<OpcionesSabores> list = res.isNotEmpty
        ? res.map((c) => OpcionesSabores.fromJson(c)).toList()
        : [];

    return list;
  }

  deleteOpcionesEspecialesC(String idProducto) async {
    final db = await dbprovider.database;

    final res = await db.rawDelete("DELETE FROM OpcionesEspecialesC where idProducto='$idProducto' ");

    return res;
  }
}

//especialesD
class EspecialesDDatabase{


final dbprovider = DatabaseProvider.db;

  insertarEspecialesD(Sabores especialesD) async {
    try {
      final db = await dbprovider.database;

      final res = await db.rawInsert(
          "INSERT OR REPLACE INTO EspecialesD (idProducto,tituloTextos,maximo) "
          "VALUES ('${especialesD.idProducto}','${especialesD.tituloTextos}','${especialesD.maximo}'"
          ")");
      return res;
    } catch (exception) {
      print(exception);
    }
  }

  Future<List<Sabores>> obtenerEspecialesD(
      String idProducto) async {
    final db = await dbprovider.database;
    final res = await db.rawQuery(
        "SELECT * FROM EspecialesD where idProducto='$idProducto'");

    List<Sabores> list = res.isNotEmpty
        ? res.map((c) => Sabores.fromJson(c)).toList()
        : [];

    return list;
  }

  deleteEspecialesD(String idProducto) async {
    final db = await dbprovider.database;

    final res = await db.rawDelete("DELETE FROM EspecialesD where idProducto='$idProducto'");

    return res;
  }
}

class OpcionesEspecialesDDatabase{


final dbprovider = DatabaseProvider.db;

  insertarOpcionesEspecialesD(OpcionesSabores opcionesEspecialesD) async {
    try {
      final db = await dbprovider.database;

      final res = await db.rawInsert(
          "INSERT OR REPLACE INTO OpcionesEspecialesD (idProducto,tituloTextos,nombreTexto) "
          "VALUES ('${opcionesEspecialesD.idProducto}','${opcionesEspecialesD.tituloTextos}','${opcionesEspecialesD.nombreTexto}'"
          ")");
      return res;
    } catch (exception) {
      print(exception);
    }
  }

  Future<List<OpcionesSabores>> obtenerOpcionesEspecialesD(
      String idProducto,String titulo) async {
    final db = await dbprovider.database;
    final res = await db.rawQuery(
        "SELECT * FROM OpcionesEspecialesD where idProducto='$idProducto' and tituloTextos='$titulo'");

    List<OpcionesSabores> list = res.isNotEmpty
        ? res.map((c) => OpcionesSabores.fromJson(c)).toList()
        : [];

    return list;
  }

  deleteOpcionesEspecialesD(String idProducto) async {
    final db = await dbprovider.database;

    final res = await db.rawDelete("DELETE FROM OpcionesEspecialesD where idProducto='$idProducto' ");

    return res;
  }
}








