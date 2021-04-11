import 'package:enchiladasapp/src/database/adicionales_database.dart';
import 'package:enchiladasapp/src/database/categorias_database.dart';
import 'package:enchiladasapp/src/database/especiales_la_putamadre.dart';
import 'package:enchiladasapp/src/database/producto_database.dart';
import 'package:enchiladasapp/src/database/temporizador_database.dart';
import 'package:enchiladasapp/src/database/observaciones_database.dart';
import 'package:enchiladasapp/src/models/adicionales_model.dart';
import 'package:enchiladasapp/src/models/categoria_model.dart';
import 'package:enchiladasapp/src/models/observaciones_model.dart';
import 'package:enchiladasapp/src/models/productos_model.dart';
import 'package:enchiladasapp/src/models/temporizador_model.dart';
import 'package:enchiladasapp/src/utils/constant.dart';
import 'package:enchiladasapp/src/utils/preferencias_usuario.dart';
import 'package:enchiladasapp/src/utils/utilidades.dart' as utils;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CategoriasApi {
  final categoriasDatabase = CategoriasDatabase();
  final productoDatabase = ProductoDatabase();
  final temporizadorDatabase = TemporizadorDatabase();
  final adicionalesDatabase = AdicionalesDatabase();
  final observacionesFijasDatabase = ObservacionesFijasDatabase();
  final productosFijosDatabase = ProductosFijosDatabase();
  final saboresDatabase = SaboresDatabase();
  final opcionesSaboresDatabase = OpcionesSaboresDatabase();

  final acompanhamientosDatabase = AcompanhamientosDatabase();
  final opcionesAcompanhamientosDatabase = OpcionesAcompanhamientosDatabase();

  final especialesADatabase = EspecialesADatabase();
  final opcionesespecialesADatabase = OpcionesEspecialesADatabase();

  final especialesBDatabase = EspecialesBDatabase();
  final opcionesespecialesBDatabase = OpcionesEspecialesBDatabase();

  final especialesCDatabase = EspecialesCDatabase();
  final opcionesespecialesCDatabase = OpcionesEspecialesCDatabase();

  final especialesDDatabase = EspecialesDDatabase();
  final opcionesespecialesDDatabase = OpcionesEspecialesDDatabase();

  final observacionesVariablesDatabase = ObservacionesVariablesDatabase();

  Future<bool> obtenerAmbos(BuildContext context) async {
    try {
      final url = '$urlBase/api/categoria/listar_categorias_solo_productos';
      
      final preferences = Preferences();
      final resp = await http.post(url, body: {'numero': '1'});
      final Map<String, dynamic> decodedData = json.decode(resp.body);
      if (decodedData == null) return false;

      // print(decodedData['result']['data'].length);

      var cantidadTotal = decodedData['result']['data'].length;
      print('cantidadTotal $cantidadTotal');
      if (decodedData['result']['data'].length > 0) {
        for (int i = 0; i < decodedData['result']['data'].length; i++) {
          var porcentaje = ((i + 1) * 100) / cantidadTotal;

          print('porcentaje $porcentaje');

          if (preferences.estadoCargaInicial == null ||
              preferences.estadoCargaInicial == '0') {
            utils.porcentaje(context, porcentaje);
          }

          CategoriaData categoriaData = CategoriaData();

          categoriaData.idCategoria =
              decodedData['result']['data'][i]['id_categoria'];
          categoriaData.categoriaNombre =
              decodedData['result']['data'][i]['categoria_nombre'];
          categoriaData.categoriaIcono =
              decodedData['result']['data'][i]['categoria_icono'];
          categoriaData.categoriaTipo =
              decodedData['result']['data'][i]['categoria_tipo'];
          categoriaData.categoriaFoto =
              decodedData['result']['data'][i]['categoria_foto'];
          categoriaData.categoriaBanner =
              decodedData['result']['data'][i]['categoria_banner'];
          categoriaData.categoriaPromocion =
              decodedData['result']['data'][i]['categoria_promocion'];
          categoriaData.categoriaSonido =
              decodedData['result']['data'][i]['categoria_sonido'];
          categoriaData.categoriaEstado =
              decodedData['result']['data'][i]['categoria_estado'];
          categoriaData.categoriaMostrarApp =
              decodedData['result']['data'][i]['categoria_mostrar_app'];
          categoriaData.categoriaOrden =
              decodedData['result']['data'][i]['categoria_orden'];

          categoriasDatabase.insertarCategoriasDb(categoriaData);

          //TEMPORIZADOR
          var temporizador = List<dynamic>();
          temporizador = decodedData['result']['data'][i]['temporizador'];

          TemporizadorModel temporizadorModel = TemporizadorModel();
          temporizadorModel.idTemporizador =
              decodedData['result']['data'][i]['id_categoria'];
          temporizadorModel.temporizadorTipo =
              temporizador[0]['temporizador_tipo'];
          temporizadorModel.temporizadorFechainicio =
              temporizador[0]['temporizador_fechainicio'];
          temporizadorModel.temporizadorFechafin =
              temporizador[0]['temporizador_fechafin'];
          temporizadorModel.temporizadorHorainicio =
              temporizador[0]['temporizador_horainicio'];
          temporizadorModel.temporizadorHorafin =
              temporizador[0]['temporizador_horafin'];
          temporizadorModel.temporizadorMensaje =
              temporizador[0]['temporizador_mensaje'];
          temporizadorModel.temporizadorLunes =
              temporizador[0]['temporizador_dias']['Lunes'];
          temporizadorModel.temporizadorMartes =
              temporizador[0]['temporizador_dias']['Martes'];
          temporizadorModel.temporizadorMiercoles =
              temporizador[0]['temporizador_dias']['Miercoles'];
          temporizadorModel.temporizadorJueves =
              temporizador[0]['temporizador_dias']['Jueves'];
          temporizadorModel.temporizadorViernes =
              temporizador[0]['temporizador_dias']['Viernes'];
          temporizadorModel.temporizadorSabado =
              temporizador[0]['temporizador_dias']['Sabado'];
          temporizadorModel.temporizadorDomingo =
              temporizador[0]['temporizador_dias']['Domingo'];

          await temporizadorDatabase.insertarTemporizador(temporizadorModel);

          //PRODUCTOS
          var productos = List<dynamic>();

          productos = decodedData['result']['data'][i]['productos'];

          /* var cantidadTotalProductos =
              decodedData['result']['data'][i]['productos'].length;
          print('cantidadTotalProductos $cantidadTotalProductos');  */
          //print('productos tamaño ${productos.length}');

          for (int x = 0; x < productos.length; x++) {
            final idproducto = productos[x]['id_producto'];

            

            final datoproducto =await productoDatabase.consultarPorId(idproducto);
            //print('id productos ${datoproducto.length}');
            ProductosData productosData = ProductosData();
            productosData.idProducto = productos[x]['id_producto'];
            productosData.idCategoria = productos[x]['id_categoria'];
            productosData.productoNombre = productos[x]['producto_nombre'];
            productosData.productoFoto = productos[x]['producto_foto'];
            productosData.productoPrecio = productos[x]['producto_precio'];
            productosData.productoUnidad = productos[x]['producto_unidad'];
            productosData.productoEstado = productos[x]['producto_estado'];
            productosData.productoDestacado =productos[x]['producto_destacado'];
            productosData.productoNuevo = productos[x]['producto_nuevo'];
            productosData.productoDescripcion =productos[x]['producto_detalle'];
            productosData.productoComentario =productos[x]['producto_comentario'];
            productosData.sonido =decodedData['result']['data'][i]['categoria_sonido'];
            productosData.productoCarta = productos[x]['producto_carta'];
            productosData.productoDelivery = productos[x]['producto_delivery'];

         

            

           

            if (productosData.productoDestacado == '0') {
              productosData.productoEstadoDestacado = '0';
            } else {
              productosData.productoEstadoDestacado = '1';
            }
            productosData.productoTupper = productos[x]['producto_tupper'];

            if (datoproducto.length > 0) {
              productosData.productoFavorito = datoproducto[0].productoFavorito;
              productoDatabase.updateProductosDb(productosData);
            } else {
              productosData.productoFavorito = 0;

              productoDatabase.insertarProductosDb(productosData);
            }

/*


            if ( preferences.estadoCargaInicial == '1') {

                  print('entro a esta  mierda');
              await observacionesFijasDatabase
                  .deleteObservacionesFijas(productos[x]['id_producto']);
              await productosFijosDatabase
                  .deleteProductosFijos(productos[x]['id_producto']);
              await saboresDatabase.deleteSabores(productos[x]['id_producto']);
              await opcionesSaboresDatabase
                  .deleteOpcionesSabores(productos[x]['id_producto']);

              await acompanhamientosDatabase
                  .deleteAcompanhamientos(productos[x]['id_producto']);
              await opcionesAcompanhamientosDatabase
                  .deleteOpcionesAcompanhamientos(productos[x]['id_producto']);

              await especialesADatabase
                  .deleteEspecialesA(productos[x]['id_producto']);
              await opcionesespecialesADatabase
                  .deleteOpcionesEspecialesA(productos[x]['id_producto']);

              await especialesBDatabase
                  .deleteEspecialesB(productos[x]['id_producto']);
              await opcionesespecialesBDatabase
                  .deleteOpcionesEspecialesB(productos[x]['id_producto']);

              await especialesCDatabase
                  .deleteEspecialesC(productos[x]['id_producto']);
              await opcionesespecialesCDatabase
                  .deleteOpcionesEspecialesC(productos[x]['id_producto']);

              await especialesDDatabase
                  .deleteEspecialesD(productos[x]['id_producto']);
              await opcionesespecialesDDatabase
                  .deleteOpcionesEspecialesD(productos[x]['id_producto']);

              await observacionesVariablesDatabase
                  .deleteObservacionesVariables(productos[x]['id_producto']);
            }

            ObservacionesFijas observacionesFijas = ObservacionesFijas();
            observacionesFijas.idProducto = productos[x]['id_producto'];
            observacionesFijas.mostrar =
                productos[x]['producto_observaciones_fijas']['mostrar_fijas'];

            await observacionesFijasDatabase
                .insertarObservacionesFijas(observacionesFijas);

            var productillos =
                productos[x]['producto_observaciones_fijas']['productos'];

            if (productillos.length > 0) {
              for (var z = 0;
                  z <
                      productos[x]['producto_observaciones_fijas']['productos']
                          .length;
                  z++) {
                final productoIdbuscado = await productoDatabase
                    .consultarPorId(productillos[z].toString());

                if (productoIdbuscado.length > 0) {
                  ProductosFijos productosFijos = ProductosFijos();
                  productosFijos.idProducto = productos[x]['id_producto'];
                  productosFijos.idRelacionado = productillos[z].toString();
                  productosFijos.nombreProducto =
                      productoIdbuscado[0].productoNombre;

                  await productosFijosDatabase
                      .insertarProductosFijos(productosFijos);
                }
              }
            }

            var saboresList =
                productos[x]['producto_observaciones_fijas']['sabores'];

            if (saboresList.length > 0) {
              for (var f = 0; f < saboresList.length; f++) {
                Sabores sabores = Sabores();
                sabores.idProducto = productos[x]['id_producto'];
                sabores.tituloTextos = saboresList[f]['titulo'];
                sabores.maximo = saboresList[f]['maximo'];

                await saboresDatabase.insertarSabores(sabores);

                var listOpcionesSabores = saboresList[f]['opciones'];
                if (listOpcionesSabores.length > 0) {
                  for (var t = 0; t < listOpcionesSabores.length; t++) {
                    OpcionesSabores opcionesSabores = OpcionesSabores();
                    opcionesSabores.idProducto = productos[x]['id_producto'];
                    opcionesSabores.tituloTextos =
                        saboresList[f]['titulo'].toString();
                    opcionesSabores.nombreTexto =
                        listOpcionesSabores[t].toString();

                    await opcionesSaboresDatabase
                        .insertarOpcionesSabores(opcionesSabores);
                  }
                }
              }
            }

            var acompanhamientosList = productos[x]
                ['producto_observaciones_fijas']['acompanhamientos'];

            if (acompanhamientosList.length > 0) {
              for (var y = 0; y < acompanhamientosList.length; y++) {
                Acompanhamientos acompanhamientosModel = Acompanhamientos();
                acompanhamientosModel.idProducto = productos[x]['id_producto'];
                acompanhamientosModel.tituloTextos =
                    acompanhamientosList[y]['titulo'].toString();

                await acompanhamientosDatabase
                    .insertarAcompanhamientos(acompanhamientosModel);

                var listOpcionesAcompanhamientos =
                    acompanhamientosList[y]['opciones'];
                if (listOpcionesAcompanhamientos.length > 0) {
                  for (var t = 0;
                      t < listOpcionesAcompanhamientos.length;
                      t++) {
                    OpcionesAcompanhamientos opcionesAcompanhamientosModel =
                        OpcionesAcompanhamientos();
                    opcionesAcompanhamientosModel.idProducto =
                        productos[x]['id_producto'];
                    opcionesAcompanhamientosModel.tituloTextos =
                        acompanhamientosList[y]['titulo'];
                    opcionesAcompanhamientosModel.nombreTexto =
                        listOpcionesAcompanhamientos[t].toString();

                    await opcionesAcompanhamientosDatabase
                        .insertarOpcionesAcompanhamientos(
                            opcionesAcompanhamientosModel);
                  }
                }
              }
            }

            var variblesObservaciones =
                productos[x]['producto_observaciones_variables'];
            if (variblesObservaciones.length > 0) {
              for (var a = 0; a < variblesObservaciones.length; a++) {
                ObservacionesVariables observacionesVariables =
                    ObservacionesVariables();
                observacionesVariables.idProducto = productos[x]['id_producto'];
                observacionesVariables.nombreVariable =
                    variblesObservaciones[a].toString();
                await observacionesVariablesDatabase
                    .insertarObservacionesVariables(observacionesVariables);
              }
            }

            var especialesAList =
                productos[x]['producto_observaciones_fijas']['especial_1'];
            if (especialesAList.length > 0) {
              for (var f = 0; f < especialesAList.length; f++) {
                Sabores sabores = Sabores();
                sabores.idProducto = productos[x]['id_producto'];
                sabores.tituloTextos = especialesAList[f]['titulo'];
                sabores.maximo = especialesAList[f]['maximo'];

                await especialesADatabase.insertarEspecialesA(sabores);

                var listOpcionesSabores = especialesAList[f]['opciones'];
                if (listOpcionesSabores.length > 0) {
                  for (var t = 0; t < listOpcionesSabores.length; t++) {
                    OpcionesSabores opcionesSabores = OpcionesSabores();
                    opcionesSabores.idProducto = productos[x]['id_producto'];
                    opcionesSabores.tituloTextos =
                        especialesAList[f]['titulo'].toString();
                    opcionesSabores.nombreTexto =
                        listOpcionesSabores[t].toString();

                    await opcionesespecialesADatabase
                        .insertarOpcionesEspecialesA(opcionesSabores);
                  }
                }
              }
            }

            var especialesBList =
                productos[x]['producto_observaciones_fijas']['especial_2'];

            if (especialesBList.length > 0) {
              for (var f = 0; f < especialesBList.length; f++) {
                Sabores sabores = Sabores();
                sabores.idProducto = productos[x]['id_producto'];
                sabores.tituloTextos = especialesBList[f]['titulo'];
                sabores.maximo = especialesBList[f]['maximo'];

                await especialesBDatabase.insertarEspecialesB(sabores);

                var listOpcionesSabores = especialesBList[f]['opciones'];
                if (listOpcionesSabores.length > 0) {
                  for (var t = 0; t < listOpcionesSabores.length; t++) {
                    OpcionesSabores opcionesSabores = OpcionesSabores();
                    opcionesSabores.idProducto = productos[x]['id_producto'];
                    opcionesSabores.tituloTextos =
                        especialesBList[f]['titulo'].toString();
                    opcionesSabores.nombreTexto =
                        listOpcionesSabores[t].toString();

                    await opcionesespecialesBDatabase
                        .insertarOpcionesEspecialesB(opcionesSabores);
                  }
                }
              }
            }

            var especialesCList =productos[x]['producto_observaciones_fijas']['especial_3'];

            if (especialesCList.length > 0) {
              for (var f = 0; f < especialesCList.length; f++) {
                Sabores sabores = Sabores();
                sabores.idProducto = productos[x]['id_producto'];
                sabores.tituloTextos = especialesCList[f]['titulo'];
                sabores.maximo = especialesCList[f]['maximo'];

                await especialesCDatabase.insertarEspecialesC(sabores);

                var listOpcionesSabores = especialesCList[f]['opciones'];
                if (listOpcionesSabores.length > 0) {
                  for (var t = 0; t < listOpcionesSabores.length; t++) {
                    OpcionesSabores opcionesSabores = OpcionesSabores();
                    opcionesSabores.idProducto = productos[x]['id_producto'];
                    opcionesSabores.tituloTextos =
                        especialesCList[f]['titulo'].toString();
                    opcionesSabores.nombreTexto =
                        listOpcionesSabores[t].toString();

                    await opcionesespecialesCDatabase
                        .insertarOpcionesEspecialesC(opcionesSabores);
                  }
                }
              }
            }

            var especialesDList =
                productos[x]['producto_observaciones_fijas']['especial_4'];

            if (especialesDList.length > 0) {
              for (var f = 0; f < especialesDList.length; f++) {
                Sabores sabores = Sabores();
                sabores.idProducto = productos[x]['id_producto'];
                sabores.tituloTextos = especialesDList[f]['titulo'];
                sabores.maximo = especialesDList[f]['maximo'];

                await especialesDDatabase.insertarEspecialesD(sabores);

                var listOpcionesSabores = especialesDList[f]['opciones'];
                if (listOpcionesSabores.length > 0) {
                  for (var t = 0; t < listOpcionesSabores.length; t++) {
                    OpcionesSabores opcionesSabores = OpcionesSabores();
                    opcionesSabores.idProducto = productos[x]['id_producto'];
                    opcionesSabores.tituloTextos =
                        especialesDList[f]['titulo'].toString();
                    opcionesSabores.nombreTexto =
                        listOpcionesSabores[t].toString();

                    await opcionesespecialesDDatabase
                        .insertarOpcionesEspecialesD(opcionesSabores);
                  }
                }
              }
            }

            if (productos[x]['id_producto'] == '51') {
              print('ctm');
            }

            var adicionalesList = productos[x]['producto_observaciones_fijas']
                ['adicional_categoria']['opciones'];
            var adicionalesList2 = productos[x]['producto_observaciones_fijas']
                ['adicional_categoria_2']['opciones'];
            var adicionalesList3 = productos[x]['producto_observaciones_fijas']
                ['adicional_categoria_3']['opciones'];
            var adicionalesList4 = productos[x]['producto_observaciones_fijas']
                ['adicional_categoria_4']['opciones'];
            var adicionalesList5 = productos[x]['producto_observaciones_fijas']
                ['adicional_categoria_5']['opciones'];
            var adicionalesList6 = productos[x]['producto_observaciones_fijas']
                ['adicional_categoria_6']['opciones'];

            if (adicionalesList.length > 0) {
              await adicionalesDatabase.deleteAdicionalesPorId(
                  productos[x]['id_producto'], '0');

              for (var i = 0; i < adicionalesList.length; i++) {
                AdicionalesModel adicionalesModel = AdicionalesModel();

                adicionalesModel.idProducto = productos[x]['id_producto'];
                adicionalesModel.idProductoAdicional = adicionalesList[i];
                adicionalesModel.adicionalItem = '0';
                adicionalesModel.titulo = productos[x]
                        ['producto_observaciones_fijas']['adicional_categoria']
                    ['titulo'];
                adicionalesModel.adicionalSeleccionado = '0';

                await adicionalesDatabase.insertarAdicionales(adicionalesModel);
              }
            }

            if (adicionalesList2.length > 0) {
              await adicionalesDatabase.deleteAdicionalesPorId(
                  productos[x]['id_producto'], '1');

              for (var i = 0; i < adicionalesList2.length; i++) {
                AdicionalesModel adicionalesModel = AdicionalesModel();

                adicionalesModel.idProducto = productos[x]['id_producto'];
                adicionalesModel.idProductoAdicional = adicionalesList2[i];
                adicionalesModel.adicionalItem = '1';
                adicionalesModel.titulo = productos[x]
                        ['producto_observaciones_fijas']
                    ['adicional_categoria_2']['titulo'];

                adicionalesModel.adicionalSeleccionado = '0';

                await adicionalesDatabase.insertarAdicionales(adicionalesModel);
              }
            }

            if (adicionalesList3.length > 0) {
              await adicionalesDatabase.deleteAdicionalesPorId(
                  productos[x]['id_producto'], '2');

              for (var i = 0; i < adicionalesList3.length; i++) {
                AdicionalesModel adicionalesModel = AdicionalesModel();

                adicionalesModel.idProducto = productos[x]['id_producto'];
                adicionalesModel.idProductoAdicional = adicionalesList3[i];
                adicionalesModel.adicionalItem = '2';
                adicionalesModel.titulo = productos[x]
                        ['producto_observaciones_fijas']
                    ['adicional_categoria_3']['titulo'];
                adicionalesModel.adicionalSeleccionado = '0';

                await adicionalesDatabase.insertarAdicionales(adicionalesModel);
              }
            }

            if (adicionalesList4.length > 0) {
              await adicionalesDatabase.deleteAdicionalesPorId(
                  productos[x]['id_producto'], '3');

              for (var i = 0; i < adicionalesList4.length; i++) {
                AdicionalesModel adicionalesModel = AdicionalesModel();

                adicionalesModel.idProducto = productos[x]['id_producto'];
                adicionalesModel.idProductoAdicional = adicionalesList4[i];
                adicionalesModel.adicionalItem = '3';
                adicionalesModel.titulo = productos[x]
                        ['producto_observaciones_fijas']
                    ['adicional_categoria_4']['titulo'];

                adicionalesModel.adicionalSeleccionado = '0';

                await adicionalesDatabase.insertarAdicionales(adicionalesModel);
              }
            }

            if (adicionalesList5.length > 0) {
              await adicionalesDatabase.deleteAdicionalesPorId(
                  productos[x]['id_producto'], '4');

              for (var i = 0; i < adicionalesList5.length; i++) {
                AdicionalesModel adicionalesModel = AdicionalesModel();

                adicionalesModel.idProducto = productos[x]['id_producto'];
                adicionalesModel.idProductoAdicional = adicionalesList5[i];
                adicionalesModel.adicionalItem = '4';
                adicionalesModel.titulo = productos[x]
                        ['producto_observaciones_fijas']
                    ['adicional_categoria_5']['titulo'];

                adicionalesModel.adicionalSeleccionado = '0';

                await adicionalesDatabase.insertarAdicionales(adicionalesModel);
              }
            }

            if (adicionalesList6.length > 0) {
              await adicionalesDatabase.deleteAdicionalesPorId(
                  productos[x]['id_producto'], '5');

              for (var i = 0; i < adicionalesList6.length; i++) {
                AdicionalesModel adicionalesModel = AdicionalesModel();

                adicionalesModel.idProducto = productos[x]['id_producto'];
                adicionalesModel.idProductoAdicional = adicionalesList6[i];
                adicionalesModel.adicionalItem = '5';
                adicionalesModel.titulo = productos[x]
                        ['producto_observaciones_fijas']
                    ['adicional_categoria_6']['titulo'];

                adicionalesModel.adicionalSeleccionado = '0';

                await adicionalesDatabase.insertarAdicionales(adicionalesModel);
              }
            }

            */
          }
        }
      }

      return true;
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");

      utils.showToast(
          "Problemas con la conexión a internet", 2, ToastGravity.TOP);
      return false;
    }
  }

  Future<bool> obtenerAdicionalesPorProducto(String idProducto) async {

    print(idProducto);
    try {
      final url = '$urlBase/api/categoria/listar_adicionales_producto';

      final resp = await http.post(url, body: {


        'id_producto':idProducto
      });
      final Map<String, dynamic> decodedData = json.decode(resp.body);
      if (decodedData == null) return false;

      // print(decodedData['result']['data'].length);

      await observacionesFijasDatabase.deleteObservacionesFijas(idProducto);
      await productosFijosDatabase.deleteProductosFijos(idProducto);
      await saboresDatabase.deleteSabores(idProducto);
      await opcionesSaboresDatabase.deleteOpcionesSabores(idProducto);

      await acompanhamientosDatabase.deleteAcompanhamientos(idProducto);
      await opcionesAcompanhamientosDatabase
          .deleteOpcionesAcompanhamientos(idProducto);

      await especialesADatabase.deleteEspecialesA(idProducto);
      await opcionesespecialesADatabase.deleteOpcionesEspecialesA(idProducto);

      await especialesBDatabase.deleteEspecialesB(idProducto);
      await opcionesespecialesBDatabase.deleteOpcionesEspecialesB(idProducto);

      await especialesCDatabase.deleteEspecialesC(idProducto);
      await opcionesespecialesCDatabase.deleteOpcionesEspecialesC(idProducto);

      await especialesDDatabase.deleteEspecialesD(idProducto);
      await opcionesespecialesDDatabase.deleteOpcionesEspecialesD(idProducto);

      await observacionesVariablesDatabase.deleteObservacionesVariables(idProducto);

      ObservacionesFijas observacionesFijas = ObservacionesFijas();
      observacionesFijas.idProducto = idProducto;
      observacionesFijas.mostrar = decodedData['result']['data'] ['producto_observaciones_fijas']['mostrar_fijas'];

      await observacionesFijasDatabase .insertarObservacionesFijas(observacionesFijas);

      var productillos = decodedData['result']['data']['producto_observaciones_fijas']['productos'];

      if (productillos.length > 0) {
        for (var z = 0;
            z <
                decodedData['result']['data']['producto_observaciones_fijas']
                        ['productos']
                    .length;
            z++) {
          final productoIdbuscado =
              await productoDatabase.consultarPorId(productillos[z].toString());

          if (productoIdbuscado.length > 0) {
            ProductosFijos productosFijos = ProductosFijos();
            productosFijos.idProducto = idProducto;
            productosFijos.idRelacionado = productillos[z].toString();
            productosFijos.nombreProducto = productoIdbuscado[0].productoNombre;

            await productosFijosDatabase.insertarProductosFijos(productosFijos);
          }
        }
      }

      var saboresList = decodedData['result']['data']
          ['producto_observaciones_fijas']['sabores'];

      if (saboresList.length > 0) {
        for (var f = 0; f < saboresList.length; f++) {
          Sabores sabores = Sabores();
          sabores.idProducto = idProducto;
          sabores.tituloTextos = saboresList[f]['titulo'];
          sabores.maximo = saboresList[f]['maximo'];

          await saboresDatabase.insertarSabores(sabores);

          var listOpcionesSabores = saboresList[f]['opciones'];
          if (listOpcionesSabores.length > 0) {
            for (var t = 0; t < listOpcionesSabores.length; t++) {
              OpcionesSabores opcionesSabores = OpcionesSabores();
              opcionesSabores.idProducto = idProducto;
              opcionesSabores.tituloTextos =
                  saboresList[f]['titulo'].toString();
              opcionesSabores.nombreTexto = listOpcionesSabores[t].toString();

              await opcionesSaboresDatabase
                  .insertarOpcionesSabores(opcionesSabores);
            }
          }
        }
      }

      var acompanhamientosList = decodedData['result']['data']
          ['producto_observaciones_fijas']['acompanhamientos'];

      if (acompanhamientosList.length > 0) {
        for (var y = 0; y < acompanhamientosList.length; y++) {
          Acompanhamientos acompanhamientosModel = Acompanhamientos();
          acompanhamientosModel.idProducto =idProducto;
          acompanhamientosModel.tituloTextos =
              acompanhamientosList[y]['titulo'].toString();

          await acompanhamientosDatabase
              .insertarAcompanhamientos(acompanhamientosModel);

          var listOpcionesAcompanhamientos =
              acompanhamientosList[y]['opciones'];
          if (listOpcionesAcompanhamientos.length > 0) {
            for (var t = 0; t < listOpcionesAcompanhamientos.length; t++) {
              OpcionesAcompanhamientos opcionesAcompanhamientosModel =
                  OpcionesAcompanhamientos();
              opcionesAcompanhamientosModel.idProducto = idProducto;
              opcionesAcompanhamientosModel.tituloTextos =
                  acompanhamientosList[y]['titulo'];
              opcionesAcompanhamientosModel.nombreTexto =
                  listOpcionesAcompanhamientos[t].toString();

              await opcionesAcompanhamientosDatabase
                  .insertarOpcionesAcompanhamientos(
                      opcionesAcompanhamientosModel);
            }
          }
        }
      }

      var variblesObservaciones =
          decodedData['result']['data']['producto_observaciones_variables'];
      if (variblesObservaciones.length > 0) {
        for (var a = 0; a < variblesObservaciones.length; a++) {
          ObservacionesVariables observacionesVariables =
              ObservacionesVariables();
          observacionesVariables.idProducto = idProducto;
          observacionesVariables.nombreVariable =
              variblesObservaciones[a].toString();
          await observacionesVariablesDatabase
              .insertarObservacionesVariables(observacionesVariables);
        }
      }

      var especialesAList = decodedData['result']['data']
          ['producto_observaciones_fijas']['especial_1'];
      if (especialesAList.length > 0) {
        for (var f = 0; f < especialesAList.length; f++) {
          Sabores sabores = Sabores();
          sabores.idProducto = idProducto;
          sabores.tituloTextos = especialesAList[f]['titulo'];
          sabores.maximo = especialesAList[f]['maximo'];

          await especialesADatabase.insertarEspecialesA(sabores);

          var listOpcionesSabores = especialesAList[f]['opciones'];
          if (listOpcionesSabores.length > 0) {
            for (var t = 0; t < listOpcionesSabores.length; t++) {
              OpcionesSabores opcionesSabores = OpcionesSabores();
              opcionesSabores.idProducto = idProducto;
              opcionesSabores.tituloTextos =
                  especialesAList[f]['titulo'].toString();
              opcionesSabores.nombreTexto = listOpcionesSabores[t].toString();

              await opcionesespecialesADatabase
                  .insertarOpcionesEspecialesA(opcionesSabores);
            }
          }
        }
      }

      var especialesBList = decodedData['result']['data']
          ['producto_observaciones_fijas']['especial_2'];

      if (especialesBList.length > 0) {
        for (var f = 0; f < especialesBList.length; f++) {
          Sabores sabores = Sabores();
          sabores.idProducto = idProducto;
          sabores.tituloTextos = especialesBList[f]['titulo'];
          sabores.maximo = especialesBList[f]['maximo'];

          await especialesBDatabase.insertarEspecialesB(sabores);

          var listOpcionesSabores = especialesBList[f]['opciones'];
          if (listOpcionesSabores.length > 0) {
            for (var t = 0; t < listOpcionesSabores.length; t++) {
              OpcionesSabores opcionesSabores = OpcionesSabores();
              opcionesSabores.idProducto = idProducto;
              opcionesSabores.tituloTextos =
                  especialesBList[f]['titulo'].toString();
              opcionesSabores.nombreTexto = listOpcionesSabores[t].toString();

              await opcionesespecialesBDatabase
                  .insertarOpcionesEspecialesB(opcionesSabores);
            }
          }
        }
      }

      var especialesCList = decodedData['result']['data']
          ['producto_observaciones_fijas']['especial_3'];

      if (especialesCList.length > 0) {
        for (var f = 0; f < especialesCList.length; f++) {
          Sabores sabores = Sabores();
          sabores.idProducto = idProducto;
          sabores.tituloTextos = especialesCList[f]['titulo'];
          sabores.maximo = especialesCList[f]['maximo'];

          await especialesCDatabase.insertarEspecialesC(sabores);

          var listOpcionesSabores = especialesCList[f]['opciones'];
          if (listOpcionesSabores.length > 0) {
            for (var t = 0; t < listOpcionesSabores.length; t++) {
              OpcionesSabores opcionesSabores = OpcionesSabores();
              opcionesSabores.idProducto = idProducto;
              opcionesSabores.tituloTextos =
                  especialesCList[f]['titulo'].toString();
              opcionesSabores.nombreTexto = listOpcionesSabores[t].toString();

              await opcionesespecialesCDatabase
                  .insertarOpcionesEspecialesC(opcionesSabores);
            }
          }
        }
      }

      var especialesDList = decodedData['result']['data']
          ['producto_observaciones_fijas']['especial_4'];

      if (especialesDList.length > 0) {
        for (var f = 0; f < especialesDList.length; f++) {
          Sabores sabores = Sabores();
          sabores.idProducto = idProducto;
          sabores.tituloTextos = especialesDList[f]['titulo'];
          sabores.maximo = especialesDList[f]['maximo'];

          await especialesDDatabase.insertarEspecialesD(sabores);

          var listOpcionesSabores = especialesDList[f]['opciones'];
          if (listOpcionesSabores.length > 0) {
            for (var t = 0; t < listOpcionesSabores.length; t++) {
              OpcionesSabores opcionesSabores = OpcionesSabores();
              opcionesSabores.idProducto = idProducto;
              opcionesSabores.tituloTextos =
                  especialesDList[f]['titulo'].toString();
              opcionesSabores.nombreTexto = listOpcionesSabores[t].toString();

              await opcionesespecialesDDatabase
                  .insertarOpcionesEspecialesD(opcionesSabores);
            }
          }
        }
      }

      var adicionalesList = decodedData['result']['data']
          ['producto_observaciones_fijas']['adicional_categoria']['opciones'];
      var adicionalesList2 = decodedData['result']['data']
          ['producto_observaciones_fijas']['adicional_categoria_2']['opciones'];
      var adicionalesList3 = decodedData['result']['data']
          ['producto_observaciones_fijas']['adicional_categoria_3']['opciones'];
      var adicionalesList4 = decodedData['result']['data']
          ['producto_observaciones_fijas']['adicional_categoria_4']['opciones'];
      var adicionalesList5 = decodedData['result']['data']
          ['producto_observaciones_fijas']['adicional_categoria_5']['opciones'];
      var adicionalesList6 = decodedData['result']['data']
          ['producto_observaciones_fijas']['adicional_categoria_6']['opciones'];

      if (adicionalesList.length > 0) {
        await adicionalesDatabase.deleteAdicionalesPorId(idProducto, '0');

        for (var i = 0; i < adicionalesList.length; i++) {
          AdicionalesModel adicionalesModel = AdicionalesModel();

          adicionalesModel.idProducto = idProducto;
          adicionalesModel.idProductoAdicional = adicionalesList[i];
          adicionalesModel.adicionalItem = '0';
          adicionalesModel.titulo = decodedData['result']['data']
              ['producto_observaciones_fijas']['adicional_categoria']['titulo'];
          adicionalesModel.adicionalSeleccionado = '0';

          await adicionalesDatabase.insertarAdicionales(adicionalesModel);
        }
      }

      if (adicionalesList2.length > 0) {
        await adicionalesDatabase.deleteAdicionalesPorId(idProducto, '1');

        for (var i = 0; i < adicionalesList2.length; i++) {
          AdicionalesModel adicionalesModel = AdicionalesModel();

          adicionalesModel.idProducto = idProducto;
          adicionalesModel.idProductoAdicional = adicionalesList2[i];
          adicionalesModel.adicionalItem = '1';
          adicionalesModel.titulo = decodedData['result']['data']
                  ['producto_observaciones_fijas']['adicional_categoria_2']
              ['titulo'];

          adicionalesModel.adicionalSeleccionado = '0';

          await adicionalesDatabase.insertarAdicionales(adicionalesModel);
        }
      }

      if (adicionalesList3.length > 0) {
        await adicionalesDatabase.deleteAdicionalesPorId(idProducto, '2');

        for (var i = 0; i < adicionalesList3.length; i++) {
          AdicionalesModel adicionalesModel = AdicionalesModel();

          adicionalesModel.idProducto = idProducto;
          adicionalesModel.idProductoAdicional = adicionalesList3[i];
          adicionalesModel.adicionalItem = '2';
          adicionalesModel.titulo = decodedData['result']['data']
                  ['producto_observaciones_fijas']['adicional_categoria_3']
              ['titulo'];
          adicionalesModel.adicionalSeleccionado = '0';

          await adicionalesDatabase.insertarAdicionales(adicionalesModel);
        }
      }

      if (adicionalesList4.length > 0) {
        await adicionalesDatabase.deleteAdicionalesPorId(idProducto, '3');

        for (var i = 0; i < adicionalesList4.length; i++) {
          AdicionalesModel adicionalesModel = AdicionalesModel();

          adicionalesModel.idProducto = idProducto;
          adicionalesModel.idProductoAdicional = adicionalesList4[i];
          adicionalesModel.adicionalItem = '3';
          adicionalesModel.titulo = decodedData['result']['data']
                  ['producto_observaciones_fijas']['adicional_categoria_4']
              ['titulo'];

          adicionalesModel.adicionalSeleccionado = '0';

          await adicionalesDatabase.insertarAdicionales(adicionalesModel);
        }
      }

      if (adicionalesList5.length > 0) {
        await adicionalesDatabase.deleteAdicionalesPorId(idProducto, '4');

        for (var i = 0; i < adicionalesList5.length; i++) {
          AdicionalesModel adicionalesModel = AdicionalesModel();

          adicionalesModel.idProducto = idProducto;
          adicionalesModel.idProductoAdicional = adicionalesList5[i];
          adicionalesModel.adicionalItem = '4';
          adicionalesModel.titulo = decodedData['result']['data']
                  ['producto_observaciones_fijas']['adicional_categoria_5']
              ['titulo'];

          adicionalesModel.adicionalSeleccionado = '0';

          await adicionalesDatabase.insertarAdicionales(adicionalesModel);
        }
      }

      if (adicionalesList6.length > 0) {
        await adicionalesDatabase.deleteAdicionalesPorId(idProducto, '5');

        for (var i = 0; i < adicionalesList6.length; i++) {
          AdicionalesModel adicionalesModel = AdicionalesModel();

          adicionalesModel.idProducto = idProducto;
          adicionalesModel.idProductoAdicional = adicionalesList6[i];
          adicionalesModel.adicionalItem = '5';
          adicionalesModel.titulo = decodedData['result']['data']
                  ['producto_observaciones_fijas']['adicional_categoria_6']
              ['titulo'];

          adicionalesModel.adicionalSeleccionado = '0';

          await adicionalesDatabase.insertarAdicionales(adicionalesModel);
        }
      }

      return true;
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");

      utils.showToast(
          "Problemas con la conexión a internet", 2, ToastGravity.TOP);
      return false;
    }
  }
}
