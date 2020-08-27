import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:enchiladasapp/src/bloc/provider.dart';
import 'package:enchiladasapp/src/models/carrito_model.dart';
import 'package:enchiladasapp/src/models/productos._model.dart';
import 'package:enchiladasapp/src/utils/responsive.dart';
import 'package:enchiladasapp/src/widgets/cantidad_producto.dart';
import 'package:enchiladasapp/src/widgets/preferencias_usuario.dart';
import 'package:enchiladasapp/src/widgets/zona_direction.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:enchiladasapp/src/utils/utilidades.dart' as utils;

class DetalleProductos extends StatefulWidget {
  const DetalleProductos({Key key}) : super(key: key);

  @override
  _DetalleProductitosState createState() => _DetalleProductitosState();
}

class _DetalleProductitosState extends State<DetalleProductos> {
  bool estadoDelivery = false;
  TextEditingController observacionProducto = TextEditingController();

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
  Widget build(BuildContext context) {
    final ProductosData productos = ModalRoute.of(context).settings.arguments;
    final responsive = Responsive.of(context);
    final productosIdBloc = ProviderBloc.prod(context);

    productosIdBloc.obtenerProductoPorId(productos.idProducto);

    return Scaffold(
      body: StreamBuilder(
        stream: productosIdBloc.productosIdStream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.length > 0) {
              return Stack(
                children: <Widget>[
                  _background(),
                  _backgroundImage(
                    context,
                    snapshot.data[0],
                  ),
                  _crearAppbar(responsive),
                  _contenido(snapshot.data[0], responsive, context),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: _botonesMonto(responsive, context),
                  ),
                ],
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
  }

  Widget botonesBajos(Responsive responsive, ProductosData productosData) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: responsive.hp(1)),
      height: responsive.hp(7),
      width: double.infinity,
      child: Row(
        children: <Widget>[
          Container(
            width: responsive.wp(20),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.red)),
            child: Center(
              child: (productosData.productoFavorito == 1)
                  ? IconButton(
                      onPressed: () {
                        setState(
                          () {
                            print('quitar');
                            utils.quitarFavoritos(context, productosData);
                          },
                        );
                      },
                      icon: Icon(FontAwesomeIcons.solidHeart,
                          color: Colors.red, size: responsive.ip(2.5)),
                    )
                  : IconButton(
                      onPressed: () {
                        setState(
                          () {
                            print('agregar');
                            utils.agregarFavoritos(context, productosData);
                          },
                        );
                      },
                      icon: Icon(
                        FontAwesomeIcons.heart,
                        color: Colors.red,
                        size: responsive.ip(2.5),
                      ),
                    ),
            ),
          ),
          SizedBox(
            width: responsive.wp(5),
          ),
          GestureDetector(
            child: Container(
              width: responsive.wp(65),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.red,
                  border: Border.all(color: Colors.red)),
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
          )
        ],
      ),
    );
  }

  Widget _contenido(ProductosData productosData, Responsive responsive,
      BuildContext context) {
    final precioProdcuto =
        utils.format(double.parse(productosData.productoPrecio));
    return Padding(
      padding: EdgeInsets.only(top: responsive.hp(11)),
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
                        width: responsive.wp(6),
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
                  botonesBajos(responsive, productosData),
                  //_cantidad(responsive),
                  SizedBox(
                    height: responsive.hp(3),
                  ),
                  Text(
                    '${productosData.productoDescripcion}',
                    textAlign: TextAlign.justify,
                    style: TextStyle(fontSize: responsive.ip(2)),
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

  Widget _crearAppbar(Responsive responsive) {
    return Container(
      height: responsive.hp(9),
      child: AppBar(
        backgroundColor: Colors.transparent,
      ),
    );
  }

  Widget _background() {
    return Container(
      color: Colors.red,
      width: double.infinity,
      height: double.infinity,
    );
  }

  Widget _backgroundImage(BuildContext context, ProductosData carrito) {
    final size = MediaQuery.of(context).size;
    

    return SafeArea(
      child: Column(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            width: double.infinity,
            height: size.height * 0.38,
            child: Hero(
              tag: '${carrito.idProducto}',
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20)),
                child: CachedNetworkImage(
                  cacheManager: CustomCacheManager(),
                  placeholder: (context, url) => Image(
                      image: AssetImage('assets/jar-loading.gif'),
                      fit: BoxFit.cover),
                  errorWidget: (context, url, error) => Icon(Icons.error),
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
          Expanded(
            child: Container(
              color: Colors.white,
            ),
          )
        ],
      ),
    );
  }

  Widget _botonesMonto(Responsive responsive, BuildContext context) {
    final responsive = Responsive.of(context);
    final carritoBloc = ProviderBloc.carrito(context);
    carritoBloc.obtenerCarrito();

    return StreamBuilder(
      stream: carritoBloc.carritoIdStream,
      builder: (BuildContext context, AsyncSnapshot<List<Carrito>> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.length > 0) {
            double subtotal = 0;
            double total = 0;
            double valorDelivery = 0;
            int cant = 0;
            for (int i = 0; i < snapshot.data.length; i++) {
              if (snapshot.data[i].productoTipo != '1') {
                subtotal = subtotal +
                    (double.parse(snapshot.data[i].productoPrecio) *
                        double.parse(snapshot.data[i].productoCantidad));
              } else {
                estadoDelivery = true;
                valorDelivery = double.parse(snapshot.data[i].productoPrecio);
              }
              cant++;
            }

            total = subtotal + valorDelivery;
            return GestureDetector(
              child: Container(
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
                            'Monto S/ $total',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: responsive.ip(2.8),
                            ),
                          ),
                        ),
                        Stack(
                          children: <Widget>[
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
                                    '$cant',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: responsive.ip(1.5),
                                    ),
                                  ),
                                  alignment: Alignment.center,
                                  width: responsive.ip(1.9),
                                  height: responsive.ip(1.9),
                                  decoration: BoxDecoration(
                                      color: Colors.green,
                                      shape: BoxShape.circle),
                                ),
                              ),
                              //child: Icon(Icons.brightness_1, size: 8,color: Colors.redAccent,  )
                            )
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ),
              onTap: () {
                _settingModalBottomSheet(context, carritoBloc, responsive);
              },
            );
          } else {
            return GestureDetector(
              onTap: () {
                _settingModalBottomSheet(context, carritoBloc, responsive);
              },
              child: Container(
                height: responsive.hp(8),
                padding: EdgeInsets.symmetric(
                  horizontal: responsive.wp(5),
                  //vertical: responsive.hp(1.5),
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
                        top: responsive.hp(1),
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
                            'Monto S/0.00',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: responsive.ip(2.8),
                            ),
                          ),
                        ),
                        Stack(
                          children: <Widget>[
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
                                    '0',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: responsive.ip(1.5),
                                    ),
                                  ),
                                  alignment: Alignment.center,
                                  width: responsive.ip(1.8),
                                  height: responsive.ip(1.8),
                                  decoration: BoxDecoration(
                                      color: Colors.green,
                                      shape: BoxShape.circle),
                                ),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ),
            );
          }
        } else {
          return Container();
        }
      },
    );
  }

  void _settingModalBottomSheet(
      context, CarritoBloc carritoBloc, Responsive responsive) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return StreamBuilder(
          stream: carritoBloc.carritoIdStream,
          builder:
              (BuildContext context, AsyncSnapshot<List<Carrito>> snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data.length > 0) {
                return Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadiusDirectional.only(
                          topEnd: Radius.circular(20),
                          topStart: Radius.circular(20),
                        ),
                        color: Colors.white),
                    child: _contenidoDeCarrito(responsive, snapshot.data));
              } else {
                return Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadiusDirectional.only(
                        topEnd: Radius.circular(20),
                        topStart: Radius.circular(20),
                      ),
                      color: Colors.white),
                  child: Column(
                    children: <Widget>[
                      Container(
                        height: responsive.hp(30),
                        child: Padding(
                          padding: EdgeInsets.only(
                            left: responsive.wp(10),
                            top: responsive.wp(5),
                          ),
                          child: SvgPicture.asset('assets/carrito.svg'),
                        ),
                      ),
                      SizedBox(
                        height: responsive.hp(3),
                      ),
                      Text(
                        'No hay Productos en el carrito',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: responsive.ip(2.8),
                        ),
                      )
                    ],
                  ),
                );
              }
            } else {
              return Container();
            }
          },
        );
      },
    );
  }

  Widget _contenidoDeCarrito(Responsive responsive, List<Carrito> carrito) {
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
      cant++;
    }

    total = subtotal + valorDelivery;
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: responsive.wp(5),
            vertical: responsive.hp(2),
          ),
          decoration: BoxDecoration(
              borderRadius: BorderRadiusDirectional.only(
                  topEnd: Radius.circular(20), topStart: Radius.circular(20),),
              color: Colors.red),
          child: Row(
            children: <Widget>[
              Expanded(
                  child: Text(
                'Monto S/ $total',
                style: TextStyle(
                    color: Colors.white, fontSize: responsive.ip(2.8),),
              )),
              Stack(
                children: <Widget>[
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
                          '$cant',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: responsive.ip(1.5),),
                        ),
                        alignment: Alignment.center,
                        width: responsive.ip(1.9),
                        height: responsive.ip(1.9),
                        decoration: BoxDecoration(
                            color: Colors.green, shape: BoxShape.circle),
                      ),
                    ),
                    //child: Icon(Icons.brightness_1, size: 8,color: Colors.redAccent,  )
                  )
                ],
              )
            ],
          ),
        ),
        Expanded(
            child: ListView(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          children: <Widget>[
            _resumenPedido(responsive, subtotal, valorDelivery),
            _deliveryRapido(responsive),
            _pagarCarrito(context, responsive),
            _listaProductos(responsive, carrito),
          ],
        ))
      ],
    );
  }

  Widget _deliveryRapido(Responsive responsive) {
    return Container(
      padding: EdgeInsets.all(8),
      margin: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
      decoration: BoxDecoration(
          boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 3)],
          color: Colors.white,
          border: Border.all(color: Colors.white),
          borderRadius: BorderRadius.circular(13)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('Agregar entrega rápida',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: responsive.ip(2))),
              Switch.adaptive(
                value: estadoDelivery,
                onChanged: (bool state) async {
                  print(state);
                  estadoDelivery = state;

                  if (estadoDelivery) {
                    await utils.agregarDeliveryRapido(context);
                  } else {
                    await utils.quitarDeliveryRapido(context);
                  }
                  //setState(() {});
                },
              ),
            ],
          ),
          Text(
            'Tu pedido llegará en máximo 1 hora',
            style: TextStyle(fontSize: responsive.ip(1.7)),
            textAlign: TextAlign.start,
          )
        ],
      ),
    );
  }

  Widget _resumenPedido(
      Responsive responsive, double subtotal, double valorDelivery) {
    final subtotal2 = utils.format(subtotal);
    final valorDelivery2 = utils.format(valorDelivery);
    final totalex = utils.format(subtotal + valorDelivery);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: responsive.wp(2)),
      child: Container(
        decoration: BoxDecoration(
            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 3)],
            color: Colors.white,
            border: Border.all(color: Colors.white),
            borderRadius: BorderRadius.circular(5)),
        child: Padding(
          padding: EdgeInsets.all(responsive.wp(2)),
          child: Column(children: [
            Row(
              children: <Widget>[
                Expanded(
                    child: Text(
                  'Sub Total ',
                  style: TextStyle(fontSize: responsive.ip(2)),
                )),
                Text('S/ $subtotal2',
                    style: TextStyle(fontSize: responsive.ip(2))),
              ],
            ),
            SizedBox(
              height: responsive.hp(2),
            ),
            Row(
              children: <Widget>[
                Expanded(
                    child: Text('Entrega rápida',
                        style: TextStyle(fontSize: responsive.ip(2)))),
                Text('S/ $valorDelivery2',
                    style: TextStyle(fontSize: responsive.ip(2)))
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
                      fontSize: responsive.ip(2.2)),
                )),
                Text('S/ $totalex',
                    style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: responsive.ip(2.2)))
              ],
            ),
          ]),
        ),
      ),
    );
  }

  Widget _pagarCarrito(BuildContext context, Responsive responsive) {
    return GestureDetector(
      child: Padding(
        padding: EdgeInsets.all(responsive.wp(2)),
        child: Container(
          width: double.infinity,
          child: Column(
            children: <Widget>[
              SizedBox(
                width: double.infinity,
                child: RaisedButton(
                    color: Colors.red,
                    textColor: Colors.white,
                    child: Text(
                      'Ordenar Pedido',
                      style: TextStyle(fontSize: responsive.ip(2)),
                    ),
                    onPressed: () {
                      final prefs = Preferences();

                      if (prefs.email != null && prefs.email != "") {
                        Navigator.pushNamed(context, 'detallePago');
                      } else {
                        pedirLogueo();
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
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          title: Text('Debe registrarse para Ordenar'),
          actions: <Widget>[
            FlatButton(
                onPressed: () async {
                  Navigator.pop(context);
                },
                child: Text('Cancelar')),
            FlatButton(
                onPressed: () async {
                  Navigator.pop(context);
                  Navigator.pushNamedAndRemoveUntil(
                      context, 'login', (route) => false);
                },
                child: Text('Continuar')),
          ],
        );
      },
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
          borderRadius: BorderRadius.circular(13)),
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
                  right: responsive.wp(2)),
              child: Text(
                'Productos',
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: responsive.ip(2.8)),
              ),
            );
          }
          final index = i - 1;
          return _itemPedido(responsive, carrito[index]);
        },
      ),
    );
  }

  Widget _itemPedido(Responsive responsive, Carrito carrito) {
    final preciofinal = utils.format(double.parse(carrito.productoPrecio) *
        double.parse(carrito.productoCantidad));
    var observacionProducto = 'Toca para agregar descripción';
    if (carrito.productoObservacion != null &&
        carrito.productoObservacion != ' ') {
      observacionProducto = carrito.productoObservacion;
    }

    return Container(
      padding: EdgeInsets.symmetric(vertical: responsive.hp(1)),
      child: (carrito.productoTipo != '1')
          ? Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Container(
                      width: responsive.wp(35),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: CachedNetworkImage(
                    cacheManager: CustomCacheManager(),
                    placeholder: (context, url) => Image(
                        image: AssetImage('assets/jar-loading.gif'),
                        fit: BoxFit.cover),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                    imageUrl: carrito.productoFoto,
                    imageBuilder: (context, imageProvider) => Container(
                      decoration: BoxDecoration(
                          image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.fill,
                      )),
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
                                fontSize: responsive.ip(1.8)),
                          ),
                          Text(
                            '$preciofinal',
                            style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                                fontSize: responsive.ip(2)),
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
