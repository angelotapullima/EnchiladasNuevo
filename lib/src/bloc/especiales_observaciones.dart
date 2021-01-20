



import 'package:enchiladasapp/src/database/especiales_la_putamadre.dart';
import 'package:enchiladasapp/src/models/observaciones_model.dart';

class EspecialesObservaciones{



  final especialesADatabase = EspecialesADatabase();
  final opcionesespecialesADatabase = OpcionesEspecialesADatabase();

  final especialesBDatabase = EspecialesBDatabase();
  final opcionesespecialesBDatabase = OpcionesEspecialesBDatabase();

  final especialesCDatabase = EspecialesCDatabase();
  final opcionesespecialesCDatabase = OpcionesEspecialesCDatabase();

  final especialesDDatabase = EspecialesDDatabase();
  final opcionesespecialesDDatabase = OpcionesEspecialesDDatabase();




// ESPECIALES A

  Future<List<Sabores>> obtenerEspecialesA(String idProducto) async {
    final listEspecialesA = List<Sabores>();

    final listEspecialesADatabase =
        await especialesADatabase.obtenerEspecialesA(idProducto);

    if (listEspecialesADatabase.length > 0) {
      for (var i = 0; i < listEspecialesADatabase.length; i++) {
        Sabores sabores = Sabores();
        sabores.idProducto = listEspecialesADatabase[i].idProducto;
        sabores.tituloTextos = listEspecialesADatabase[i].tituloTextos;
        sabores.maximo = listEspecialesADatabase[i].maximo;
        sabores.opciones = await obtenerOpcionesEspecialesA(idProducto, listEspecialesADatabase[i].tituloTextos);
        sabores.nombrecitos = await nombrecitosEspecialesA(idProducto, listEspecialesADatabase[i].tituloTextos);

        listEspecialesA.add(sabores);
      }
    }

    return listEspecialesA;
  }

  Future<List<OpcionesSabores>> obtenerOpcionesEspecialesA(String idProducto, String titulo) async {
    final listOpcionesEspecialesA = List<OpcionesSabores>();

    final listOpcionesEspecialesADatabase =  await opcionesespecialesADatabase.obtenerOpcionesEspecialesA(idProducto,titulo);

    if(listOpcionesEspecialesADatabase.length>0){

       for (var i = 0; i < listOpcionesEspecialesADatabase.length; i++) {

         OpcionesSabores opcionesTextosFijos =OpcionesSabores();
         opcionesTextosFijos.idProducto = idProducto;
         opcionesTextosFijos.tituloTextos = titulo;
         opcionesTextosFijos.nombreTexto = listOpcionesEspecialesADatabase[i].nombreTexto;

         listOpcionesEspecialesA.add(opcionesTextosFijos);

       }

    }

    return listOpcionesEspecialesA;
  }

  Future<List<String>> nombrecitosEspecialesA(
      String idProducto, String titulo) async {
    final listNombresEspecialesA = List<String>();

    final listOpcionesEspecialesADatabase =  await opcionesespecialesADatabase.obtenerOpcionesEspecialesA(idProducto,titulo);

    if(listOpcionesEspecialesADatabase.length>0){

       for (var i = 0; i < listOpcionesEspecialesADatabase.length; i++) {

        var name = listOpcionesEspecialesADatabase[i].nombreTexto;
         

         listNombresEspecialesA.add(name);

       }

    }

    return listNombresEspecialesA;
  }




// ESPECIALES B

  Future<List<Sabores>> obtenerEspecialesB(String idProducto) async {
    final listEspecialesB= List<Sabores>();

    final listEspecialesBDatabase =
        await especialesBDatabase.obtenerEspecialesB(idProducto);

    if (listEspecialesBDatabase.length > 0) {
      for (var i = 0; i < listEspecialesBDatabase.length; i++) {
        Sabores sabores = Sabores();
        sabores.idProducto = listEspecialesBDatabase[i].idProducto;
        sabores.tituloTextos = listEspecialesBDatabase[i].tituloTextos;
        sabores.maximo = listEspecialesBDatabase[i].maximo;
        sabores.opciones = await obtenerOpcionesEspecialesB(idProducto, listEspecialesBDatabase[i].tituloTextos);
        sabores.nombrecitos = await nombrecitosEspecialesB(idProducto, listEspecialesBDatabase[i].tituloTextos);

            listEspecialesB.add(sabores);
      }
    }

    return listEspecialesB;
  }

  Future<List<OpcionesSabores>> obtenerOpcionesEspecialesB(String idProducto, String titulo) async {
    final listOpcionesEspecialesB = List<OpcionesSabores>();

    final listOpcionesEspecialesBDatabase =  await opcionesespecialesBDatabase.obtenerOpcionesEspecialesB(idProducto,titulo);

    if(listOpcionesEspecialesBDatabase.length>0){

       for (var i = 0; i < listOpcionesEspecialesBDatabase.length; i++) {

         OpcionesSabores opcionesTextosFijos =OpcionesSabores();
         opcionesTextosFijos.idProducto = idProducto;
         opcionesTextosFijos.tituloTextos = titulo;
         opcionesTextosFijos.nombreTexto = listOpcionesEspecialesBDatabase[i].nombreTexto;

         listOpcionesEspecialesB.add(opcionesTextosFijos);

       }

    }

    return listOpcionesEspecialesB;
  }

  Future<List<String>> nombrecitosEspecialesB(
      String idProducto, String titulo) async {
    final listNombreEspecialesB= List<String>();

    final listOpcionesEspecialesBDatabase =  await opcionesespecialesBDatabase.obtenerOpcionesEspecialesB(idProducto,titulo);

    if(listOpcionesEspecialesBDatabase.length>0){

       for (var i = 0; i < listOpcionesEspecialesBDatabase.length; i++) {

        var name = listOpcionesEspecialesBDatabase[i].nombreTexto;
         

         listNombreEspecialesB.add(name);

       }

    }

    return listNombreEspecialesB;
  }



// ESPECIALES C

  Future<List<Sabores>> obtenerEspecialesC(String idProducto) async {
    final listEspecialesC = List<Sabores>();

    final listEspecialesCDatabase =
        await especialesCDatabase.obtenerEspecialesC(idProducto);

    if (listEspecialesCDatabase.length > 0) {
      for (var i = 0; i < listEspecialesCDatabase.length; i++) {
        Sabores sabores = Sabores();
        sabores.idProducto = listEspecialesCDatabase[i].idProducto;
        sabores.tituloTextos = listEspecialesCDatabase[i].tituloTextos;
        sabores.maximo = listEspecialesCDatabase[i].maximo;
        sabores.opciones = await obtenerOpcionesEspecialesC(idProducto, listEspecialesCDatabase[i].tituloTextos);
        sabores.nombrecitos = await nombrecitosEspecialesC(idProducto, listEspecialesCDatabase[i].tituloTextos);

            listEspecialesC.add(sabores);
      }
    }

    return listEspecialesC;
  }

  Future<List<OpcionesSabores>> obtenerOpcionesEspecialesC(String idProducto, String titulo) async {
    final listOpcionesEspecialesC = List<OpcionesSabores>();

    final listOpcionesEspecialesCDatabase =  await opcionesespecialesCDatabase.obtenerOpcionesEspecialesC(idProducto,titulo);

    if(listOpcionesEspecialesCDatabase.length>0){

       for (var i = 0; i < listOpcionesEspecialesCDatabase.length; i++) {

         OpcionesSabores opcionesTextosFijos =OpcionesSabores();
         opcionesTextosFijos.idProducto = idProducto;
         opcionesTextosFijos.tituloTextos = titulo;
         opcionesTextosFijos.nombreTexto = listOpcionesEspecialesCDatabase[i].nombreTexto;

         listOpcionesEspecialesC.add(opcionesTextosFijos);

       }

    }

    return listOpcionesEspecialesC;
  }

  Future<List<String>> nombrecitosEspecialesC(
      String idProducto, String titulo) async {
    final listNombresEspecialesC = List<String>();

    final listOpcionesEspecialesCDatabase =  await opcionesespecialesCDatabase.obtenerOpcionesEspecialesC(idProducto,titulo);

    if(listOpcionesEspecialesCDatabase.length>0){

       for (var i = 0; i < listOpcionesEspecialesCDatabase.length; i++) {

        var name = listOpcionesEspecialesCDatabase[i].nombreTexto;
         listNombresEspecialesC.add(name);
       }
    }

    return listNombresEspecialesC;
  }



// ESPECIALES D

  Future<List<Sabores>> obtenerEspecialesD(String idProducto) async {
    final listSabores = List<Sabores>();

    final listSaboresDatabase =
        await especialesDDatabase.obtenerEspecialesD(idProducto);

    if (listSaboresDatabase.length > 0) {
      for (var i = 0; i < listSaboresDatabase.length; i++) {
        Sabores sabores = Sabores();
        sabores.idProducto = listSaboresDatabase[i].idProducto;
        sabores.tituloTextos = listSaboresDatabase[i].tituloTextos;
        sabores.maximo = listSaboresDatabase[i].maximo;
        sabores.opciones = await obtenerOpcionesEspecialesD(idProducto, listSaboresDatabase[i].tituloTextos);
        sabores.nombrecitos = await nombrecitosEspecialesD(idProducto, listSaboresDatabase[i].tituloTextos);

            listSabores.add(sabores);
      }
    }

    return listSabores;
  }

  Future<List<OpcionesSabores>> obtenerOpcionesEspecialesD(String idProducto, String titulo) async {
    final listOpcionesSabores = List<OpcionesSabores>();

    final listOpcionesSaboresDatabase =  await opcionesespecialesDDatabase.obtenerOpcionesEspecialesD(idProducto,titulo);

    if(listOpcionesSaboresDatabase.length>0){

       for (var i = 0; i < listOpcionesSaboresDatabase.length; i++) {

         OpcionesSabores opcionesTextosFijos =OpcionesSabores();
         opcionesTextosFijos.idProducto = idProducto;
         opcionesTextosFijos.tituloTextos = titulo;
         opcionesTextosFijos.nombreTexto = listOpcionesSaboresDatabase[i].nombreTexto;

         listOpcionesSabores.add(opcionesTextosFijos);

       }

    }

    return listOpcionesSabores;
  }

  Future<List<String>> nombrecitosEspecialesD(
      String idProducto, String titulo) async {
    final listOpcionesSabores = List<String>();

    final listOpcionesSaboresDatabase =  await opcionesespecialesDDatabase.obtenerOpcionesEspecialesD(idProducto,titulo);

    if(listOpcionesSaboresDatabase.length>0){

       for (var i = 0; i < listOpcionesSaboresDatabase.length; i++) {

        var name = listOpcionesSaboresDatabase[i].nombreTexto;
         

         listOpcionesSabores.add(name);

       }

    }

    return listOpcionesSabores;
  }



}