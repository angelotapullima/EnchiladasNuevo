import 'dart:typed_data';
import 'dart:ui';

import 'package:animate_do/animate_do.dart';
import 'package:enchiladasapp/src/bloc/provider.dart';
import 'package:enchiladasapp/src/models/carrito_model.dart';
import 'package:enchiladasapp/src/models/productos._model.dart';
import 'package:enchiladasapp/src/models/validar_producto.dart';
import 'package:enchiladasapp/src/utils/responsive.dart';
import 'package:enchiladasapp/src/utils/translate_animation.dart';
import 'package:enchiladasapp/src/utils/utilidades.dart' as utils;
import 'package:enchiladasapp/src/widgets/cantidad_producto.dart';
import 'package:enchiladasapp/src/utils/preferencias_usuario.dart';
import 'package:enchiladasapp/src/widgets/customCacheManager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:cached_network_image/cached_network_image.dart';

class DetalleProductitos extends StatefulWidget {
  final ProductosData productosData;

  const DetalleProductitos({Key key, this.productosData}) : super(key: key);
  @override
  _DetalleProducto createState() => _DetalleProducto();
}

class _DetalleProducto extends State<DetalleProductitos> {
  GlobalKey _one = GlobalKey();
  GlobalKey _two = GlobalKey();
  GlobalKey _three = GlobalKey();

  bool estadoDelivery = false;
  double _panelHeightOpen;

  TextEditingController observacionProducto = TextEditingController();
  PanelController panelController = new PanelController();

  @override
  void dispose() {
    // Limpia el controlador cuando el Widget se descarte
    observacionProducto.dispose();
    super.dispose();
  }

  void llamado() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final preferences = Preferences();
    _panelHeightOpen = MediaQuery.of(context).size.height * .80;
    //final ProductosData productos = ModalRoute.of(context).settings.arguments;
    final responsive = Responsive.of(context);
    final productosIdBloc = ProviderBloc.prod(context);

    productosIdBloc.obtenerProductoPorId(widget.productosData.idProducto);
    productosIdBloc.verificarDisponibilidad(widget.productosData.idCategoria);

    return ShowCaseWidget(
      onFinish: () {
        preferences.pantallaDProducto = '1';
      },
      autoPlay: false,
      autoPlayDelay: Duration(seconds: 3),
      autoPlayLockEnable: true,
      builder: Builder(builder: (context) {
        Future.delayed(Duration(milliseconds: 700)).then((value) {
          if (preferences.pantallaDProducto != "1") {
            WidgetsBinding.instance.addPostFrameCallback((_) =>
                ShowCaseWidget.of(context).startShowCase([_one, _two, _three]));
          }
        });

        return Material(
          child: StreamBuilder(
            stream: productosIdBloc.productosIdStream,
            initialData: [],
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data.length > 0) {
                  return SlidingUpPanel(
                    maxHeight: _panelHeightOpen,
                    minHeight: responsive.hp(7),
                    controller: panelController,
                    parallaxEnabled: true,
                    parallaxOffset: 0.1,
                    backdropEnabled: true,
                    body: Stack(children: <Widget>[
                      _backgroundImage(context, snapshot.data[0]),
                      _crearAppbar(responsive),
                      TranslateAnimation(
                        duration: const Duration(milliseconds: 400),
                        child: _contenido(snapshot.data[0], responsive, context,
                            productosIdBloc),
                      ),
                    ]),
                    panelBuilder: (sc) {
                      return Showcase(
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: responsive.wp(40)),
                        key: _three,
                        description:
                            'puedes presionar o deslizar hacia arriba para ver más detalles y hacer tu pedido',
                        child: TranslateAnimation(
                          duration: const Duration(milliseconds: 600),
                          child: _carritoProductos(responsive, sc),
                        ),
                      );
                    },
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                    //onPanelSlide: (double pos) => setState(() {}),
                  );
                } else {
                  return Center(
                    child: CupertinoActivityIndicator(),
                  );
                }
              } else {
                return Center(
                  child: CupertinoActivityIndicator(),
                );
              }
            },
          ),
        );
      }),
    );
  }

  Widget botonesBajos(Responsive responsive, ProductosData productosData,
      ProductosBloc productosBloc) {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: responsive.hp(1),
      ),
      height: responsive.hp(7),
      width: double.infinity,
      child: Row(
        children: <Widget>[
          Showcase(
            key: _one,
            description: 'presione para agregar añadir a favoritos',
            child: Container(
              width: responsive.wp(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.red),
              ),
              child: Center(
                child: (productosData.productoFavorito == 1)
                    ? IconButton(
                        onPressed: () {
                          setState(() {
                            print('quitar');
                            utils.quitarFavoritos(context, productosData);
                          });
                        },
                        icon: Icon(
                          FontAwesomeIcons.solidHeart, 
                          color: Colors.red,
                          size: responsive.ip(2.5),
                        ),
                      )
                    : IconButton(
                        onPressed: () {
                          setState(() {
                            print('agregar');
                            utils.agregarFavoritos(context, productosData);
                          });
                        },
                        icon: Icon(
                          FontAwesomeIcons.heart,
                          color: Colors.red,
                          size: responsive.ip(2.5),
                        ),
                      ),
              ),
            ),
          ),
          SizedBox(
            width: responsive.wp(5),
          ),
          StreamBuilder(
              stream: productosBloc.categoriaTemporizador,
              builder: (context, AsyncSnapshot<ValidarProducto> snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data.valor) {
                    return Showcase(
                      key: _two,
                      description: 'presione para agregar producto al carrito',
                      child: GestureDetector(
                        child: Container(
                          width: responsive.wp(65),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.red,
                            border: Border.all(color: Colors.red),
                          ),
                          child: Center(
                            child: Text(
                              'Agregar al Carrito',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: responsive.ip(2.5),
                              ),
                            ),
                          ),
                        ),
                        onTap: () {
                          utils.agregarCarrito(productosData, context, "1");
                        },
                      ),
                    );
                  } else {
                    return GestureDetector(
                      child: Container(
                        width: responsive.wp(65),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.grey,
                          border: Border.all(color: Colors.grey),
                        ),
                        child: Center(
                          child: Text(
                            'Agregar al Carrito',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: responsive.ip(2.5),
                            ),
                          ),
                        ),
                      ),
                      onTap: () {
                        utils.showToast(
                            '${snapshot.data.mensaje}', 2, ToastGravity.TOP);
                        //utils.agregarCarrito(productosData, context, "1");
                      },
                    );
                  }
                } else {
                  return GestureDetector(
                    child: Container(
                      width: responsive.wp(65),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.grey,
                        border: Border.all(color: Colors.grey),
                      ),
                      child: Center(
                        child: Text(
                          'Agregar al Carrito',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: responsive.ip(2.5),
                          ),
                        ),
                      ),
                    ),
                    onTap: () {
                      utils.showToast(
                          'En estos momentos el producto esta deshabilitado',
                          2,
                          ToastGravity.TOP);
                      //utils.agregarCarrito(productosData, context, "1");
                    },
                  );
                }
              })
        ],
      ),
    );
  }

  Widget _contenido(ProductosData productosData, Responsive responsive,
      BuildContext context, ProductosBloc productosBloc) {
    final precioProdcuto = utils.format(
      double.parse(productosData.productoPrecio),
    );
    return Container(
      margin: EdgeInsets.only(
        top: responsive.hp(25),
      ),
      child: DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.7,
        builder: (context, controller) {
          return Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadiusDirectional.circular(20),
                color: Colors.white),
            padding: EdgeInsets.symmetric(
              horizontal: responsive.wp(5),
            ),
            child: SingleChildScrollView(
              controller: controller,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: responsive.hp(3),
                  ),
                  Row(
                    children: <Widget>[
                      Flexible(
                        child: Text(
                          productosData.productoNombre,
                          style: TextStyle(
                              fontSize: responsive.ip(3),
                              fontWeight: FontWeight.w600),
                          textAlign: TextAlign.start,
                        ),
                      ),
                      SizedBox(
                        width: responsive.wp(3),
                      ),
                      Text(
                        'S/ $precioProdcuto',
                        style: TextStyle(
                            color: Colors.red,
                            fontSize: responsive.ip(4),
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  SizedBox(
                    height: responsive.hp(3),
                  ),
                  botonesBajos(responsive, productosData, productosBloc),
                  //_cantidad(responsive),
                  SizedBox(
                    height: responsive.hp(3),
                  ),

                  Text(
                    '${productosData.productoDescripcion}',
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      fontSize: responsive.ip(2),
                    ),
                  ),

                  SizedBox(
                    height: responsive.hp(3),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _carritoProductos(Responsive responsive, ScrollController sc) {
    final carritoBloc = ProviderBloc.carrito(context);
    carritoBloc.obtenerCarrito();

    return StreamBuilder(
      stream: carritoBloc.carritoIdStream,
      builder: (BuildContext context, AsyncSnapshot<List<Carrito>> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.length > 0) {
            return _contenidoDeCarrito(responsive, snapshot.data, sc);
          } else {
            return Column(children: <Widget>[
              GestureDetector(
                onTap: () {
                  //setState(() {
                  if (panelController.isPanelOpen) {
                    panelController.animatePanelToPosition(0);
                  } else {
                    panelController.animatePanelToPosition(1);
                  }
                  //});
                },
                child: panelRojoMonto(responsive, 0.00, '0'),
              ),
              SizedBox(
                height: responsive.hp(3),
              ),
              Container(
                height: responsive.hp(30),
                child: Padding(
                  padding: EdgeInsets.only(
                    left: responsive.wp(10),
                  ),
                  child: SvgPicture.asset('assets/carrito.svg'),
                ),
              ),
              SizedBox(
                height: responsive.hp(3),
              ),
              Text(
                'No hay Productos en el carrito',
                style: TextStyle(color: Colors.black, fontSize: 22),
              )
            ]);
          }
        } else {
          return Center(
            child: SvgPicture.asset('assets/carrito.svg'),
          );
        }
      },
    );
  }

  Widget panelRojoMonto(
      Responsive responsive, double total, String cantidadPedidos) {
    String montoFinalex = utils.format(total);
    return Container(
      height: responsive.hp(8),
      padding: EdgeInsets.symmetric(
        horizontal: responsive.wp(5),
        vertical: responsive.hp(1),
      ),
      decoration: BoxDecoration(
          borderRadius: BorderRadiusDirectional.only(
            topEnd: Radius.circular(20),
            topStart: Radius.circular(20),
          ),
          color: Colors.red),
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(
              top: responsive.hp(.4),
            ),
            child: Container(
              height: responsive.hp(.6),
              width: responsive.wp(18),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
              ),
            ),
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  'Monto S/$montoFinalex',
                  style: TextStyle(
                      color: Colors.white, fontSize: responsive.ip(3)),
                ),
              ),
              Stack(children: <Widget>[
                Icon(
                  Icons.shopping_cart,
                  size: responsive.ip(4),
                  color: Colors.white,
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: BounceInDown(
                    from: 10,
                    child: Container(
                      child: Text(
                        '$cantidadPedidos',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: responsive.ip(1.5),
                        ),
                      ),
                      alignment: Alignment.center,
                      width: responsive.ip(1.8),
                      height: responsive.ip(1.8),
                      decoration: BoxDecoration(
                          color: Colors.green, shape: BoxShape.circle),
                    ),
                  ),
                )
              ]),
            ],
          ),
        ],
      ),
    );
  }

  Widget _contenidoDeCarrito(
      Responsive responsive, List<Carrito> carrito, ScrollController sc) {
    double subtotal = 0;
    double total = 0;
    double valorDelivery = 0;
    int cant = 0;
    for (int i = 0; i < carrito.length; i++) {
      if (carrito[i].productoTipo != '1') {
        subtotal = subtotal +
            (double.parse(carrito[i].productoPrecio) *
                double.parse(carrito[i].productoCantidad));
      } else {
        estadoDelivery = true;
        valorDelivery = double.parse(carrito[i].productoPrecio);
      }
      /* subtotal = subtotal +
          (double.parse(carrito[i].productoPrecio) *
              double.parse(carrito[i].productoCantidad)); */
      cant++;
    }

    total = subtotal + valorDelivery;
    return Column(
      children: <Widget>[
        GestureDetector(
          onTap: () {
            /* setState(
              () { */
            if (panelController.isPanelOpen) {
              panelController.animatePanelToPosition(0);
            } else {
              panelController.animatePanelToPosition(1);
            }
            /* },
            ); */
          },
          child: panelRojoMonto(
            responsive,
            total,
            cant.toString(),
          ),
        ),
        Expanded(
          child: ListView(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            children: <Widget>[
              _resumenPedido(responsive, subtotal, valorDelivery),
              _pagarCarrito(context, responsive),
              _listaProductos(responsive, carrito),
            ],
          ),
        )
      ],
    );
  }

  Widget _listaProductos(Responsive responsive, List<Carrito> carrito) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      padding: EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(blurRadius: 3, color: Colors.black26),
        ],
        border: Border.all(color: Colors.white),
        borderRadius: BorderRadius.circular(13),
      ),
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        physics: ScrollPhysics(),
        itemCount: carrito.length + 1,
        itemBuilder: (context, i) {
          if (i == 0) {
            return Padding(
              padding: EdgeInsets.only(
                top: responsive.hp(1.2),
                left: responsive.wp(2),
                right: responsive.wp(2),
              ),
              child: Text(
                'Productos',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: responsive.ip(2.8),
                ),
              ),
            );
          }
          final index = i - 1;
          return _itemPedido(
            responsive,
            carrito[index],
          );
        },
      ),
    );
  }

  Widget _itemPedido(Responsive responsive, Carrito carrito) {
    print('detalle ${carrito.productoFoto}');
    final preciofinal = utils.format(double.parse(carrito.productoPrecio) *
        double.parse(carrito.productoCantidad));
    var observacionProducto = 'Toca para agregar una observación';
    if (carrito.productoObservacion != null &&
        carrito.productoObservacion != ' ') {
      observacionProducto = carrito.productoObservacion;
    }

    return Container(
      padding: EdgeInsets.symmetric(
        vertical: responsive.hp(1),
      ),
      child: (carrito.productoTipo != '1')
          ? Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Container(
                      width: responsive.wp(35),
                      height: responsive.hp(12),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: CachedNetworkImage(
                          cacheManager: CustomCacheManager(),
                          placeholder: (context, url) => Image(
                              image: AssetImage('assets/jar-loading.gif'),
                              fit: BoxFit.cover),
                          errorWidget: (context, url, error) => Image(
                  image: AssetImage('assets/carga_fallida.jpg'),
                  fit: BoxFit.cover),
                          imageUrl: '${carrito.productoFoto}',
                          imageBuilder: (context, imageProvider) => Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.cover,
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
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            carrito.productoNombre,
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: responsive.ip(1.8),
                            ),
                          ),
                          Text(
                            '$preciofinal',
                            style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                              fontSize: responsive.ip(2),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      child: Column(
                        //crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          IconButton(
                            icon: Icon(
                              Icons.delete_outline,
                              size: responsive.ip(3),
                            ),
                            onPressed: () {
                              utils.deleteProductoCarrito(
                                  context, carrito.idProducto);
                            },
                          ),
                          Container(
                            child: CantidadTab(
                                carrito: carrito, llamada: this.llamado),
                          )
                        ],
                      ),
                    )
                  ],
                ),
                GestureDetector(
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.mode_edit,
                        color: Colors.red,
                      ),
                      Expanded(child: Text('$observacionProducto'))
                    ],
                  ),
                  onTap: () {
                    dialogoObservacionProducto('${carrito.idProducto}');
                  },
                )
              ],
            )
          : Container(),
    );
  }

  Widget _resumenPedido(
      Responsive responsive, double subtotal, double valorDelivery) {
    final subtotal2 = utils.format(subtotal);
    final valorDelivery2 = utils.format(valorDelivery);
    final totalex = utils.format(subtotal + valorDelivery);
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: responsive.wp(2),
      ),
      child: Container(
          decoration: BoxDecoration(
            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 3)],
            color: Colors.white,
            border: Border.all(color: Colors.white),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Padding(
            padding: EdgeInsets.all(
              responsive.wp(2),
            ),
            child: Column(children: [
              Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      'Sub Total ',
                      style: TextStyle(
                        fontSize: responsive.ip(2),
                      ),
                    ),
                  ),
                  Text(
                    'S/ $subtotal2',
                    style: TextStyle(
                      fontSize: responsive.ip(2),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: responsive.hp(2),
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      'Entrega rápida',
                      style: TextStyle(
                        fontSize: responsive.ip(2),
                      ),
                    ),
                  ),
                  Text(
                    'S/ $valorDelivery2',
                    style: TextStyle(
                      fontSize: responsive.ip(2),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: responsive.hp(2),
              ),
              Divider(),
              Row(
                children: <Widget>[
                  Expanded(
                      child: Text(
                    'Total a pagar',
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: responsive.ip(2.2),
                    ),
                  )),
                  Text(
                    'S/ $totalex',
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: responsive.ip(2.2),
                    ),
                  )
                ],
              ),
            ]),
          )),
    );
  }

  Widget _pagarCarrito(BuildContext context, Responsive responsive) {
    final preferences = Preferences();
    return GestureDetector(
      child: Padding(
        padding: EdgeInsets.all(
          responsive.wp(2),
        ),
        child: Container(
          width: double.infinity,
          child: Column(
            children: <Widget>[
              SizedBox(
                width: double.infinity,
                child: RaisedButton(
                    color: (preferences.rol == '5') ? Colors.red : Colors.grey,
                    textColor: Colors.white,
                    child: Text(
                      'Ordenar Pedido',
                      style: TextStyle(
                        fontSize: responsive.ip(2),
                      ),
                    ),
                    onPressed: () {
                      if (preferences.rol == '5') {
                        final prefs = Preferences();

                        if (prefs.email != null && prefs.email != "") {
                          Navigator.pushNamed(context, 'detallePago');
                        } else {
                          pedirLogueo();
                        }
                        utils.showToast(
                            'No tiene permisos', 2, ToastGravity.TOP);
                      }else{
                        utils.showToast(
                            'Debe iniciar sesión para poder ordenar un pedido', 2, ToastGravity.TOP);
                      }
                    }),
              ),
            ],
          ),
        ),
      ),
      onTap: () {
        final prefs = Preferences();

        if (prefs.email != null && prefs.email != "") {
          Navigator.pushNamed(context, 'detallePago');
        } else {
          pedirLogueo();
        }
      },
    );
  }

  void pedirLogueo() {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (contextd) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            title: Text('Debe registrarse para Ordenar'),
            actions: <Widget>[
              FlatButton(
                onPressed: () async {
                  Navigator.pop(context);
                },
                child: Text('Cancelar'),
              ),
              FlatButton(
                onPressed: () async {
                  Navigator.pop(context);
                  Navigator.pushNamedAndRemoveUntil(
                      context, 'login', (route) => false);
                },
                child: Text('Continuar'),
              ),
            ],
          );
        });
  }

  Widget _crearAppbar(Responsive responsive) {
    return Container(
      height: kToolbarHeight+30,
      child: AppBar(
        leading: BackButton(color: Colors.white,),
        backgroundColor: Colors.transparent,
      ),
    );
  }
  //flutter build apk -- release gliutter buils apk -- releadse

  Widget _backgroundImage(BuildContext context, ProductosData carrito) {
    final size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, 'detalleProductoFoto', arguments: carrito);
      },
      child: Container(
        width: double.infinity,
        height: size.height * 0.50,
        child: Hero(
          tag: '${carrito.idProducto}',
          child: ClipRRect(
            child: CachedNetworkImage(
              cacheManager: CustomCacheManager(),
              placeholder: (context, url) => Image(
                  image: AssetImage('assets/jar-loading.gif'),
                  fit: BoxFit.cover),
              errorWidget: (context, url, error) => Image(
                  image: AssetImage('assets/carga_fallida.jpg'),
                  fit: BoxFit.cover),
              imageUrl: '${carrito.productoFoto}',
              imageBuilder: (context, imageProvider) => Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void dialogoObservacionProducto(String id) {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (contextd) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            title: Text('Ingrese la observación del producto'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
                  controller: observacionProducto,
                ),
                //Text('Producto agregado al carrito correctamente'),
                SizedBox(
                  height: 20.0,
                ),
              ],
            ),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancelar')),
              FlatButton(
                  onPressed: () async {
                    utils.actualizarObservacion(
                        context, observacionProducto.text, id);

                    observacionProducto.text = '';

                    Navigator.pop(context);
                  },
                  child: Text('Aceptar')),
            ],
          );
        });
  }
}
