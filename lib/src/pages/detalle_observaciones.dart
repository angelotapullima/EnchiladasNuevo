import 'package:cached_network_image/cached_network_image.dart';
import 'package:chips_choice/chips_choice.dart';
import 'package:enchiladasapp/src/bloc/adicionales_bloc.dart';
import 'package:enchiladasapp/src/bloc/provider.dart';
import 'package:enchiladasapp/src/models/adicionales_model.dart';
import 'package:enchiladasapp/src/models/observaciones_model.dart';
import 'package:enchiladasapp/src/models/productos_model.dart';
import 'package:enchiladasapp/src/utils/responsive.dart';
import 'package:enchiladasapp/src/utils/utilidades.dart' as utils;
import 'package:enchiladasapp/src/widgets/chip_csm.dart';
import 'package:enchiladasapp/src/widgets/customCacheManager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class DetalleObservaciones extends StatefulWidget {
  final String idProductoArgument;
  final String idCategoria;
  final String cantidadAdicional;
  const DetalleObservaciones(
      {Key key,
      @required this.idProductoArgument,
      @required this.idCategoria,
      @required this.cantidadAdicional})
      : super(key: key);

  @override
  _DetalleObservacionesState createState() => _DetalleObservacionesState();
}

class _DetalleObservacionesState extends State<DetalleObservaciones> {
  var nombredeProducto;
  //productos Fijos
  int tagFijos = 0;
  bool fijos = false;
  String idProductoFijo = 'false';

  //sabores
  List<String> tagsSabores = [];
  bool sabores = false;
  int maximoSabores = 0;
  String tituloSabores = '';

  //acompañamiento
  int tagAcompanhamientos;
  bool acompanhamientosBoolVariable = false;
  String idAcompanhamiento = 'false';
  String tituloAcom = '';

  //especiales1
  List<String> tagsEspeciales1 = [];
  bool especiales1 = false;
  int maximoespeciales1 = 0;
  String tituloEspeciales1 = '';

  //especiales2
  List<String> tagsEspeciales2 = [];
  bool especiales2 = false;
  int maximoespeciales2 = 0;
  String tituloEspeciales2 = '';

  //especiales3
  List<String> tagsEspeciales3 = [];
  bool especiales3 = false;
  int maximoespeciales3 = 0;
  String tituloEspeciales3 = '';

  //especiales4
  List<String> tagsEspeciales4 = [];
  bool especiales4 = false;
  int maximoespeciales4 = 0;
  String tituloEspeciales4 = '';

  //int tag;

  //variables
  List<String> tagsVariables = [];
  bool variables = false;

  int cant = 0;

  @override
  Widget build(BuildContext context) {
    final observacionesProductoBloc = ProviderBloc.observaciones(context);
    final adicionalesBloc = ProviderBloc.adicionales(context);
    adicionalesBloc.obtenerAdicionales(widget.idProductoArgument);

    final itemObservacionBloc = ProviderBloc.itemOb(context);
    if (cant == 0) {
      observacionesProductoBloc.obtenerObservaciones(widget.idProductoArgument);

      itemObservacionBloc.obtenerObservacionItem();
    }

    final responsive = Responsive.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Adicionales'),
      ),
      body: Stack(
        children: [
          StreamBuilder(
              stream: observacionesProductoBloc.observacionesStream,
              builder: (context, AsyncSnapshot<List<Observaciones>> snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data.length > 0) {
                    bool validacionFijos = false;
                    bool validacionSabores = false;
                    bool validacionVariables = false;
                    bool validacionEspeciales1 = false;
                    bool validacionEspeciales2 = false;
                    bool validacionEspeciales3 = false;
                    bool validacionEspeciales4 = false;
                    bool validacionAcompa = false;
                    final optionsProductosFijos = List<String>();
                    final optionsProductosVariables = List<String>();

                    for (var x = 0;
                        x < snapshot.data[0].fijas[0].productosFijos.length;
                        x++) {
                      String texto = snapshot
                          .data[0].fijas[0].productosFijos[x].nombreProducto;
                      optionsProductosFijos.add(texto);
                    }

                    for (var x = 0;
                        x < snapshot.data[0].variables.length;
                        x++) {
                      String texto =
                          snapshot.data[0].variables[x].nombreVariable;
                      optionsProductosVariables.add(texto);
                    }

                    if (optionsProductosFijos.length > 0) {
                      validacionFijos = true;
                    }
                    if (optionsProductosVariables.length > 0) {
                      validacionVariables = true;
                    }

                    if (snapshot.data[0].fijas[0].sabores.length > 0) {
                      validacionSabores = true;
                      maximoSabores = int.parse(
                          snapshot.data[0].fijas[0].sabores[0].maximo);

                      tituloSabores =
                          '${snapshot.data[0].fijas[0].sabores[0].tituloTextos} ';
                    }

                    //especialesA
                    if (snapshot.data[0].fijas[0].especialesA.length > 0) {
                      print('hay especiales1');
                      validacionEspeciales1 = true;
                      maximoespeciales1 = int.parse(
                          snapshot.data[0].fijas[0].especialesA[0].maximo);

                      tituloEspeciales1 =
                          '${snapshot.data[0].fijas[0].especialesA[0].tituloTextos}';
                    }

                    //especialesB
                    if (snapshot.data[0].fijas[0].especialesB.length > 0) {
                      print('hay especiales2');
                      validacionEspeciales2 = true;
                      maximoespeciales2 = int.parse(
                          snapshot.data[0].fijas[0].especialesB[0].maximo);

                      tituloEspeciales2 =
                          '${snapshot.data[0].fijas[0].especialesB[0].tituloTextos}';
                    }

                    //especialesC
                    if (snapshot.data[0].fijas[0].especialesC.length > 0) {
                      print('hay especiales3');
                      validacionEspeciales3 = true;
                      maximoespeciales3 = int.parse(
                          snapshot.data[0].fijas[0].especialesC[0].maximo);

                      tituloEspeciales3 =
                          '${snapshot.data[0].fijas[0].especialesC[0].tituloTextos}';
                    }

                    //especialesD
                    if (snapshot.data[0].fijas[0].especialesD.length > 0) {
                      print('hay especiales4');
                      validacionEspeciales4 = true;
                      maximoespeciales4 = int.parse(
                          snapshot.data[0].fijas[0].especialesD[0].maximo);

                      tituloEspeciales4 =
                          '${snapshot.data[0].fijas[0].especialesD[0].tituloTextos}';
                    }

                    if (snapshot.data[0].fijas[0].acompanhamientos.length >=
                        1) {
                      validacionAcompa = true;
                      tituloAcom =
                          '${snapshot.data[0].fijas[0].acompanhamientos[0].tituloTextos}';
                    }

                    fijos = validacionFijos;
                    variables = validacionVariables;
                    sabores = validacionSabores;
                    especiales1 = validacionEspeciales1;
                    especiales2 = validacionEspeciales2;
                    especiales3 = validacionEspeciales3;
                    especiales4 = validacionEspeciales4;
                    acompanhamientosBoolVariable = validacionAcompa;

                    return ListView(addAutomaticKeepAlives: true, children: [
                      StreamBuilder(
                        stream: itemObservacionBloc.itemObservacioStream,
                        builder: (BuildContext context,
                            AsyncSnapshot<List<ProductosData>> snapshot) {
                          if (snapshot.hasData) {
                            if (snapshot.data.length > 0) {
                              return ListView.builder(
                                shrinkWrap: true,
                                physics: ClampingScrollPhysics(),
                                itemCount: snapshot.data.length,
                                itemBuilder: (context, index) {
                                  if ('${snapshot.data[index].productoTipo}' !=
                                      'adicional') {
                                    nombredeProducto =
                                        snapshot.data[index].productoNombre;
                                  }

                                  return ('${snapshot.data[index].productoTipo}' !=
                                          'adicional')
                                      ? Padding(
                                          padding: EdgeInsets.only(
                                              left: 15, right: 15, top: 8),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Row(
                                                children: <Widget>[
                                                  Container(
                                                    width: responsive.ip(18),
                                                    height: responsive.ip(13),
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      child: CachedNetworkImage(
                                                        cacheManager:
                                                            CustomCacheManager(),
                                                        placeholder: (context,
                                                                url) =>
                                                            Image(
                                                                image: AssetImage(
                                                                    'assets/jar-loading.gif'),
                                                                fit: BoxFit
                                                                    .cover),
                                                        errorWidget: (context,
                                                                url, error) =>
                                                            Image(
                                                                image: AssetImage(
                                                                    'assets/carga_fallida.jpg'),
                                                                fit: BoxFit
                                                                    .cover),
                                                        imageUrl:
                                                            '${snapshot.data[index].productoFoto}',
                                                        imageBuilder: (context,
                                                                imageProvider) =>
                                                            Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            image:
                                                                DecorationImage(
                                                              image:
                                                                  imageProvider,
                                                              fit: BoxFit.fill,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: responsive.wp(2),
                                                  ),
                                                  Expanded(
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        Text(
                                                          snapshot.data[index]
                                                              .productoNombre,
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: responsive
                                                                .ip(1.8),
                                                          ),
                                                        ),
                                                        Text(
                                                          'S/. ${snapshot.data[index].productoPrecio}',
                                                          style: TextStyle(
                                                            color: Colors.red,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: responsive
                                                                .ip(2),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: responsive.hp(.6),
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Text(
                                                    'Observaciones : ',
                                                    style: TextStyle(
                                                        fontSize:
                                                            responsive.ip(1.8),
                                                        fontWeight:
                                                            FontWeight.w700),
                                                  ),
                                                  Text(
                                                    '${snapshot.data[index].productoObservacion}',
                                                    style: TextStyle(
                                                      fontSize:
                                                          responsive.ip(1.7),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: responsive.hp(1),
                                              ),
                                              (snapshot.data.length > 1)
                                                  ? Text(
                                                      'Adicionales',
                                                      style: TextStyle(
                                                          fontSize: responsive
                                                              .ip(1.7),
                                                          fontWeight:
                                                              FontWeight.w700),
                                                    )
                                                  : Container()
                                            ],
                                          ),
                                        )
                                      : Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 15.0),
                                          child: RichText(
                                            text: TextSpan(children: [
                                              TextSpan(
                                                text:
                                                    '${snapshot.data[index].productoNombre}   ',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                              TextSpan(
                                                text:
                                                    'S/.${snapshot.data[index].productoPrecio}',
                                                style: TextStyle(
                                                    color: Colors.red,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                            ]),
                                          ),
                                        );
                                },
                              );
                            } else {
                              return Center(
                                child: Text('Hubo un error'),
                              );
                            }
                          } else {
                            return Center(
                              child: CupertinoActivityIndicator(),
                            );
                          }
                        },
                      ),
                      (optionsProductosFijos.length > 0)
                          ? Content(
                              title: 'Adicionales Fijos (máximo 1 opción)',
                              child: ChipsChoice<int>.single(
                                value: tagFijos,
                                onChanged: (val) {
                                  setState(() {
                                    cant++;
                                    idProductoFijo =
                                        '${snapshot.data[0].fijas[0].productosFijos[val].idRelacionado}';
                                    tagFijos = val;

                                    utils.agregarItemObservacionFijos(context,
                                        idProductoFijo, true, 'producto');
                                  });
                                },
                                choiceItems: C2Choice.listFrom<int, String>(
                                  source: optionsProductosFijos,
                                  value: (i, v) => i,
                                  label: (i, v) => v,
                                  tooltip: (i, v) => v,
                                ),
                                choiceStyle: C2ChoiceStyle(
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(5),
                                  ),
                                ),
                                wrapped: true,
                              ),
                            )
                          : Container(),

                      //sabores
                      ListView.builder(
                        shrinkWrap: true,
                        physics: ClampingScrollPhysics(),
                        addAutomaticKeepAlives: true,
                        itemCount: snapshot.data[0].fijas[0].sabores.length,
                        itemBuilder: (context, index) {
                          return Content(
                            title:
                                '${snapshot.data[0].fijas[0].sabores[index].tituloTextos} (máximo ${snapshot.data[0].fijas[0].sabores[index].maximo} opciones)',
                            child: ChipsChoice<String>.multiple(
                              value: tagsSabores,
                              onChanged: (val) {
                                bool paso = false;

                                if (tagsSabores.length >=
                                    int.parse(snapshot.data[0].fijas[0]
                                        .sabores[index].maximo)) {
                                  if (val.length > 0) {
                                    for (var i = 0; i < val.length; i++) {
                                      var valor = val[i].toString();

                                      for (var x = 0;
                                          x < tagsSabores.length;
                                          x++) {
                                        var valor2 = tagsSabores[i].toString();

                                        if (valor == valor2) {
                                          paso = true;
                                        }
                                      }
                                    }
                                  } else {
                                    paso = true;
                                  }

                                  if (paso) {
                                    setState(() {
                                      cant++;
                                      tagsSabores = val;
                                    });

                                    utils
                                        .agregarObservacionEnProductoObservacion(
                                            context,
                                            tituloSabores,
                                            tagsSabores,
                                            tituloEspeciales1,
                                            tagsEspeciales1,
                                            tituloEspeciales2,
                                            tagsEspeciales2,
                                            tituloEspeciales3,
                                            tagsEspeciales3,
                                            tituloEspeciales4,
                                            tagsEspeciales4,
                                            tagsVariables,
                                            tituloAcom,
                                            idAcompanhamiento);
                                  }
                                } else {
                                  setState(() {
                                    cant++;
                                    tagsSabores = val;

                                    utils
                                        .agregarObservacionEnProductoObservacion(
                                            context,
                                            tituloSabores,
                                            tagsSabores,
                                            tituloEspeciales1,
                                            tagsEspeciales1,
                                            tituloEspeciales2,
                                            tagsEspeciales2,
                                            tituloEspeciales3,
                                            tagsEspeciales3,
                                            tituloEspeciales4,
                                            tagsEspeciales4,
                                            tagsVariables,
                                            tituloAcom,
                                            idAcompanhamiento);
                                  });
                                }
                              },
                              choiceItems: C2Choice.listFrom<String, String>(
                                source: snapshot.data[0].fijas[0].sabores[index]
                                    .nombrecitos,
                                value: (i, v) => v,
                                label: (i, v) => v,
                                tooltip: (i, v) => v,
                              ),
                              wrapped: true,
                            ),
                          );
                        },
                      ),
                      //Acompañamientos
                      ListView.builder(
                        shrinkWrap: true,
                        physics: ClampingScrollPhysics(),
                        addAutomaticKeepAlives: true,
                        itemCount:
                            snapshot.data[0].fijas[0].acompanhamientos.length,
                        itemBuilder: (context, index) {
                          return Content(
                            title:
                                '${snapshot.data[0].fijas[0].acompanhamientos[index].tituloTextos} (máximo 1 opción)',
                            child: ChipsChoice<int>.single(
                              value: tagAcompanhamientos,
                              onChanged: (val) {
                                idAcompanhamiento =
                                    '${snapshot.data[0].fijas[0].acompanhamientos[0].acompanhamientos[val].nombreTexto}';

                                setState(() {
                                  cant++;
                                  tagAcompanhamientos = val;

                                  utils.agregarObservacionEnProductoObservacion(
                                      context,
                                      tituloSabores,
                                      tagsSabores,
                                      tituloEspeciales1,
                                      tagsEspeciales1,
                                      tituloEspeciales2,
                                      tagsEspeciales2,
                                      tituloEspeciales3,
                                      tagsEspeciales3,
                                      tituloEspeciales4,
                                      tagsEspeciales4,
                                      tagsVariables,
                                      tituloAcom,
                                      idAcompanhamiento);
                                });
                              },
                              choiceItems: C2Choice.listFrom<int, String>(
                                source: snapshot.data[0].fijas[0]
                                    .acompanhamientos[index].nombrecitos,
                                value: (i, v) => i,
                                label: (i, v) => v,
                                tooltip: (i, v) => v,
                              ),
                              choiceStyle: C2ChoiceStyle(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(5)),
                              ),
                              wrapped: true,
                            ),
                          );
                        },
                      ),

                      //especiales1
                      ListView.builder(
                        shrinkWrap: true,
                        physics: ClampingScrollPhysics(),
                        addAutomaticKeepAlives: true,
                        itemCount: snapshot.data[0].fijas[0].especialesA.length,
                        itemBuilder: (context, index) {
                          return Content(
                            title:
                                '${snapshot.data[0].fijas[0].especialesA[index].tituloTextos} (máximo ${snapshot.data[0].fijas[0].especialesA[index].maximo} opciones)',
                            child: ChipsChoice<String>.multiple(
                              value: tagsEspeciales1,
                              onChanged: (val) {
                                bool paso = false;
                                int lalal = int.parse(snapshot.data[0].fijas[0]
                                        .especialesA[index].maximo) ;

                                if (tagsEspeciales1.length >= lalal) {
                                  if (val.length > 0) {
                                    for (var i = 0; i < val.length; i++) {
                                      var valor = val[i].toString();

                                      for (var x = 0;
                                          x < tagsEspeciales1.length;
                                          x++) {
                                        var valor2 =
                                            tagsEspeciales1[i].toString();

                                        if (valor == valor2) {
                                          paso = true;
                                        }
                                      }
                                    }
                                  } else {
                                    paso = true;
                                  }

                                  if (paso) {
                                    setState(() {
                                      cant++;
                                      tagsEspeciales1 = val;
                                    });

                                    utils
                                        .agregarObservacionEnProductoObservacion(
                                            context,
                                            tituloSabores,
                                            tagsSabores,
                                            tituloEspeciales1,
                                            tagsEspeciales1,
                                            tituloEspeciales2,
                                            tagsEspeciales2,
                                            tituloEspeciales3,
                                            tagsEspeciales3,
                                            tituloEspeciales4,
                                            tagsEspeciales4,
                                            tagsVariables,
                                            tituloAcom,
                                            idAcompanhamiento);
                                  }
                                } else {
                                  setState(() {
                                    cant++;
                                    tagsEspeciales1 = val;

                                    utils
                                        .agregarObservacionEnProductoObservacion(
                                            context,
                                            tituloSabores,
                                            tagsSabores,
                                            tituloEspeciales1,
                                            tagsEspeciales1,
                                            tituloEspeciales2,
                                            tagsEspeciales2,
                                            tituloEspeciales3,
                                            tagsEspeciales3,
                                            tituloEspeciales4,
                                            tagsEspeciales4,
                                            tagsVariables,
                                            tituloAcom,
                                            idAcompanhamiento);
                                  });
                                }
                              },
                              choiceItems: C2Choice.listFrom<String, String>(
                                source: snapshot.data[0].fijas[0]
                                    .especialesA[index].nombrecitos,
                                value: (i, v) => v,
                                label: (i, v) => v,
                                tooltip: (i, v) => v,
                              ),
                              wrapped: true,
                            ),
                          );
                        },
                      ),

                      //especiales2
                      ListView.builder(
                        shrinkWrap: true,
                        physics: ClampingScrollPhysics(),
                        addAutomaticKeepAlives: true,
                        itemCount: snapshot.data[0].fijas[0].especialesB.length,
                        itemBuilder: (context, index) {
                          return Content(
                            title:
                                '${snapshot.data[0].fijas[0].especialesB[index].tituloTextos} (máximo ${snapshot.data[0].fijas[0].especialesB[index].maximo} opciones)',
                            child: ChipsChoice<String>.multiple(
                              value: tagsEspeciales2,
                              onChanged: (val) {
                                bool paso = false;

                                if (tagsEspeciales2.length >=
                                    int.parse(snapshot.data[0].fijas[0]
                                        .especialesB[index].maximo)) {
                                  if (val.length > 0) {
                                    for (var i = 0; i < val.length; i++) {
                                      var valor = val[i].toString();

                                      for (var x = 0;
                                          x < tagsEspeciales2.length;
                                          x++) {
                                        var valor2 =
                                            tagsEspeciales2[i].toString();

                                        if (valor == valor2) {
                                          paso = true;
                                        }
                                      }
                                    }
                                  } else {
                                    paso = true;
                                  }

                                  if (paso) {
                                    setState(() {
                                      cant++;
                                      tagsEspeciales2 = val;
                                    });

                                    utils
                                        .agregarObservacionEnProductoObservacion(
                                            context,
                                            tituloSabores,
                                            tagsSabores,
                                            tituloEspeciales1,
                                            tagsEspeciales1,
                                            tituloEspeciales2,
                                            tagsEspeciales2,
                                            tituloEspeciales3,
                                            tagsEspeciales3,
                                            tituloEspeciales4,
                                            tagsEspeciales4,
                                            tagsVariables,
                                            tituloAcom,
                                            idAcompanhamiento);
                                  }
                                } else {
                                  setState(() {
                                    cant++;
                                    tagsEspeciales2 = val;

                                    utils
                                        .agregarObservacionEnProductoObservacion(
                                            context,
                                            tituloSabores,
                                            tagsSabores,
                                            tituloEspeciales1,
                                            tagsEspeciales1,
                                            tituloEspeciales2,
                                            tagsEspeciales2,
                                            tituloEspeciales3,
                                            tagsEspeciales3,
                                            tituloEspeciales4,
                                            tagsEspeciales4,
                                            tagsVariables,
                                            tituloAcom,
                                            idAcompanhamiento);
                                  });
                                }
                              },
                              choiceItems: C2Choice.listFrom<String, String>(
                                source: snapshot.data[0].fijas[0]
                                    .especialesB[index].nombrecitos,
                                value: (i, v) => v,
                                label: (i, v) => v,
                                tooltip: (i, v) => v,
                              ),
                              wrapped: true,
                            ),
                          );
                        },
                      ),

                      //especiales3
                      ListView.builder(
                        shrinkWrap: true,
                        physics: ClampingScrollPhysics(),
                        addAutomaticKeepAlives: true,
                        itemCount: snapshot.data[0].fijas[0].especialesC.length,
                        itemBuilder: (context, index) {
                          return Content(
                            title:
                                '${snapshot.data[0].fijas[0].especialesC[index].tituloTextos} (máximo ${snapshot.data[0].fijas[0].especialesC[index].maximo} opciones)',
                            child: ChipsChoice<String>.multiple(
                              value: tagsEspeciales3,
                              onChanged: (val) {
                                bool paso = false;

                                /*  if (tagsSabores.length >=int.parse(snapshot.data[0].fijas[0].sabores[index].maximo)) {
                                  if (val.length > 0) {
                                    for (var i = 0; i < val.length; i++) {
                                      var valor = val[i].toString();

                                      for (var x = 0;
                                          x < tagsSabores.length;
                                          x++) {
                                        var valor2 = tagsSabores[i].toString();

                                        if (valor == valor2) {
                                          paso = true;
                                        }
                                      }
                                    }
                                  } else {
                                    paso = true;
                                  } */

                                int hhh = int.parse(snapshot.data[0].fijas[0]
                                    .especialesC[index].maximo);
                                if (tagsEspeciales3.length >= hhh) {
                                  if (val.length > 0) {
                                    for (var i = 0; i < val.length; i++) {
                                      var valor = val[i].toString();

                                      for (var x = 0;
                                          x < tagsEspeciales3.length;
                                          x++) {
                                        var valor2 =
                                            tagsEspeciales3[i].toString();

                                        if (valor == valor2) {
                                          paso = true;
                                        }
                                      }
                                    }
                                  } else {
                                    paso = true;
                                  }

                                  if (paso) {
                                    setState(() {
                                      cant++;
                                      tagsEspeciales3 = val;
                                    });

                                    utils
                                        .agregarObservacionEnProductoObservacion(
                                            context,
                                            tituloSabores,
                                            tagsSabores,
                                            tituloEspeciales1,
                                            tagsEspeciales1,
                                            tituloEspeciales2,
                                            tagsEspeciales2,
                                            tituloEspeciales3,
                                            tagsEspeciales3,
                                            tituloEspeciales4,
                                            tagsEspeciales4,
                                            tagsVariables,
                                            tituloAcom,
                                            idAcompanhamiento);
                                  }
                                } else if (tagsEspeciales3.length > hhh) {
                                  setState(() {
                                    tagsEspeciales3 = val;
                                    utils
                                        .agregarObservacionEnProductoObservacion(
                                            context,
                                            tituloSabores,
                                            tagsSabores,
                                            tituloEspeciales1,
                                            tagsEspeciales1,
                                            tituloEspeciales2,
                                            tagsEspeciales2,
                                            tituloEspeciales3,
                                            tagsEspeciales3,
                                            tituloEspeciales4,
                                            tagsEspeciales4,
                                            tagsVariables,
                                            tituloAcom,
                                            idAcompanhamiento);
                                  });
                                } else {
                                  setState(() {
                                    cant++;
                                    tagsEspeciales3 = val;

                                    utils
                                        .agregarObservacionEnProductoObservacion(
                                            context,
                                            tituloSabores,
                                            tagsSabores,
                                            tituloEspeciales1,
                                            tagsEspeciales1,
                                            tituloEspeciales2,
                                            tagsEspeciales2,
                                            tituloEspeciales3,
                                            tagsEspeciales3,
                                            tituloEspeciales4,
                                            tagsEspeciales4,
                                            tagsVariables,
                                            tituloAcom,
                                            idAcompanhamiento);
                                  });
                                }
                              },
                              choiceItems: C2Choice.listFrom<String, String>(
                                source: snapshot.data[0].fijas[0]
                                    .especialesC[index].nombrecitos,
                                value: (i, v) => v,
                                label: (i, v) => v,
                                tooltip: (i, v) => v,
                              ),
                              wrapped: true,
                            ),
                          );
                        },
                      ),

                      //especiales4
                      ListView.builder(
                        shrinkWrap: true,
                        physics: ClampingScrollPhysics(),
                        addAutomaticKeepAlives: true,
                        itemCount: snapshot.data[0].fijas[0].especialesD.length,
                        itemBuilder: (context, index) {
                          return Content(
                            title:
                                '${snapshot.data[0].fijas[0].especialesD[index].tituloTextos} (máximo ${snapshot.data[0].fijas[0].especialesD[index].maximo} opciones)',
                            child: ChipsChoice<String>.multiple(
                              value: tagsEspeciales4,
                              onChanged: (val) {
                                bool paso = false;

                                if (tagsEspeciales4.length >=
                                    int.parse(snapshot.data[0].fijas[0]
                                        .especialesD[index].maximo)) {
                                  if (val.length > 0) {
                                    for (var i = 0; i < val.length; i++) {
                                      var valor = val[i].toString();

                                      for (var x = 0;
                                          x < tagsEspeciales4.length;
                                          x++) {
                                        var valor2 =
                                            tagsEspeciales4[i].toString();

                                        if (valor == valor2) {
                                          paso = true;
                                        }
                                      }
                                    }
                                  } else {
                                    paso = true;
                                  }

                                  if (paso) {
                                    setState(() {
                                      cant++;
                                      tagsEspeciales4 = val;
                                    });

                                    utils
                                        .agregarObservacionEnProductoObservacion(
                                            context,
                                            tituloSabores,
                                            tagsSabores,
                                            tituloEspeciales1,
                                            tagsEspeciales1,
                                            tituloEspeciales2,
                                            tagsEspeciales2,
                                            tituloEspeciales3,
                                            tagsEspeciales3,
                                            tituloEspeciales4,
                                            tagsEspeciales4,
                                            tagsVariables,
                                            tituloAcom,
                                            idAcompanhamiento);
                                  }
                                } else {
                                  setState(() {
                                    cant++;
                                    tagsEspeciales4 = val;

                                    utils
                                        .agregarObservacionEnProductoObservacion(
                                            context,
                                            tituloSabores,
                                            tagsSabores,
                                            tituloEspeciales1,
                                            tagsEspeciales1,
                                            tituloEspeciales2,
                                            tagsEspeciales2,
                                            tituloEspeciales3,
                                            tagsEspeciales3,
                                            tituloEspeciales4,
                                            tagsEspeciales4,
                                            tagsVariables,
                                            tituloAcom,
                                            idAcompanhamiento);
                                  });
                                }
                              },
                              choiceItems: C2Choice.listFrom<String, String>(
                                source: snapshot.data[0].fijas[0]
                                    .especialesD[index].nombrecitos,
                                value: (i, v) => v,
                                label: (i, v) => v,
                                tooltip: (i, v) => v,
                              ),
                              wrapped: true,
                            ),
                          );
                        },
                      ),

                      (optionsProductosVariables.length > 0)
                          ? Content(
                              title:
                                  'Cremas a elección (máximo ${optionsProductosVariables.length} opciones)',
                              child: ChipsChoice<String>.multiple(
                                value: tagsVariables,
                                onChanged: (val) => setState(() {
                                  cant++;
                                  tagsVariables = val;

                                  utils.agregarObservacionEnProductoObservacion(
                                      context,
                                      tituloSabores,
                                      tagsSabores,
                                      tituloEspeciales1,
                                      tagsEspeciales1,
                                      tituloEspeciales2,
                                      tagsEspeciales2,
                                      tituloEspeciales3,
                                      tagsEspeciales3,
                                      tituloEspeciales4,
                                      tagsEspeciales4,
                                      tagsVariables,
                                      tituloAcom,
                                      idAcompanhamiento);
                                }),
                                choiceItems: C2Choice.listFrom<String, String>(
                                  source: optionsProductosVariables,
                                  value: (i, v) => v,
                                  label: (i, v) => v,
                                  tooltip: (i, v) => v,
                                ),
                                wrapped: true,
                              ),
                            )
                          : Container(),
                      SizedBox(
                        height: responsive.hp(1),
                      ),

                      StreamBuilder(
                        stream: adicionalesBloc.adicionalesStream,
                        builder: (BuildContext context,
                            AsyncSnapshot<List<ItemAdicional>> snapshot) {
                          if (snapshot.hasData) {
                            if (snapshot.data.length > 0) {
                              return ListView.builder(
                                itemCount: snapshot.data.length,
                                shrinkWrap: true,
                                physics: ClampingScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return AdicionalesItem(
                                    lista: snapshot.data[index].lista,
                                    item: snapshot.data[index].item,
                                    nombreProductoPrincipal: nombredeProducto,
                                  );
                                },
                              );
                            } else {
                              return Container();
                            }
                          } else {
                            return Container();
                          }
                        },
                      ),

                      SizedBox(
                        height: responsive.hp(7),
                      )
                    ]);
                  } else {
                    return Center(
                      child: Text('sin datos'),
                    );
                  }
                } else {
                  return Center(
                    child: CupertinoActivityIndicator(),
                  );
                }
              }),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Padding(
              padding: EdgeInsets.all(
                responsive.wp(6),
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                ),
                width: double.infinity,
                height: responsive.hp(5),
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                    side: BorderSide(color: Colors.red),
                  ),
                  color: Colors.red,
                  textColor: Colors.white,
                  child: Text(
                    'Agregar Producto',
                    style: TextStyle(
                      fontSize: responsive.ip(2),
                    ),
                  ),
                  onPressed: () async {
                    bool pasoSabores = false;
                    bool pasoEspeciales1 = false;
                    bool pasoEspeciales2 = false;
                    bool pasoEspeciales3 = false;
                    bool pasoEspeciales4 = false;

                    bool pasoAcom = false;

                    if (sabores) {
                      if (tagsSabores.length >= maximoSabores) {
                        pasoSabores = true;
                      } else {
                        pasoSabores = false;
                      }
                    } else {
                      pasoSabores = true;
                    }

                    if (especiales1) {
                      if (tagsEspeciales1.length >= maximoespeciales1) {
                        pasoEspeciales1 = true;
                      } else {
                        pasoEspeciales1 = false;
                      }
                    } else {
                      pasoEspeciales1 = true;
                    }

                    if (especiales2) {
                      if (tagsEspeciales2.length >= maximoespeciales2) {
                        pasoEspeciales2 = true;
                      } else {
                        pasoEspeciales2 = false;
                      }
                    } else {
                      pasoEspeciales2 = true;
                    }

                    if (especiales3) {
                      if (tagsEspeciales3.length >= maximoespeciales3) {
                        pasoEspeciales3 = true;
                      } else {
                        pasoEspeciales3 = false;
                      }
                    } else {
                      pasoEspeciales3 = true;
                    }

                    if (especiales4) {
                      if (tagsEspeciales4.length >= maximoespeciales4) {
                        pasoEspeciales4 = true;
                      } else {
                        pasoEspeciales4 = false;
                      }
                    } else {
                      pasoEspeciales4 = true;
                    }

                    if (acompanhamientosBoolVariable) {
                      if (tagAcompanhamientos != null) {
                        pasoAcom = true;
                      } else {
                        pasoAcom = false;
                      }
                    } else {
                      pasoAcom = true;
                    }

                    if (pasoSabores) {
                      if (pasoAcom) {
                        if (pasoEspeciales1) {
                          if (pasoEspeciales2) {
                            if (pasoEspeciales3) {
                              if (pasoEspeciales4) {
                                utils.agregarProductosAlCarrito(context);

                                Navigator.pop(context);
                              } else {
                                utils.showToast(
                                    'debe elegir como mínimo $maximoespeciales4 $tituloEspeciales4',
                                    2,
                                    ToastGravity.TOP);
                              }
                            } else {
                              utils.showToast(
                                  'debe elegir como mínimo $maximoespeciales3 $tituloEspeciales3',
                                  2,
                                  ToastGravity.TOP);
                            }
                          } else {
                            utils.showToast(
                                'debe elegir como mínimo $maximoespeciales2 $tituloEspeciales2',
                                2,
                                ToastGravity.TOP);
                          }
                        } else {
                          utils.showToast(
                              'debe elegir como mínimo $maximoespeciales1 $tituloEspeciales1',
                              2,
                              ToastGravity.TOP);
                        }
                      } else {
                        utils.showToast('debe elegir como mínimo 1 $tituloAcom',
                            2, ToastGravity.TOP);
                      }
                    } else {
                      utils.showToast(
                          'debe elegir como mínimo $maximoSabores $tituloSabores',
                          2,
                          ToastGravity.TOP);
                    }
                  },
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class AdicionalesItem extends StatelessWidget {
  final List<AdicionalesModel> lista;
  final String item;
  final String nombreProductoPrincipal;

  const AdicionalesItem({
    Key key,
    @required this.lista,
    @required this.item,
    @required this.nombreProductoPrincipal,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      itemCount: lista.length + 1,
      itemBuilder: (context, i) {
        if (i == 0) {
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.all(15),
            color: Colors.blueGrey[50],
            child: Text(
              lista[0].titulo,
              style: const TextStyle(
                  color: Colors.blueGrey, fontWeight: FontWeight.w500),
            ),
          );
        }

        int index = i - 1;
        return new CheckboxListTile(
          title: new RichText(
            text: TextSpan(children: [
              TextSpan(
                text: '${lista[index].adicionalesNombre}   ',
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
              ),
              TextSpan(
                text: 'S/.${lista[index].adicionalesPrecio}',
                style:
                    TextStyle(color: Colors.red, fontWeight: FontWeight.w600),
              ),
            ]),
          ),
          value:
              ('${lista[index].adicionalSeleccionado}' == '0') ? false : true,
          onChanged: (bool value) {
            print('${lista[index].adicionalesNombre}');
            print('ctm $value');
            utils.cambiarEstadoSeleccionAdicional(
              context,
              '${lista[index].idProducto}',
              value,
              '${lista[index].idProductoAdicional}',
              item,
            );

            utils.agregarItemObservacion(
                context,
                '${lista[index].idProductoAdicional}',
                value,
                'adicional',
                'adicional de $nombreProductoPrincipal');
          },
        );
      },
    );
  }
}
