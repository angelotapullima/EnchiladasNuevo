import 'package:cached_network_image/cached_network_image.dart';
import 'package:enchiladasapp/src/bloc/provider.dart';
import 'package:enchiladasapp/src/models/carrito_model.dart';
import 'package:enchiladasapp/src/models/user.dart';
import 'package:enchiladasapp/src/utils/responsive.dart';
import 'package:enchiladasapp/src/utils/utilidades.dart' as utils;
import 'package:enchiladasapp/src/widgets/cantidad_producto.dart';
import 'package:enchiladasapp/src/utils/preferencias_usuario.dart';
import 'package:enchiladasapp/src/widgets/customCacheManager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MiOrdenTab extends StatefulWidget {
  @override
  _MiOrdenTabState createState() => _MiOrdenTabState();
}

class _MiOrdenTabState extends State<MiOrdenTab> {
  void llamado() {
    setState(() {});
  }

  bool estadoDelivery = false;

  TextEditingController observacionProductoController = TextEditingController();
  @override
  void dispose() {
    // Limpia el controlador cuando el Widget se descarte
    observacionProductoController.dispose();
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
            return Center(
              child: CupertinoActivityIndicator(),
            );
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
                          children: <Widget>[
                            /* 
                            _direccion(responsive), */
                            SizedBox(
                              height: responsive.hp(2),
                            ),
                            _listaproductos(responsive, carritoBloc),
                            _resumenPedidoDetalle(responsive, subtotal),
                            _pagarCarrito(responsive),
                          ],
                        );
                      } else {
                        return Center(child: Text('no hay usuario'));
                      }
                    } else {
                      return Center(
                        child: CupertinoActivityIndicator(),
                      );
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
                      width: responsive.ip(20),
                      height: responsive.ip(15),
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
                          SizedBox(
                            height: responsive.hp(2),
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

                    observacionProductoController.text = '${carrito.productoObservacion}';
                    modaldialogoObservacionProducto('${carrito.idProducto}');
                  },
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.mode_edit,
                        color: Colors.red,
                        size: responsive.ip(3),
                      ),
                      Expanded(
                        child: Text(
                          '$observacionProducto',
                          style: TextStyle(
                            fontSize: responsive.ip(2),
                          ),
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
          : Container(),
    );
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
                    maxLines: 3,
                    controller: observacionProductoController,
                  ),
                  SizedBox(
                    height: responsive.hp(3),
                  ),
                  FlatButton(
                    onPressed: () async {
                      if (observacionProductoController.text.length > 0) {
                        utils.actualizarObservacion(
                            context, observacionProductoController.text, id);

                        observacionProductoController.text = '';

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

  Widget _resumenPedidoDetalle(Responsive responsive, double total) {
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
          borderRadius: BorderRadius.circular(5),
        ),
        child: Padding(
          padding: EdgeInsets.all(
            responsive.wp(2),
          ),
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
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
        ),
        width: double.infinity,
        height: responsive.hp(5),
        child: RaisedButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
            side: BorderSide(color: Colors.red),
          ),
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
