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
import 'package:enchiladasapp/src/widgets/zona_direction.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MiOrdenTab extends StatefulWidget {
  @override
  _MiOrdenTabState createState() => _MiOrdenTabState();
}

class _MiOrdenTabState extends State<MiOrdenTab> {
  void llamado() {
    setState(() {});
  }

  bool estadoDelivery = false;

  /* void _obtenerUbicacion(BuildContext context) async {
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    List<Placemark> placemark = await Geolocator()
        .placemarkFromCoordinates(position.latitude, position.longitude);
    //print(placemark);
    final addresito =
        "${placemark[0].thoroughfare} ${placemark[0].subThoroughfare}";

    utils.agregarDireccion(
        context, addresito, position.latitude, position.longitude, "");
  } */

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
                /* IconButton(
                icon: Icon(
                  Icons.card_giftcard,
                  color: Colors.white,
                  size: responsive.ip(3.5),
                ),
                onPressed: () {
                  setState(() {});
                },
              ) */
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
                        child: SvgPicture.asset('assets/carrito.svg')),
                    SizedBox(
                      height: responsive.hp(3),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: responsive.wp(2)),
                      child: Text(
                        'No hay Productos en el carrito',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.black, fontSize: responsive.ip(2.5)),
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
    double valorDelivery = 0;
    //double total = 0;
    for (int i = 0; i < carritoBloc.length; i++) {
      if (carritoBloc[i].productoTipo != '1') {
        subtotal = subtotal +
            (double.parse(carritoBloc[i].productoPrecio) *
                double.parse(carritoBloc[i].productoCantidad));
      } else {
        valorDelivery = double.parse(carritoBloc[i].productoPrecio);
      }
    }

    return SafeArea(
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
                /* IconButton(
                  icon: Icon(
                    Icons.card_giftcard,
                    color: Colors.white,
                    size: responsive.ip(3.5),
                  ),
                  onPressed: () {
                    setState(() {});
                  },
                ) */
              ],
            ),
          ),
          Expanded(
            child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadiusDirectional.only(
                        topStart: Radius.circular(13),
                        topEnd: Radius.circular(13)),
                    color: Colors.grey[50]),
                padding: EdgeInsets.symmetric(horizontal: 10),
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
                            _direccion(),
                            _zona(context),
                            _listaproductos(responsive, carritoBloc),
                            _deliveryRapido(responsive),
                            _resumenPedido(
                                context, responsive, subtotal, valorDelivery),
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
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                            imageUrl: carrito.productoFoto,
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
                                /* final carritoDatabase = CarritoDatabase();
                                carritoDatabase
                                    .deteleProductoCarrito(carrito.idProducto); */
                              },
                            ),
                            Container(
                                child: CantidadTab(
                                    carrito: carrito, llamada: this.llamado))
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
            : Container());
  }

  void dialogoObservacionProducto(String id) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (contextd) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
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
              child: Text('Cancelar'),
            ),
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
      },
    );
  }

  void dialogoIngresarTelefono(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (contextd) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          title: Text('Ingrese su número de Teléfono'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: telefonoController,
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
                child: Text('cancelar')),
            FlatButton(
              onPressed: () async {
                utils.agregarTelefono(context, telefonoController.text);

                Navigator.pop(context);
              },
              child: Text('Continuar'),
            ),
          ],
        );
      },
    );
  }

  Widget _numeroTelefono(BuildContext context, List<User> user) {
    String telefono = '-';
    String agregar = 'Agregar';
    if (user[0].telefono != "") {
      telefono = user[0].telefono;
      agregar = 'Cambiar';
      print('esto es prueba de telefono $telefono');
    }

    return _telephone(context, agregar, telefono);
  }

  Widget _direccion() {
    final direcionBloc = ProviderBloc.dire(context);
    direcionBloc.obtenerDireccion();

    return StreamBuilder(
      stream: direcionBloc.direccionStream,
      builder: (BuildContext context, AsyncSnapshot<List<Direccion>> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.length > 0) {
            return direction(
                snapshot.data[0].direccion, snapshot.data[0].referencia);
          } else {
            return direction("", "");
          }
        } else {
          return direction("", "");
        }
      },
    );
  }

  Widget _telephone(BuildContext context, String agregar, String telefono) {
    return Container(
      padding: EdgeInsets.all(8),
      margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
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
              Text('Número de Teléfono',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 18)),
              FlatButton(
                child: Text(
                  '$agregar',
                  style:
                      TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  dialogoIngresarTelefono(context);
                },
              ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                '+51 ',
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 22),
              ),
              Text(
                '$telefono',
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 22),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _zona(BuildContext context) {
    final zonaBloc = ProviderBloc.zona(context);
    zonaBloc.obtenerUsuarioZona();

    return StreamBuilder(
      stream: zonaBloc.zonaUsuarioStream,
      builder: (BuildContext context, AsyncSnapshot<List<Zona>> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.length > 0) {
            return zonaDatos(context, 'Cambiar', snapshot.data);
          } else {
            return zonadatosFalsos(context);
          }
        } else {
          return zonadatosFalsos(context);
        }
      },
    );
  }

  Widget zonadatosFalsos(BuildContext context) {
    final responsive = Responsive.of(context);
    return Container(
      padding: EdgeInsets.all(8),
      margin: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
      decoration: BoxDecoration(
        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 3)],
        color: Colors.white,
        border: Border.all(color: Colors.white),
        borderRadius: BorderRadius.circular(13),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'Zona de entrega',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: responsive.ip(2),
                ),
              ),
              FlatButton(
                child: Text(
                  'Agregar',
                  style:
                      TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, 'selZona', arguments: 'carrito');
                },
              ),
            ],
          ),
          Text(
            'Elegir Zona',
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: responsive.ip(2)),
          ),
        ],
      ),
    );
  }

  Widget zonaDatos(BuildContext context, String agregar, List<Zona> zonas) {
    final responsive = Responsive.of(context);
    var zonacitos = 'Elegir zona';
    if (zonas != null) {
      if (zonas.length > 0) {
        zonacitos = zonas[0].zonaNombre;
      }
    }

    return Container(
      padding: EdgeInsets.all(8),
      margin: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(color: Colors.black26, blurRadius: 3),
        ],
        color: Colors.white,
        border: Border.all(color: Colors.white),
        borderRadius: BorderRadius.circular(13),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'Zona de entrega',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: responsive.ip(2),
                ),
              ),
              FlatButton(
                child: Text(
                  '$agregar',
                  style:
                      TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, 'selZona', arguments: 'carrito');
                },
              ),
            ],
          ),
          Text(
            '$zonacitos',
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: responsive.ip(2)),
          ),
          SizedBox(
            height: responsive.hp(1),
          ),
          Text(
            'El monto de su pedido debe ser mayor a ${zonas[0].zonaPedidoMinimo}, sino se le agregará una comisión de ${zonas[0].zonaPrecio} soles.',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: responsive.ip(1.3),
            ),
          ),
        ],
      ),
    );
  }

  Widget direction(String addres, String referencia) {
    String addresito;
    String agg;
    String ref;

    if (addres.isEmpty || addres == null) {
      addresito = "-";
      agg = "Agregar";
    } else {
      addresito = addres;
      agg = "Cambiar";
    }
    if (referencia.isEmpty || addres == null) {
      ref = "Sin Datos";
    } else {
      ref = referencia;
    }
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
              Text(
                'Dirección de envío',
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
              FlatButton(
                child: Text(
                  '$agg',
                  style:
                      TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, 'sel_Direccion');
                },
              ),
            ],
          ),
          Text(
            '$addresito',
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            children: <Widget>[
              Text('Referencia : ',
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold)),
              Text('$ref'),
            ],
          )
        ],
      ),
    );
  }

  Widget _resumenPedido(BuildContext context, Responsive responsive,
      double subtotal, double precioDelivery) {
    var total, deliveryComision = 0.0;

    final zonaBloc = ProviderBloc.zona(context);
    zonaBloc.obtenerUsuarioZona();

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
  }

  Widget _resumenPedidoDetalle(
      Responsive responsive,
      double comisionDeliveryZona,
      double precioDelivery,
      double total,
      double pedidoMinimo,
      double subtotal) {
    final subtotal2 = utils.format(subtotal);
    final comisionDeliveryZona2 = utils.format(comisionDeliveryZona);
    final precioDelivery2 = utils.format(precioDelivery);
    final total2 = utils.format(total);
    final pedidoMinimo2 = utils.format(pedidoMinimo);

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
                      'Entrega Rápida',
                      style: TextStyle(
                        fontSize: responsive.ip(2),
                      ),
                    ),
                  ),
                  Text(
                    'S/ $precioDelivery2',
                    style: TextStyle(
                      fontSize: responsive.ip(2),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: responsive.hp(2),
              ),
              (comisionDeliveryZona > 0)
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                'Comisión por Delivery',
                                style: TextStyle(
                                  fontSize: responsive.ip(2),
                                ),
                              ),
                            ),
                            Text(
                              'S/ $comisionDeliveryZona2',
                              style: TextStyle(
                                fontSize: responsive.ip(2),
                              ),
                            )
                          ],
                        ),
                        Text(
                          'Su total del pedido no llego al mínimo establecido para su zona, por lo tanto se le cobrará un recargo de $pedidoMinimo2 soles',
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: responsive.ip(1.5),
                          ),
                        ),
                        SizedBox(
                          height: responsive.hp(2),
                        ),
                      ],
                    )
                  : Container(),
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
      },
    );
  }

  Widget _deliveryRapido(Responsive responsive) {
    return Container(
      padding: EdgeInsets.all(8),
      margin: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(color: Colors.black26, blurRadius: 3),
        ],
        color: Colors.white,
        border: Border.all(color: Colors.white),
        borderRadius: BorderRadius.circular(13),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'Agregar entrega rápida',
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
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
            textAlign: TextAlign.start,
          )
        ],
      ),
    );
  }
}
