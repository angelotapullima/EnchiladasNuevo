import 'package:enchiladasapp/src/api/categorias_api.dart';
import 'package:enchiladasapp/src/api/ordenes_api.dart';
import 'package:enchiladasapp/src/bloc/carrito_completo.dart';
import 'package:enchiladasapp/src/bloc/provider.dart';
import 'package:enchiladasapp/src/database/carrito_database.dart';
import 'package:enchiladasapp/src/database/direccion_database.dart';
import 'package:enchiladasapp/src/database/pedido_database.dart';
import 'package:enchiladasapp/src/database/usuario_database.dart';
import 'package:enchiladasapp/src/models/argumentDetallePedido.dart';
import 'package:enchiladasapp/src/models/argumentsWebview.dart';
import 'package:enchiladasapp/src/models/direccion_model.dart';
import 'package:enchiladasapp/src/models/pedido_server_model.dart';
import 'package:enchiladasapp/src/models/user.dart';
import 'package:enchiladasapp/src/models/zona_model.dart';
import 'package:enchiladasapp/src/utils/responsive.dart';
import 'package:enchiladasapp/src/utils/utilidades.dart' as utils;
import 'package:enchiladasapp/src/utils/preferencias_usuario.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:showcaseview/showcaseview.dart';

class DetallePago extends StatefulWidget {
  const DetallePago({Key key}) : super(key: key);

  @override
  _DetallePagoState createState() => _DetallePagoState();
}

class _DetallePagoState extends State<DetallePago> {
  int _comprobanteValue = 3;
  int _tipoPagoValue = 3;
  String ruc = "";
  String montoPago = "";
  double vuelto = 0;
  String errorRuc = "";
  bool mostrarErrorRuc = false;
  bool pasoFactura = false;
  bool pasoefectivo = false;
  TextEditingController comprobanteController = TextEditingController();
  TextEditingController tipoPagoController = TextEditingController();
  TextEditingController telefonoController = TextEditingController();

  bool estadoDelivery = false;

  //variables que necesitamos

  double precioAPagar;

  @override
  void dispose() {
    // Limpia el controlador cuando el Widget se descarte
    comprobanteController.dispose();
    tipoPagoController.dispose();
    telefonoController.dispose();
    super.dispose();
  }

  void _comprobanteRadioValue(BuildContext context, int value) {
    setState(() {
      _comprobanteValue = value;

      switch (_comprobanteValue) {
        case 0:
          ruc = "";
          //_result = ...
          break;
        case 1:
          modalRuc();
          break;
      }
    });
  }

  void _tipoPagoRadioValue(
      BuildContext context, int value, Responsive responsive, double precio) {
    setState(() {
      _tipoPagoValue = value;

      switch (_tipoPagoValue) {
        case 0:
          //tipoPagoController.text="";
          
          //_result = ...
          break;
        case 1:
        
          _modalCambiarMetodoPago(context, responsive, precio);
          break;
      }
    });
  }

  GlobalKey _one = GlobalKey();
  GlobalKey _two = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final Responsive responsive = new Responsive.of(context);
    final usuarioBloc = ProviderBloc.user(context);
    final carritoBloc = ProviderBloc.carrito(context);
    carritoBloc.obtenerDeliveryRapido();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        title: Text('Orden', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: StreamBuilder(
        stream: carritoBloc.estadoDeliveryStream,
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data) {
              estadoDelivery = snapshot.data;
            } else {
              estadoDelivery = snapshot.data;
            }
            return _contenidoSuperior(context, responsive, usuarioBloc);
          } else {
            return Center(child: CupertinoActivityIndicator());
          }
        },
      ),
    );
  }

  Widget _contenidoSuperior(
      BuildContext context, Responsive responsive, UsuarioBloc usuarioBloc) {
    final direccionBloc = ProviderBloc.dire(context);
    direccionBloc.obtenerDireccionesConZonas();

    return StreamBuilder(
      stream: direccionBloc.direccionZonaStream,
      builder: (BuildContext context, AsyncSnapshot<List<Direccion>> snapshot) {
        List<Direccion> list = List<Direccion>();

        if (snapshot.hasData) {
          if (snapshot.data.length > 0) {
            return _contenido(context, responsive, usuarioBloc, snapshot.data);
          } else {
            return _contenido(context, responsive, usuarioBloc, list);
          }
        } else {
          return _contenido(context, responsive, usuarioBloc, list);
        }
      },
    );
  }

  Widget _contenido(BuildContext context, Responsive responsive,
      UsuarioBloc usuarioBloc, List<Direccion> listDireccion) {
    final preferences = Preferences();
    String direpe = '';
    String refepe = '';
    String distritope = '';
    String datoLlegadaDelivery = '';

    if (listDireccion.length > 0) {
      direpe = listDireccion[0].direccion;
      refepe = listDireccion[0].referencia;
      distritope = listDireccion[0].zonaNombre;
      datoLlegadaDelivery =
          'Su pedido llegará en máximo ${listDireccion[0].zonaTiempo} minutos';
    }
    final date = DateFormat("dd.MM.yyyy").format(DateTime.now());

    return ShowCaseWidget(
        onFinish: () {
          preferences.pantallaDPago = '1';
        },
        autoPlay: false,
        autoPlayDelay: Duration(seconds: 7),
        autoPlayLockEnable: true,
        builder: Builder(builder: (context) {
          if (preferences.pantallaDPago != "1") {
            WidgetsBinding.instance.addPostFrameCallback(
                (_) => ShowCaseWidget.of(context).startShowCase([_one, _two]));
          }
          return SafeArea(
            child: Container(
              margin: EdgeInsets.only(
                top: responsive.hp(1),
              ),
              padding: EdgeInsets.symmetric(horizontal: responsive.wp(5)),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(13),
                border: Border.all(
                  color: Colors.grey[200],
                ),
              ),
              child: ListView(
                scrollDirection: Axis.vertical,
                children: <Widget>[
                  Text(
                    'Resumen de Orden',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.red,
                        fontSize: responsive.ip(2.5),
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: responsive.hp(1),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: responsive.wp(5),
                    ),
                    child: Container(
                      height: responsive.hp(6),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            date.toString(),
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: responsive.ip(2),
                            ),
                          ),
                          Image.asset('assets/logo_enchilada.png'),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: responsive.hp(2),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: responsive.wp(5),
                    ),
                    child: Text(
                      'Productos',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: responsive.ip(2.5),
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(
                    height: responsive.hp(2),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: responsive.wp(5),
                    ),
                    child: _listaProductos(context, responsive),
                  ),
                  Divider(),
                  Divider(),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: responsive.wp(5),
                    ),
                    color: Colors.grey[200],
                    child: Column(
                      children: <Widget>[
                        Showcase(
                            key: _one,
                            description:
                                'Por favor ingrese su número de teléfono',
                            child: _numeroTelefono(
                                usuarioBloc, context, responsive)),
                        Divider(),
                        Showcase(
                            key: _two,
                            description: 'Por favor ingrese su dirección',
                            child: _direccion(
                                direpe, refepe, distritope, responsive)),
                        Divider(),
                      ],
                    ),
                  ),
                  (listDireccion.length > 0)
                      ? Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: responsive.wp(5),
                          ),
                          child:
                              _deliveryRapido(responsive, datoLlegadaDelivery),
                        )
                      : Container(),
                  Divider(),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: responsive.wp(5),
                    ),
                    child: _tipoComprobante(context, responsive),
                  ),
                  Divider(),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: responsive.wp(5),
                    ),
                    child: _tipoPago(responsive),
                  ),
                  Divider(),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: responsive.wp(5),
                    ),
                    child: _pagarCarrito(context, responsive),
                  )
                ],
              ),
            ),
          );
        }));
  }

  Widget _listaProductos(BuildContext context, Responsive responsive) {
    final carritoCompletoBloc = ProviderBloc.carritoCompleto(context);
    carritoCompletoBloc.obtenerCarritoCpmpleto();

    return StreamBuilder( 
      stream: carritoCompletoBloc.carritoCompletoStream,
      builder: (BuildContext context,
          AsyncSnapshot<List<CarritoCompleto>> snapshot) {
        if (snapshot.hasData) {
          double precioTotal = 0.0;
          for (int x = 0; x < snapshot.data.length; x++) {
            if (snapshot.data[x].precio != '') {
              precioTotal = precioTotal +
                  (double.parse(snapshot.data[x].precio) *
                      double.parse(snapshot.data[x].cantidad));
            }
          }
          String precioTotalFinal = utils.format(precioTotal);

          precioAPagar = double.parse(precioTotalFinal);
          var total = Container(
            margin: EdgeInsets.symmetric(
              vertical: responsive.hp(1),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: Text(
                    'Total',
                    style: TextStyle(
                        color: Colors.red,
                        fontSize: responsive.ip(2),
                        fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  width: responsive.wp(10),
                ),
                Text(
                  'S/.$precioTotalFinal',
                  style: TextStyle(
                      color: Colors.red,
                      fontSize: responsive.ip(2),
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          );
          return ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              physics: ScrollPhysics(),
              itemCount: snapshot.data.length + 1,
              itemBuilder: (context, i) {
                if (i == snapshot.data.length) {
                  return total;
                }

                return _productos(responsive, snapshot.data[i]);
              });
        } else {
          return Container();
        }
      },
    );
  }

  Widget _productos(Responsive responsive, CarritoCompleto carrito) {
    int estado = 0;
    String nombre = "";
    String precioFinal;
    if (carrito.precio != '') {
      estado = 1;
      double precio =
          double.parse(carrito.cantidad) * double.parse(carrito.precio);

      precioFinal = utils.format(precio);
      if (int.parse(carrito.cantidad) > 1) {
        nombre = "${carrito.producto} x ${carrito.cantidad}";
      } else {
        nombre = "${carrito.producto}";
      }
    } else {
      nombre = "${carrito.producto}";
    }

    return Container(
      margin: EdgeInsets.symmetric(
        vertical: responsive.hp(0.5),
      ),
      child: (estado == 1)
          ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: Text(
                    '$nombre',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: responsive.ip(1.5),
                    ),
                  ),
                ),
                SizedBox(
                  width: responsive.wp(10),
                ),
                Text(
                  'S/.$precioFinal',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: responsive.ip(1.5),
                  ),
                ),
              ],
            )
          : Text(
              '$nombre',
              style: TextStyle(
                color: Colors.red,
                fontSize: responsive.ip(1.8),
              ),
            ),
    );
  }

  Widget _numeroTelefono(
      UsuarioBloc usuarioBloc, BuildContext context, Responsive responsive) {
    return StreamBuilder(
        stream: usuarioBloc.usuarioStream,
        builder: (BuildContext context, AsyncSnapshot<List<User>> snapshot) {
          String telefono = '-';
          String agregar = 'Agregar';
          if (snapshot.hasData) {
            if (snapshot.data.length > 0) {
              if (snapshot.data[0].telefono != "") {
                telefono = snapshot.data[0].telefono;
                agregar = 'Cambiar';

                return _telefono(telefono, agregar, responsive);
              } else {
                return _telefono(telefono, agregar, responsive);
              }
            } else {
              return _telefono(telefono, agregar, responsive);
            }
          } else {
            return _telefono(telefono, agregar, responsive);
          }
        });
  }

  Widget _telefono(String telefono, String agregar, Responsive responsive) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'Número de Teléfono',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: responsive.ip(2),
                ),
              ),
              FlatButton(
                child: Text(
                  '$agregar',
                  style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: responsive.ip(1.8)),
                ),
                onPressed: () {
                  modaltelefono(responsive);
                },
              ),
            ],
          ),
          Row(crossAxisAlignment: CrossAxisAlignment.center, children: <Widget>[
            Text(
              '+51 ',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: responsive.ip(2.1),
              ),
            ),
            Text(
              '$telefono',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: responsive.ip(2.1),
              ),
            )
          ])
        ]);
  }

  Widget _direccion(String addres, String referencia, String nombreDistrito,
      Responsive responsive) {
    String addresito;
    String agg;
    String ref;

    if (addres == "" || addres == null) {
      addresito = "-";
      agg = "Agregar";
    } else {
      addresito = addres;
      agg = "Cambiar";
    }
    if (referencia == "" || addres == null) {
      ref = "Sin Datos";
    } else {
      ref = referencia;
    }
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('Dirección de envío',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: responsive.ip(2))),
              FlatButton(
                child: Text('$agg',
                    style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: responsive.ip(1.8))),
                onPressed: () {
                  setState(() {});
                  Navigator.pushNamed(context, 'gestionarDirecciones');
                },
              ),
            ],
          ),
          Text(
            '$addresito',
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: responsive.ip(2)),
          ),
          SizedBox(
            height: 5,
          ),
          Row(children: <Widget>[
            Text('Referencia : ',
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: responsive.ip(1.7))),
            Text(
              '$ref',
              style: TextStyle(fontSize: responsive.ip(1.7)),
            ),
          ])
        ]);
  }

  Widget _tipoComprobante(BuildContext context, Responsive responsive) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Text(
          'Comprobante de pago',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: responsive.ip(2),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            GestureDetector(
              onTap: () {
                _comprobanteRadioValue(context, 0);
              },
              child: Container(
                child: Row(
                  children: <Widget>[
                    Radio(
                      value: 0,
                      groupValue: _comprobanteValue,
                      onChanged: (valor) {
                        _comprobanteRadioValue(context, valor);
                      },
                    ),
                    Text(
                      'Boleta',
                      style: new TextStyle(fontSize: responsive.ip(1.8)),
                    ),
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                _comprobanteRadioValue(context, 1);
              },
              child: Container(
                child: Row(
                  children: <Widget>[
                    Radio(
                      value: 1,
                      groupValue: _comprobanteValue,
                      onChanged: (valor) {
                        _comprobanteRadioValue(context, valor);
                      },
                    ),
                    Text(
                      'Factura',
                      style: new TextStyle(
                        fontSize: responsive.ip(1.8),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
        (ruc != "")
            ? Column(
                children: <Widget>[
                 Row(
                    children: <Widget>[
                      Text(
                        'Ruc : ',
                        style: new TextStyle(
                          fontSize: responsive.ip(1.8),
                        ),
                      ),
                      Text(
                        '$ruc',
                        style: new TextStyle(
                            fontSize: responsive.ip(1.8),
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ],
              )
            : Text(
                '$errorRuc',
                style: new TextStyle(
                    fontSize: responsive.ip(1.8), fontWeight: FontWeight.bold),
              )
      ],
    );
  }

  Widget _tipoPago(Responsive responsive) {
    montoPago = tipoPagoController.text;
    vuelto = 0;
    String vuelto2 = '';
    if (montoPago != null && montoPago != "") {
      vuelto = double.parse(montoPago) - precioAPagar;
      vuelto2 = utils.format(vuelto);
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Tipo de pago',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: responsive.ip(1.8),
          ),
        ),
        GestureDetector(
          onTap: () {
            _tipoPagoRadioValue(context, 2, responsive, precioAPagar);
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  _tipoPagoRadioValue(context, 2, responsive, precioAPagar);
                },
                child: Container(
                  child: Row(
                    children: <Widget>[
                      Radio(
                        value: 2,
                        groupValue: _tipoPagoValue,
                        onChanged: (valor) {
                          _tipoPagoRadioValue(
                              context, valor, responsive, precioAPagar);
                        },
                      ),
                      Text(
                        'Tarjeta Física/POS',
                        style: TextStyle(fontSize: responsive.ip(1.8)),
                      ),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  _tipoPagoRadioValue(context, 0, responsive, precioAPagar);
                },
                child: Container(
                  child: Row(
                    children: <Widget>[
                      Radio(
                        value: 0,
                        groupValue: _tipoPagoValue,
                        onChanged: (valor) {
                          _tipoPagoRadioValue(
                              context, valor, responsive, precioAPagar);
                        },
                      ),
                      Text(
                        'Pago Online',
                        style: TextStyle(fontSize: responsive.ip(1.8)),
                      ),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  _tipoPagoRadioValue(context, 1, responsive, precioAPagar);
                },
                child: Container(
                  child: Row(
                    children: <Widget>[
                      Radio(
                        value: 1,
                        groupValue: _tipoPagoValue,
                        onChanged: (valor) {
                          _tipoPagoRadioValue(
                              context, valor, responsive, precioAPagar);
                        },
                      ),
                      Text(
                        'Efectivo',
                        style: TextStyle(
                          fontSize: responsive.ip(1.8),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
        (_tipoPagoValue == 1)
            ? (vuelto < 0)
                ? Container(
                    child: Text(
                      'El monto de pago debe ser superior al precio de la orden',
                      style: TextStyle(
                          fontSize: responsive.ip(1.8),
                          fontWeight: FontWeight.bold),
                    ),
                  )
                : Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Text(
                            'Monto de Pago : ',
                            style: TextStyle(
                              fontSize: responsive.ip(1.8),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              '$montoPago',
                              style: TextStyle(
                                  fontSize: responsive.ip(1.8),
                                  fontWeight: FontWeight.bold),
                            ),
                          )
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Text(
                            'Vuelto ',
                            style: TextStyle(
                              fontSize: responsive.ip(1.8),
                            ),
                          ),
                          Text(
                            '$vuelto2',
                            style: TextStyle(
                                fontSize: responsive.ip(1.8),
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    ],
                  )
            : Container()
      ],
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
                height: responsive.hp(4),
                child: RaisedButton(
                    color: Colors.red,
                    textColor: Colors.white,
                    child: Text(
                      'Realizar Pedido',
                      style: TextStyle(fontSize: responsive.ip(2)),
                    ),
                    onPressed: () {
                      _pagarcarrito(responsive, precioAPagar);
                      //Navigator.pushNamed(context, 'detallePago');
                    }),
              ),
            ],
          ),
        ),
      ),
      onTap: () {},
    );
  }

  void _modalButtonPedidoPendiente(context, Responsive responsive) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
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
              children: <Widget>[
                Text(
                  'Existen pedidos pendientes, por favor revise su historial de pedidos',
                  style: TextStyle(
                      fontSize: responsive.ip(2), fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: responsive.hp(2),
                ),
                Container(
                  height: responsive.hp(30),
                  child: Image(
                    image: AssetImage('assets/logo_enchilada.png'),
                    fit: BoxFit.cover,
                  ),
                ),
                FlatButton(
                  onPressed: () {
                    Navigator.pushNamed(context, 'ordenes');
                  },
                  child: Container(
                    color: Colors.red,
                    padding: EdgeInsets.all(8),
                    child: Text(
                      'ver pedidos pendientes',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: responsive.ip(2),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  void showProcessingDialog() async {
    return showDialog(
      barrierDismissible: true,
      context: context,
      builder: (_) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
          ),
          contentPadding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
          content: Container(
            width: 250.0,
            height: 100.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(
                  width: 5,
                ),
                Text(
                  "Validando...",
                  style: TextStyle(
                    fontFamily: "OpenSans",
                    color: Color(0xFF5B6978),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  String validateMobile(String value) {
    String patttern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
    RegExp regExp = new RegExp(patttern);
    if (value.length == 0) {
      return 'Please enter mobile number';
    } else if (!regExp.hasMatch(value)) {
      return 'Please enter valid mobile number';
    }
    return null;
  }

  void _modalCambiarMetodoPago(context, Responsive responsive, double precio) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context2) {
        final nuevoMetodoPagoBloc = ProviderBloc.npago(context2);

        return StreamBuilder(
          stream: nuevoMetodoPagoBloc.vueltoStream,
          builder: (BuildContext context, AsyncSnapshot snapshotvuelto) {
            double vuelto = 0;
            String vuelto2 = '';

            if (nuevoMetodoPagoBloc.valorVuelto == null) {
            } else {
              vuelto = nuevoMetodoPagoBloc.valorVuelto;
              vuelto2 = utils.format(vuelto);
            }
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        'Ingrese el monto con el que pagará',
                        style: TextStyle(
                            fontSize: responsive.ip(2),
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: responsive.hp(2),
                      ),
                      Row(
                        children: <Widget>[
                          Container(
                            width: responsive.wp(5),
                            child: Text(
                              'S/ ',
                              style: TextStyle(fontSize: responsive.ip(2)),
                            ),
                          ),
                          Container(
                            width: responsive.wp(60),
                            child: TextFormField(
                              style: TextStyle(fontSize: responsive.ip(2)),
                              controller: tipoPagoController,
                              validator: validateMobile,
                              keyboardType: TextInputType.number,
                              onChanged: (val) {
                                if (val.length > 0) {
                                  nuevoMetodoPagoBloc.validarPago2(
                                      val, '$precio');
                                } else {
                                  nuevoMetodoPagoBloc.validarPago2('0', '0');
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: responsive.hp(2),
                      ),
                      Text('Precio : S/ $precio',
                          style: TextStyle(fontSize: responsive.ip(2))),
                      Row(
                        children: <Widget>[
                          (vuelto > 0)
                              ? Text(
                                  'Vuelto : S/ $vuelto2',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: responsive.ip(2)),
                                )
                              : Text('Vuelto : S/ $vuelto2',
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontSize: responsive.ip(2)))
                        ],
                      ),
                      SizedBox(
                        height: responsive.hp(2),
                      ),
                      Center(
                        child: FlatButton(
                          onPressed: () async {
                            setState(() {});
                            Navigator.pop(context);
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
                              'Confirmar',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: responsive.ip(2)),
                            ),
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
      },
    );
  }

  void modaltelefono(Responsive responsive) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        final nuevoMetodoPagoBloc = ProviderBloc.npago(context);

        return StreamBuilder(
          stream: nuevoMetodoPagoBloc.telefonoStream,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            bool validacion = false;
            if (nuevoMetodoPagoBloc.valorValidacionTelefono == null) {
            } else {
              validacion = nuevoMetodoPagoBloc.valorValidacionTelefono;
            }
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
                        'Ingrese su número de Teléfono',
                        style: TextStyle(
                            fontSize: responsive.ip(2.5),
                            fontWeight: FontWeight.bold),
                      ),
                      Row(
                        children: <Widget>[
                          Container(
                            width: responsive.wp(12),
                            child: Text(
                              '+51',
                              style: TextStyle(
                                  fontSize: responsive.ip(2.5),
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Container(
                              width: responsive.wp(75),
                              child: TextField(
                                style: TextStyle(fontSize: responsive.ip(2)),
                                controller: telefonoController,
                                maxLength: 9,
                                keyboardType: TextInputType.number,
                                onChanged: (valor) {
                                  nuevoMetodoPagoBloc.validarTelefono(valor);
                                },
                              ))
                        ],
                      ),
                      (validacion)
                          ? Container()
                          : Text(
                              'El número debe tener más de 9 dígitos',
                              style: TextStyle(
                                  color: Colors.red,
                                  fontSize: responsive.ip(1.8)),
                            ),
                      SizedBox(
                        height: responsive.hp(3),
                      ),
                      FlatButton(
                        onPressed: () async {
                          utils.agregarTelefono(
                              context, telefonoController.text);

                          Navigator.pop(context);
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
                            'Confirmar',
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
      },
    );
  }

  void modalRuc() {
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
                    'Ingrese su número de RUC',
                    style: TextStyle(
                        fontSize: responsive.ip(2.5),
                        fontWeight: FontWeight.bold),
                  ),
                  TextField(
                    controller: comprobanteController,
                    keyboardType: TextInputType.number,
                    maxLength: 11,
                  ),
                  SizedBox(
                    height: responsive.hp(3),
                  ),
                  FlatButton(
                    onPressed: () async {
                      if (comprobanteController.text.length > 0) {
                        //Navigator.pop(context);
                       
                          Navigator.pop(context);
                          //Navigator.pop(context);
                          ruc = comprobanteController.text;
                          
                          setState(() {});
                       
                      } else {
                        utils.showToast('el campo no debe estar vacio', 2,
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
                        'Confirmar',
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

  void _pagarcarrito(Responsive responsive, double precio) async {
    final pedidoApi = OrdenesApi();
    final usuarioDatabase = UsuarioDatabase();
    final direccionDatabase = DireccionDatabase();

    final user = await usuarioDatabase.obtenerUsUario();
    final direccion = await direccionDatabase.obtenerDireccionesConZonas();

    final pedidoDatabase = PedidoDatabase();
    final listPedido = await pedidoDatabase.obtenerPedidosPendiente();

    if (listPedido.length > 0) {
      _modalButtonPedidoPendiente(context, responsive);
    } else {
      if (direccion.length > 0) {
        if (user[0].telefono != "" && user[0].telefono != null) {
          if (_comprobanteValue == 1 || _comprobanteValue == 0) {
            if (_tipoPagoValue == 1 ||
                _tipoPagoValue == 0 ||
                _tipoPagoValue == 2) {
              PedidoServer pedido = new PedidoServer();
              if (_comprobanteValue == 0) {
                //selecciona Boleta
                pedido.pedidoTipoComprobante = "6";
                pedido.pedidoCodPersona = "1";
                pasoFactura = true;
              } else {
                //seleccciona Factura
                pedido.pedidoTipoComprobante = "7";
                pedido.pedidoCodPersona = comprobanteController.text;
              }
              pedido.pedidoMontoFinal = precio.toString();
              if (_tipoPagoValue == 0) {
                pedido.pedidoMontoPago = '0';
                pedido.pedidoVueltoPago = "0";
                pedido.pedidoFormaPago = "3";
                pedido.pedidoEstadoPago = "0";
                pasoefectivo = true;
              } else if (_tipoPagoValue == 1) {
                String vuelto2 = utils.format(vuelto);
                pedido.pedidoMontoPago = montoPago;
                pedido.pedidoVueltoPago = vuelto2;
                pedido.pedidoFormaPago = "4";
                pedido.pedidoEstadoPago = "1";
                if (vuelto < 0) {
                  pasoefectivo = false;
                } else {
                  pasoefectivo = true;
                }
              } else {
                pedido.pedidoMontoPago = '0';
                pedido.pedidoVueltoPago = "0";
                pedido.pedidoFormaPago = "1";
                pedido.pedidoEstadoPago = "0";
                pasoefectivo = true;
                pasoFactura = true;
              }

              if (pasoefectivo) {
                if (pasoFactura) {
                  showProcessingDialog();
                  final res = await pedidoApi.enviarpedido(pedido);
                  
                  if (res.resp == 1) {
                    

                    if (res.link != "") {
                      Navigator.pop(context);
                      ArgumentsDetallePago argumentsDetallePago =
                          ArgumentsDetallePago();
                      argumentsDetallePago.link = res.link;
                      argumentsDetallePago.idPedido = res.idPedido;
                      Navigator.pushNamed(context, 'webView',
                          arguments: argumentsDetallePago);
                    } else {
                      Navigator.pop(context);
                      ArgumentsWebview argumentsWebview = ArgumentsWebview();
                      argumentsWebview.idPedido = res.idPedido;
                      argumentsWebview.codigo = '1';

                      Navigator.pushNamed(context, 'ticket',
                          arguments: argumentsWebview);
                      //Navigator.pop(context);
                      //pedidoCorrecto();
                    }
                  } else if (res.resp == 8) {
                    utils.showToast(
                        'Estamos actualizando los datos de los productos, intentelo más tarde',
                        2,
                        ToastGravity.TOP);
                    //OCURRIO UNA ACTUALIZACION DE PRODUCTOS
                    final categoriasApi = CategoriasApi();
                    categoriasApi.obtenerAmbos();
                    Navigator.pop(context);
                  } else {
                    utils.showToast('Ocurrio un error, intentelo más tarde', 2,
                        ToastGravity.TOP);
                    //Ocurrio un error
                    Navigator.pop(context);
                  }
                } else {
                  utils.showToast('Debe ingresar un Comprobante de pago válido',
                      2, ToastGravity.TOP);
                }
              } else {
                utils.showToast(
                    'El monto de pago debe ser mayor al monto del pedido ',
                    2,
                    ToastGravity.TOP);
              }
            } else {
              utils.showToast(
                  'Debe seleccionar un Tipo de  pago ', 2, ToastGravity.TOP);
            }
          } else {
            utils.showToast('Debe seleccionar un comprobante de  pago ', 2,
                ToastGravity.TOP);
          }
        } else {
          utils.showToast(
              'Ingrese un número de teléfono de entrega', 2, ToastGravity.TOP);
        }
      } else {
        utils.showToast(
            'Ingrese una dirección de entrega', 2, ToastGravity.TOP);
      }
    }
  }

  void pedidoCorrecto() {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (contextd) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            title: Text('Su pedido fue ingresado Correctamente'),
            actions: <Widget>[
              FlatButton(
                  onPressed: () async {
                    Navigator.pop(context);
                    Navigator.of(context).pop();

                    final carritoBloc = ProviderBloc.carrito(context);
                    final carritoDatabase = CarritoDatabase();
                    carritoDatabase.deleteCarritoDb();
                    utils.agregarZona(context, '');
                    carritoBloc.obtenerCarrito();
                  },
                  child: Text('Continuar')),
            ],
          );
        });
  }

  Widget zonadatosFalsos(BuildContext context) {
    final responsive = Responsive.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text('Zona de entrega',
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: responsive.ip(2))),
            FlatButton(
              child: Text(
                'Agregar',
                style:
                    TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                Navigator.pushNamed(context, 'selZona', arguments: 'pago');
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text('Zona de entrega',
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: responsive.ip(2))),
            FlatButton(
              child: Text(
                '$agregar',
                style:
                    TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                Navigator.pushNamed(context, 'selZona', arguments: 'pago');
              },
            ),
          ],
        ),
        Text(
          '$zonacitos',
          style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: responsive.ip(2),),
        ),
        SizedBox(
          height: responsive.hp(1),
        ),
        Text(
          'El monto de su pedido debe ser mayor a ${zonas[0].zonaPedidoMinimo}, sino se le agregará una comisión de ${zonas[0].deliveryProductoNombre} soles.',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: responsive.ip(1.3),
          ),
        ),
      ],
    );
  }

  Widget _deliveryRapido(Responsive responsive, String deliveryLLegada) {
    return Column(
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
                fontSize: responsive.ip(2),
              ),
            ),
            Switch.adaptive(
              value: estadoDelivery,
              onChanged: (bool state) async {
                if (state) {
                  utils.agregarDeliveryRapido(context);
                } else {
                  utils.quitarDeliveryRapido(context);
                }
                print(state);
              },
            ),
          ],
        ),
        Text(
          '$deliveryLLegada',
          textAlign: TextAlign.start,
        )
      ],
    );
  }
}
