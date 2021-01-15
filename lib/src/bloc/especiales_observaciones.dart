



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
    final listSabores = List<Sabores>();

    final listSaboresDatabase =
        await especialesADatabase.obtenerEspecialesA(idProducto);

    if (listSaboresDatabase.length > 0) {
      for (var i = 0; i < listSaboresDatabase.length; i++) {
        Sabores sabores = Sabores();
        sabores.idProducto = listSaboresDatabase[i].idProducto;
        sabores.tituloTextos = listSaboresDatabase[i].tituloTextos;
        sabores.maximo = listSaboresDatabase[i].maximo;
        sabores.opciones = await obtenerOpcionesEspecialesA(idProducto, listSaboresDatabase[i].tituloTextos);
        sabores.nombrecitos = await nombrecitosEspecialesA(idProducto, listSaboresDatabase[i].tituloTextos);

            listSabores.add(sabores);
      }
    }

    return listSabores;
  }

  Future<List<OpcionesSabores>> obtenerOpcionesEspecialesA(String idProducto, String titulo) async {
    final listOpcionesSabores = List<OpcionesSabores>();

    final listOpcionesSaboresDatabase =  await opcionesespecialesADatabase.obtenerOpcionesEspecialesA(idProducto,titulo);

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

  Future<List<String>> nombrecitosEspecialesA(
      String idProducto, String titulo) async {
    final listOpcionesSabores = List<String>();

    final listOpcionesSaboresDatabase =  await opcionesespecialesADatabase.obtenerOpcionesEspecialesA(idProducto,titulo);

    if(listOpcionesSaboresDatabase.length>0){

       for (var i = 0; i < listOpcionesSaboresDatabase.length; i++) {

        var name = listOpcionesSaboresDatabase[i].nombreTexto;
         

         listOpcionesSabores.add(name);

       }

    }

    return listOpcionesSabores;
  }




// ESPECIALES B

  Future<List<Sabores>> obtenerEspecialesB(String idProducto) async {
    final listSabores = List<Sabores>();

    final listSaboresDatabase =
        await especialesBDatabase.obtenerEspecialesB(idProducto);

    if (listSaboresDatabase.length > 0) {
      for (var i = 0; i < listSaboresDatabase.length; i++) {
        Sabores sabores = Sabores();
        sabores.idProducto = listSaboresDatabase[i].idProducto;
        sabores.tituloTextos = listSaboresDatabase[i].tituloTextos;
        sabores.maximo = listSaboresDatabase[i].maximo;
        sabores.opciones = await obtenerOpcionesEspecialesB(idProducto, listSaboresDatabase[i].tituloTextos);
        sabores.nombrecitos = await nombrecitosEspecialesB(idProducto, listSaboresDatabase[i].tituloTextos);

            listSabores.add(sabores);
      }
    }

    return listSabores;
  }

  Future<List<OpcionesSabores>> obtenerOpcionesEspecialesB(String idProducto, String titulo) async {
    final listOpcionesSabores = List<OpcionesSabores>();

    final listOpcionesSaboresDatabase =  await opcionesespecialesBDatabase.obtenerOpcionesEspecialesB(idProducto,titulo);

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

  Future<List<String>> nombrecitosEspecialesB(
      String idProducto, String titulo) async {
    final listOpcionesSabores = List<String>();

    final listOpcionesSaboresDatabase =  await opcionesespecialesBDatabase.obtenerOpcionesEspecialesB(idProducto,titulo);

    if(listOpcionesSaboresDatabase.length>0){

       for (var i = 0; i < listOpcionesSaboresDatabase.length; i++) {

        var name = listOpcionesSaboresDatabase[i].nombreTexto;
         

         listOpcionesSabores.add(name);

       }

    }

    return listOpcionesSabores;
  }



// ESPECIALES C

  Future<List<Sabores>> obtenerEspecialesC(String idProducto) async {
    final listSabores = List<Sabores>();

    final listSaboresDatabase =
        await especialesCDatabase.obtenerEspecialesC(idProducto);

    if (listSaboresDatabase.length > 0) {
      for (var i = 0; i < listSaboresDatabase.length; i++) {
        Sabores sabores = Sabores();
        sabores.idProducto = listSaboresDatabase[i].idProducto;
        sabores.tituloTextos = listSaboresDatabase[i].tituloTextos;
        sabores.maximo = listSaboresDatabase[i].maximo;
        sabores.opciones = await obtenerOpcionesEspecialesC(idProducto, listSaboresDatabase[i].tituloTextos);
        sabores.nombrecitos = await nombrecitosEspecialesC(idProducto, listSaboresDatabase[i].tituloTextos);

            listSabores.add(sabores);
      }
    }

    return listSabores;
  }

  Future<List<OpcionesSabores>> obtenerOpcionesEspecialesC(String idProducto, String titulo) async {
    final listOpcionesSabores = List<OpcionesSabores>();

    final listOpcionesSaboresDatabase =  await opcionesespecialesCDatabase.obtenerOpcionesEspecialesC(idProducto,titulo);

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

  Future<List<String>> nombrecitosEspecialesC(
      String idProducto, String titulo) async {
    final listOpcionesSabores = List<String>();

    final listOpcionesSaboresDatabase =  await opcionesespecialesCDatabase.obtenerOpcionesEspecialesC(idProducto,titulo);

    if(listOpcionesSaboresDatabase.length>0){

       for (var i = 0; i < listOpcionesSaboresDatabase.length; i++) {

        var name = listOpcionesSaboresDatabase[i].nombreTexto;
         listOpcionesSabores.add(name);
       }
    }

    return listOpcionesSabores;
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