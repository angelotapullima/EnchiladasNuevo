import 'package:enchiladasapp/src/api/categorias_api.dart';
import 'package:enchiladasapp/src/bloc/especiales_observaciones.dart';
import 'package:enchiladasapp/src/bloc/provider.dart';
import 'package:enchiladasapp/src/database/observaciones_database.dart';
import 'package:enchiladasapp/src/models/observaciones_model.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/subjects.dart';

class ObservacionesProductoBloc {
  final categoriasApi = CategoriasApi();
  final observacionesFijasDatabase = ObservacionesFijasDatabase();
  final productosFijosDatabase = ProductosFijosDatabase();
  final saboresDatabase = SaboresDatabase();
  final opcionesSaboresDatabase = OpcionesSaboresDatabase();
  final acompanhamientosDatabase = AcompanhamientosDatabase();
  final opcionesAcompanhamientosDatabase = OpcionesAcompanhamientosDatabase();
  final observacionesVariablesDatabase = ObservacionesVariablesDatabase();

  final _observacionesController = new BehaviorSubject<List<Observaciones>>();

  Stream<List<Observaciones>> get observacionesStream =>
      _observacionesController.stream;

  dispose() {
    _observacionesController?.close();
  }

  void obtenerObservaciones(BuildContext context, String idProducto) async {
    _observacionesController.sink.add(null);
    await categoriasApi.obtenerAdicionalesPorProducto(idProducto);

    _observacionesController.sink.add(await obtenerObservaciones2(idProducto));
    final adicionalesBloc = ProviderBloc.adicionales(context);
    adicionalesBloc.obtenerAdicionales(idProducto);
  }

  Future<List<Observaciones>> obtenerObservaciones2(String idProducto) async {
    final List<Observaciones> observacionesGeneral = [];
    EspecialesObservaciones c = EspecialesObservaciones();

    Observaciones observaciones = Observaciones();

    final List<ObservacionesFijas> observacionesFijas = [];

    final obFijas =
        await observacionesFijasDatabase.obtenerObservacionesFijas(idProducto);

    if (obFijas.length > 0) {
      for (var i = 0; i < obFijas.length; i++) {
        ObservacionesFijas observacionesFijasModel = ObservacionesFijas();
        observacionesFijasModel.idProducto = obFijas[i].idProducto;
        observacionesFijasModel.mostrar = obFijas[i].mostrar;
        observacionesFijasModel.productosFijos =
            await obtenerProductosFijos(idProducto);
        observacionesFijasModel.sabores = await obtenerSabores(idProducto);
        observacionesFijasModel.acompanhamientos =
            await obtenerAcompanhamientos(idProducto);
        observacionesFijasModel.especialesA =
            await c.obtenerEspecialesA(idProducto);
        observacionesFijasModel.especialesB =
            await c.obtenerEspecialesB(idProducto);
        observacionesFijasModel.especialesC =
            await c.obtenerEspecialesC(idProducto);
        observacionesFijasModel.especialesD =
            await c.obtenerEspecialesD(idProducto);

        observacionesFijas.add(observacionesFijasModel);
      }
    }

    observaciones.fijas = observacionesFijas;
    observaciones.variables = await obtenerVariables(idProducto);
    observacionesGeneral.add(observaciones);

    return observacionesGeneral;
  }

  Future<List<ObservacionesVariables>> obtenerVariables(
      String idProducto) async {
    final List<ObservacionesVariables> listObservacionesVariables = [];

    final obsVariables = await observacionesVariablesDatabase
        .obtenerObservacionesVariables(idProducto);

    if (obsVariables.length > 0) {
      for (var i = 0; i < obsVariables.length; i++) {
        ObservacionesVariables observacionesVariables =
            ObservacionesVariables();
        observacionesVariables.idProducto = obsVariables[i].idProducto;
        observacionesVariables.nombreVariable = obsVariables[i].nombreVariable;

        listObservacionesVariables.add(observacionesVariables);
      }
    }

    return listObservacionesVariables;
  }

  Future<List<ProductosFijos>> obtenerProductosFijos(String idProducto) async {
    final List<ProductosFijos> listProductosFijos = [];
    final listProductoFijosDatabase =
        await productosFijosDatabase.obtenerProductosFijos(idProducto);

    if (listProductoFijosDatabase.length > 0) {
      for (var x = 0; x < listProductoFijosDatabase.length; x++) {
        ProductosFijos productosFijos = ProductosFijos();
        productosFijos.idProducto = listProductoFijosDatabase[x].idProducto;
        productosFijos.idRelacionado =
            listProductoFijosDatabase[x].idRelacionado;
        productosFijos.nombreProducto =
            listProductoFijosDatabase[x].nombreProducto;
        listProductosFijos.add(productosFijos);
      }
    }

    return listProductosFijos;
  }

  Future<List<Sabores>> obtenerSabores(String idProducto) async {
    final List<Sabores> listSabores = [];

    final listSaboresDatabase =
        await saboresDatabase.obtenerSabores(idProducto);

    if (listSaboresDatabase.length > 0) {
      for (var i = 0; i < listSaboresDatabase.length; i++) {
        Sabores sabores = Sabores();
        sabores.idProducto = listSaboresDatabase[i].idProducto;
        sabores.tituloTextos = listSaboresDatabase[i].tituloTextos;
        sabores.maximo = listSaboresDatabase[i].maximo;
        sabores.opciones = await obtenerOpcionesSabores(
            idProducto, listSaboresDatabase[i].tituloTextos);
        sabores.nombrecitos = await nombrecitosSabores(
            idProducto, listSaboresDatabase[i].tituloTextos);

        listSabores.add(sabores);
      }
    }

    return listSabores;
  }

  Future<List<OpcionesSabores>> obtenerOpcionesSabores(
      String idProducto, String titulo) async {
    final List<OpcionesSabores> listOpcionesSabores = [];

    final listOpcionesSaboresDatabase = await opcionesSaboresDatabase
        .obtenerOpcionesSabores(idProducto, titulo);

    if (listOpcionesSaboresDatabase.length > 0) {
      for (var i = 0; i < listOpcionesSaboresDatabase.length; i++) {
        OpcionesSabores opcionesTextosFijos = OpcionesSabores();
        opcionesTextosFijos.idProducto = idProducto;
        opcionesTextosFijos.tituloTextos = titulo;
        opcionesTextosFijos.nombreTexto =
            listOpcionesSaboresDatabase[i].nombreTexto;

        listOpcionesSabores.add(opcionesTextosFijos);
      }
    }

    return listOpcionesSabores;
  }

  Future<List<String>> nombrecitosSabores(
      String idProducto, String titulo) async {
    final List<String> listOpcionesSabores = [];

    final listOpcionesSaboresDatabase = await opcionesSaboresDatabase
        .obtenerOpcionesSabores(idProducto, titulo);

    if (listOpcionesSaboresDatabase.length > 0) {
      for (var i = 0; i < listOpcionesSaboresDatabase.length; i++) {
        var name = listOpcionesSaboresDatabase[i].nombreTexto;

        listOpcionesSabores.add(name);
      }
    }

    return listOpcionesSabores;
  }

  Future<List<Acompanhamientos>> obtenerAcompanhamientos(
      String idProducto) async {
    final List<Acompanhamientos> listAcompanhamientos = [];

    final listlistAcompanhamientosDatabase =
        await acompanhamientosDatabase.obtenerAcompanhamientos(idProducto);

    if (listlistAcompanhamientosDatabase.length > 0) {
      for (var i = 0; i < listlistAcompanhamientosDatabase.length; i++) {
        Acompanhamientos acompanhamientosModel = Acompanhamientos();
        acompanhamientosModel.idProducto =
            listlistAcompanhamientosDatabase[i].idProducto;
        acompanhamientosModel.tituloTextos =
            listlistAcompanhamientosDatabase[i].tituloTextos;
        acompanhamientosModel.acompanhamientos =
            await obtenerAcompanhamientosFor(
                idProducto, listlistAcompanhamientosDatabase[i].tituloTextos);
        acompanhamientosModel.nombrecitos = await nombrecitosAcompanhamientos(
            idProducto, listlistAcompanhamientosDatabase[i].tituloTextos);

        listAcompanhamientos.add(acompanhamientosModel);
      }
    }

    return listAcompanhamientos;
  }

  Future<List<OpcionesAcompanhamientos>> obtenerAcompanhamientosFor(
      String idProducto, String titulo) async {
    final List<OpcionesAcompanhamientos> listOpcionesAcompanhamientoss = [];

    final listOpcionesAcompanhamientosDatabase =
        await opcionesAcompanhamientosDatabase.obtenerOpcionesAcompanhamientos(
            idProducto, titulo);

    if (listOpcionesAcompanhamientosDatabase.length > 0) {
      for (var i = 0; i < listOpcionesAcompanhamientosDatabase.length; i++) {
        OpcionesAcompanhamientos opcionesAcompanhamientosModel =
            OpcionesAcompanhamientos();
        opcionesAcompanhamientosModel.idProducto = idProducto;
        opcionesAcompanhamientosModel.tituloTextos = titulo;
        opcionesAcompanhamientosModel.nombreTexto =
            listOpcionesAcompanhamientosDatabase[i].nombreTexto;

        listOpcionesAcompanhamientoss.add(opcionesAcompanhamientosModel);
      }
    }

    return listOpcionesAcompanhamientoss;
  }

  Future<List<String>> nombrecitosAcompanhamientos(
      String idProducto, String titulo) async {
    final List<String> listOpcionesAcompanhamientos = [];

    final listOpcionesAcompanhamientosDatabase =
        await opcionesAcompanhamientosDatabase.obtenerOpcionesAcompanhamientos(
            idProducto, titulo);

    if (listOpcionesAcompanhamientosDatabase.length > 0) {
      for (var i = 0; i < listOpcionesAcompanhamientosDatabase.length; i++) {
        var name = listOpcionesAcompanhamientosDatabase[i].nombreTexto;

        listOpcionesAcompanhamientos.add(name);
      }
    }

    return listOpcionesAcompanhamientos;
  }
}
