import 'package:cached_network_image/cached_network_image.dart';
import 'package:enchiladasapp/src/bloc/provider.dart';
import 'package:enchiladasapp/src/models/carrito_model.dart';
import 'package:enchiladasapp/src/models/direccion_model.dart';
import 'package:enchiladasapp/src/models/user.dart';
import 'package:enchiladasapp/src/models/zona_model.dart';
import 'package:enchiladasapp/src/utils/responsive.dart';
import 'package:enchiladasapp/src/utils/utilidades.dart' as utils;
import 'package:enchiladasapp/src/widgets/cantidad_producto.dart';
import 'package:enchiladasapp/src/widgets/preferencias_usuario.dart';
import 'package:enchiladasapp/src/widgets/customCacheManager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MiOrdenTab extends StatefulWidget {
  @override
  _MiOrdenTabState createState() => _MiOrdenTabState();
}

class _MiOrdenTabState extends State<MiOrdenTab> {
  void llamado() {
    setState(() {});
  }

  bool estadoDelivery = false;

  TextEditingController observacionProducto = TextEditingController();
  TextEditingController telefonoController = TextEditingController();
  @override
  void dispose() {
    // Limpia el controlador cuando el Widget se descarte
    telefonoController.dispose();
    observacionProducto.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //_obtenerUbicacion(context);
    final Responsive responsive = new Responsive.of(context);

    final carritoBloc = ProviderBloc.carrito(context);
    carritoBloc.obtenerCarrito();

    final usuarioBloc = ProviderBloc.user(context);
    usuarioBloc.obtenerUsuario();

    return Scaffold(
      backgroundColor: Colors.grey[50],

      body: Stack(children: <Widget>[
        Container(
          height: double.infinity,
          width: double.infinity,
          color: Colors.red,
        ),
        _miOrden(responsive, carritoBloc, usuarioBloc),
      ]),

      //
    );
  }

  Widget _miOrden(
      Responsive responsive, CarritoBloc carritoBloc, UsuarioBloc usuarioBloc) {
    final sinDatos = SafeArea(
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: responsive.wp(2), vertical: responsive.hp(2)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Sus Pedidos',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: responsive.ip(2.6),
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadiusDirectional.only(
                    topStart: Radius.circular(13),
                    topEnd: Radius.circular(13),
                  ),
                  color: Colors.grey[50]),
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      height: responsive.hp(20),
                      child: SvgPicture.asset('assets/carrito.svg'),
                    ),
                    SizedBox(
                      height: responsive.hp(3),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: responsive.wp(2),
                      ),
                      child: Text(
                        'No hay Productos en el carrito',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: responsive.ip(2.5),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
    return StreamBuilder(
        stream: carritoBloc.carritoIdStream,
        builder: (BuildContext context, AsyncSnapshot<List<Carrito>> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.length > 0) {
              return _listaPedidos(responsive, snapshot.data, usuarioBloc);
            } else {
              return sinDatos;
            }
          } else {
            return Center(child: CupertinoActivityIndicator());
          }
        });
  }

  Widget _listaPedidos(Responsive responsive, List<Carrito> carritoBloc,
      UsuarioBloc usuarioBloc) {
    double subtotal = 0;
    for (int i = 0; i < carritoBloc.length; i++) {
      if (carritoBloc[i].productoTipo != '1') {
        subtotal = subtotal +
            (double.parse(carritoBloc[i].productoPrecio) *
                double.parse(carritoBloc[i].productoCantidad));
      } 
    }

    return SafeArea(
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: responsive.wp(2),
              vertical: responsive.hp(2),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Sus Pedidos',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: responsive.ip(2.6),
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadiusDirectional.only(
                      topStart: Radius.circular(13),
                      topEnd: Radius.circular(13),
                    ),
                    color: Colors.grey[50]),
                child: StreamBuilder(
                  stream: usuarioBloc.usuarioStream,
                  builder: (BuildContext context,
                      AsyncSnapshot<List<User>> snapshotUser) {
                    if (snapshotUser.hasData) {
                      if (snapshotUser.data.length > 0) {
                        return ListView(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          children: <Widget>[/* 
                            _direccion(responsive), */
                            SizedBox(height: responsive.hp(2),),
                            _listaproductos(responsive, carritoBloc),
                            _resumenPedidoDetalle(
                                 responsive, subtotal),
                            _pagarCarrito(responsive),
                          ],
                        );
                      } else {
                        return Center(child: Text('no hay usuario'));
                      }
                    } else {
                      return Center(child: CupertinoActivityIndicator());
                    }
                  },
                )),
          ),
        ],
      ),
    );
  }

  Widget _listaproductos(Responsive responsive, List<Carrito> carrito) {
    for (int i = 0; i < carrito.length; i++) {
      if (carrito[i].productoTipo == '1') {
        estadoDelivery = true;
      }
    }
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
          return _itemPedido(responsive, carrito[index]);
        },
      ),
    );
  }

  Widget _itemPedido(Responsive responsive, Carrito carrito) {
    print('carrito ${carrito.productoFoto}');
    final preciofinal = utils.format(double.parse(carrito.productoPrecio) *
        double.parse(carrito.productoCantidad));

    var observacionProducto = 'Toca para agregar Observación';
    if (carrito.productoObservacion != null &&
        carrito.productoObservacion != ' ') {
      observacionProducto = carrito.productoObservacion;
    }

    return Container(
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
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                            imageUrl: '${carrito.productoFoto}',
                            imageBuilder: (context, imageProvider) => Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: imageProvider,
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
                              'S/. $preciofinal',
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
                                size: responsive.ip(4),
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
                  SizedBox(
                    height: responsive.hp(.6),
                  ),
                  GestureDetector(
                    onTap: () {
                      modaldialogoObservacionProducto('${carrito.idProducto}');
                    },
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.mode_edit,
                          color: Colors.red,
                        ),
                        Expanded(
                          child: Text(
                            '$observacionProducto',
                            style: TextStyle(fontSize: responsive.ip(2)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: responsive.hp(1),
                  ),
                ],
              )
            : Container());
  }

  void modaldialogoObservacionProducto(String id) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        final responsive = Responsive.of(context);
        return GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Container(
            padding: MediaQuery.of(context).viewInsets,
            margin: EdgeInsets.only(top: responsive.hp(10)),
            decoration: BoxDecoration(
                borderRadius: BorderRadiusDirectional.only(
                  topEnd: Radius.circular(20),
                  topStart: Radius.circular(20),
                ),
                color: Colors.white),
            child: Padding(
              padding: EdgeInsets.only(
                top: responsive.hp(2),
                left: responsive.wp(5),
                right: responsive.wp(5),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    'Ingrese la observación del producto',
                    style: TextStyle(
                        fontSize: responsive.ip(2.5),
                        fontWeight: FontWeight.bold),
                  ),
                  TextField(
                    controller: observacionProducto,
                  ),
                  SizedBox(
                    height: responsive.hp(3),
                  ),
                  FlatButton(
                    onPressed: () async {
                      if (observacionProducto.text.length > 0) {
                        utils.actualizarObservacion(
                            context, observacionProducto.text, id);

                        observacionProducto.text = '';

                        Navigator.pop(context);
                      } else {
                        utils.showToast('El campo no puede quedar vacio', 2,
                            ToastGravity.TOP);
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: responsive.ip(5),
                        vertical: responsive.ip(1),
                      ),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: Colors.red),
                      child: Text(
                        'Aceptar',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

 /*  Widget _direccion(Responsive responsive) {
    final direcionBloc = ProviderBloc.dire(context);
    direcionBloc.obtenerDireccion();

    return StreamBuilder(
      stream: direcionBloc.direccionStream,
      builder: (BuildContext context, AsyncSnapshot<List<Direccion>> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.length > 0) {
            return _cardDireccion(responsive, context, snapshot.data);
          } else {
            return Container(
              margin: EdgeInsets.symmetric(vertical: responsive.hp(1)),
              height: responsive.hp(10),
              color: Colors.transparent,
              child: Stack(
                children: <Widget>[
                  Container(
                    width: responsive.wp(85),
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 1,
                        itemBuilder: (context, index) {
                          return _tarjetasDireccion(responsive,
                              'agregar Dirección', '', '0', '0', '0');
                        }),
                  ),
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Center(
                      child: FloatingActionButton(
                        mini: true,
                        onPressed: () {
                          Navigator.pushNamed(context, 'sel_Direccion');
                        },
                        backgroundColor: Colors.red,
                        child: Icon(Icons.add),
                      ),
                    ),
                  )
                ],
              ),
            );
            //return direction("", "");
          }
        } else {
          return Container();
        }
      },
    );
  }

  Widget _cardDireccion(Responsive responsive, BuildContext context,
      List<Direccion> direcciones) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          height: responsive.hp(1),
        ),
        Row(
          children: <Widget>[
            Spacer(),
            GestureDetector(
              onTap: (){
                Navigator.pushNamed(context, 'gestionarDirecciones');
              },
              child: Text(
                'Gestionar Direcciones',
                style: TextStyle(
                    color: Colors.red,
                    fontSize: responsive.ip(2),
                    fontWeight: FontWeight.bold),
              ),
            ),
            GestureDetector(onTap: (){
                Navigator.pushNamed(context, 'gestionarDirecciones');
              },
              child: Icon(
                Icons.arrow_forward_ios,
                color: Colors.red,
              ),
            ),
            SizedBox(
              width: responsive.wp(3),
            )
          ],
        ),
        Container(
          margin:
              EdgeInsets.only(top: responsive.hp(1), bottom: responsive.hp(1)),
          height: responsive.hp(10),
          color: Colors.transparent,
          child: Stack(
            children: <Widget>[
              Container(
                width: responsive.wp(99),
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: direcciones.length + 1,
                    itemBuilder: (context, i) {
                      if (i == direcciones.length) {
                        return Container(
                          width: responsive.wp(13),
                          color: Colors.transparent,
                        );
                      }
                      int index = i;
                      return _tarjetasDireccion(
                          responsive,
                          direcciones[index].direccion,
                          direcciones[index].referencia,
                          direcciones[index].seleccionado,
                          '1',
                          direcciones[index].id_direccion.toString());
                    }),
              ),
              Positioned(
                  right: 0,
                  top: 0,
                  bottom: 0,
                  child: Center(
                    child: FloatingActionButton(
                      mini: true,
                      onPressed: () {
                        Navigator.pushNamed(context, 'sel_Direccion');
                      },
                      backgroundColor: Colors.red,
                      child: Icon(Icons.add),
                    ),
                  ))
            ],
          ),
        ),
      ],
    );
  }

  Widget _tarjetasDireccion(Responsive responsive, String direccion,
      String referencia, String seleccionado, String tap, String idDireccion) {
    var refe;
    if (referencia.isEmpty) {
      refe = ' Referencia';
    } else {
      refe = referencia;
    }
    return GestureDetector(
      onTap: () {
        if (tap == '0') {
          Navigator.pushNamed(context, 'sel_Direccion');
        } else {
          utils.seleccionarDireccion(context, idDireccion);
        }
      },
      child: Container(
        width: responsive.wp(35),
        padding: EdgeInsets.symmetric(
          horizontal: responsive.wp(1.5),
        ),
        margin: EdgeInsets.symmetric(
          horizontal: responsive.wp(1.5),
          vertical: responsive.hp(.5),
        ),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.red),
            borderRadius: BorderRadius.circular(10),
            color: (seleccionado == '0') ? Colors.white : Colors.red),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Icon(
              FontAwesomeIcons.houseUser,
              size: responsive.ip(3),
              color: (seleccionado == '0') ? Colors.red : Colors.white,
            ),
            SizedBox(
              width: responsive.wp(2),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    '$direccion',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: (seleccionado == '0') ? Colors.red : Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: responsive.ip(1.5),
                    ),
                  ),
                  SizedBox(
                    height: responsive.hp(2),
                  ),
                  Text(
                    '$refe',
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(
                      color: (seleccionado == '0') ? Colors.red : Colors.white,
                      fontSize: responsive.ip(1.5),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

   */
  /* Widget _resumenPedido(BuildContext context, Responsive responsive,
      double subtotal) {
    var total, deliveryComision = 0.0;

    /* 
    zonaBloc.obtenerUsuarioZona(); */

    return StreamBuilder(
      stream: zonaBloc.zonaUsuarioStream,
      builder: (BuildContext context, AsyncSnapshot<List<Zona>> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.length > 0) {
            if (subtotal > double.parse(snapshot.data[0].zonaPedidoMinimo)) {
              deliveryComision = 0;
            } else {
              deliveryComision = double.parse(snapshot.data[0].zonaPrecio);
            }
            total = subtotal + precioDelivery + deliveryComision;

            return _resumenPedidoDetalle(
                responsive,
                deliveryComision,
                precioDelivery,
                total,
                double.parse(snapshot.data[0].zonaPrecio),
                subtotal);
          } else {
            total = subtotal + precioDelivery + deliveryComision;
            return _resumenPedidoDetalle(responsive, deliveryComision,
                precioDelivery, total, 0, subtotal);
          }
        } else {
          total = subtotal + precioDelivery + deliveryComision;
          return _resumenPedidoDetalle(
              responsive, deliveryComision, precioDelivery, total, 0, subtotal);
        }
      },
    );
  } */

  Widget _resumenPedidoDetalle(
      Responsive responsive,
      double total) {
    final total2 = utils.format(total);

    return Padding(
      padding: EdgeInsets.all(responsive.wp(2)),
      child: Container(
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(color: Colors.black26, blurRadius: 3),
            ],
            color: Colors.white,
            border: Border.all(color: Colors.white),
            borderRadius: BorderRadius.circular(5)),
        child: Padding(
          padding: EdgeInsets.all(responsive.wp(2)),
          child: Column(
            children: [
              Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      'Sub Total',
                      style: TextStyle(
                        fontSize: responsive.ip(2),
                      ),
                    ),
                  ),
                  Text(
                    'S/ $total2',
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
                      'Envío',
                      style: TextStyle(
                        fontSize: responsive.ip(2),
                      ),
                    ),
                  ),
                  Text(
                    'S/ 0.00',
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
                    ),
                  ),
                  Text(
                    'S/ $total2',
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: responsive.ip(2.2),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _pagarCarrito(Responsive responsive) {
    return Padding(
      padding: EdgeInsets.all(
        responsive.wp(2),
      ),
      child: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
        width: double.infinity,
        child: RaisedButton(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
              side: BorderSide(color: Colors.red)),
          color: Colors.red,
          textColor: Colors.white,
          child: Text(
            'Ordenar Pedido',
            style: TextStyle(
              fontSize: responsive.ip(2),
            ),
          ),
          onPressed: () {
            final prefs = Preferences();

            if (prefs.email != null && prefs.email != "") {
              Navigator.pushNamed(context, 'detallePago');
            } else {
              pedirLogueo();
            }
          },
        ),
      ),
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
      },
    );
  }
}
