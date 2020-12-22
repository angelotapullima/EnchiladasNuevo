import 'package:cached_network_image/cached_network_image.dart';
import 'package:chips_choice/chips_choice.dart';
import 'package:enchiladasapp/src/bloc/provider.dart';
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
  const DetalleObservaciones({Key key, @required this.idProductoArgument})
      : super(key: key);

  @override
  _DetalleObservacionesState createState() => _DetalleObservacionesState();
}

class _DetalleObservacionesState extends State<DetalleObservaciones> {
  //productos Fijos
  int tagFijos = 0;
  bool fijos = false;
  String idProductoFijo = 'false';

  //sabores
  List<String> tagsSabores = [];
  bool sabores = false;

  //acompañamiento
  int tagAcompanhamientos;
  bool acompanhamientos = false;
  String idAcompanhamiento = 'false';

  //int tag;

  //variables
  List<String> tagsVariables = [];
  bool variables = false;

  int cant = 0;

  int maximoSabores = 0;

  @override
  Widget build(BuildContext context) {
    final observacionesProductoBloc = ProviderBloc.observaciones(context);
    final adicionalesBloc = ProviderBloc.adicionales(context);
    final itemObservacionBloc = ProviderBloc.itemOb(context);
    if (cant == 0) {
      observacionesProductoBloc.obtenerObservaciones(widget.idProductoArgument);

      adicionalesBloc.obtenerAdicionales();

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
                      fijos = true;
                    }
                    if (optionsProductosVariables.length > 0) {
                      variables = true;
                    }

                    if (snapshot.data[0].fijas[0].sabores.length > 0) {
                      sabores = true;
                      maximoSabores = int.parse(
                          snapshot.data[0].fijas[0].sabores[0].maximo);
                    }

                    if (snapshot.data[0].fijas[0].acompanhamientos.length >=
                        1) {
                      acompanhamientos = true;
                    }

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
                                  return ('${snapshot.data[index].idCategoria}' !=
                                          '16')
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

                                    utils.agregarItemObservacionFijos(
                                        context, idProductoFijo, true);
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
                                      Radius.circular(5)),
                                ),
                                wrapped: true,
                              ),
                            )
                          : Container(),
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

                                if (tagsSabores.length >
                                    int.parse(snapshot.data[0].fijas[0]
                                            .sabores[index].maximo) -
                                        1) {
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

                                  if (paso) {
                                    setState(() {
                                      cant++;
                                      tagsSabores = val;
                                    });

                                    utils
                                        .agregarObservacionEnProductoObservacion(
                                            context,
                                            tagsSabores,
                                            tagsVariables,
                                            idAcompanhamiento);
                                  }
                                } else {
                                  setState(() {
                                    cant++;
                                    tagsSabores = val;

                                    utils
                                        .agregarObservacionEnProductoObservacion(
                                            context,
                                            tagsSabores,
                                            tagsVariables,
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
                                      tagsSabores,
                                      tagsVariables,
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
                                      tagsSabores,
                                      tagsVariables,
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
                      SizedBox(height: responsive.hp(1)),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(15),
                        color: Colors.blueGrey[50],
                        child: Text(
                          'Adicionales',
                          style: const TextStyle(
                              color: Colors.blueGrey,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                      StreamBuilder(
                        stream: adicionalesBloc.adicionalesStream,
                        builder: (BuildContext context,
                            AsyncSnapshot<List<ProductosData>> snapshot) {
                          if (snapshot.hasData) {
                            if (snapshot.data.length > 0) {
                              return ListView.builder(
                                shrinkWrap: true,
                                physics: ClampingScrollPhysics(),
                                itemCount: snapshot.data.length,
                                itemBuilder: (context, index) {
                                  return new CheckboxListTile(
                                    title: new RichText(
                                      text: TextSpan(children: [
                                        TextSpan(
                                          text:
                                              '${snapshot.data[index].productoNombre}   ',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        TextSpan(
                                          text:
                                              'S/.${snapshot.data[index].productoPrecio}',
                                          style: TextStyle(
                                              color: Colors.red,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ]),
                                    ),
                                    value:
                                        ('${snapshot.data[index].productoSeleccionado}' ==
                                                '0')
                                            ? false
                                            : true,
                                    onChanged: (bool value) {
                                      utils.cambiarEstadoSeleccionAdicional(
                                          context,
                                          '${snapshot.data[index].idProducto}',
                                          value);

                                      utils.agregarItemObservacion(
                                          context,
                                          '${snapshot.data[index].idProducto}',
                                          value);
                                    },
                                  );
                                },
                              );
                            } else {
                              return Center(
                                  child: Text(' No existen Adicionales'));
                            }
                          } else {
                            return Center(
                              child: CupertinoActivityIndicator(),
                            );
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
                    bool pasoSabores = false, pasoAcom = false;

                    if (sabores) {
                      if (tagsSabores.length >= maximoSabores) {
                        pasoSabores = true;
                      } else {
                        pasoSabores = false;
                      }
                    } else {
                      pasoSabores = true;
                    }

                    if (acompanhamientos) {
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
                        utils.agregarProductosAlCarrito(context);

                        Navigator.pop(context);
                      } else {
                        utils.showToast(
                            'debe elegir como mínimo 1 acompañamiento',
                            2,
                            ToastGravity.TOP);
                      }
                    } else {
                      utils.showToast(
                          'debe elegir como mínimo $maximoSabores sabores',
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
