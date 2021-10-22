import 'package:cached_network_image/cached_network_image.dart';
import 'package:enchiladasapp/src/bloc/provider.dart';
import 'package:enchiladasapp/src/models/carrito_model.dart';
import 'package:enchiladasapp/src/utils/responsive.dart';
import 'package:enchiladasapp/src/utils/utilidades.dart' as utils;
import 'package:enchiladasapp/src/widgets/cantidad_producto.dart';
import 'package:enchiladasapp/src/utils/preferencias_usuario.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
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

    final preferences = Preferences();

    final carritoBloc = ProviderBloc.carrito(context);
    carritoBloc.obtenerCarrito();

    final usuarioBloc = ProviderBloc.user(context);
    usuarioBloc.obtenerUsuario();

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Carrito',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.grey[700],
            fontSize: responsive.ip(2.6),
          ),
        ),
      ),
      body: StreamBuilder(
        stream: carritoBloc.carritoIdStream,
        builder: (BuildContext context, AsyncSnapshot<List<Carrito>> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.length > 0) {
              return _listaPedidos(responsive, snapshot.data, usuarioBloc, preferences);
            } else {
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
                            style: TextStyle(color: Colors.white, fontSize: responsive.ip(2.6), fontWeight: FontWeight.bold),
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
            }
          } else {
            return Center(
              child: CupertinoActivityIndicator(),
            );
          }
        },
      ),

      //
    );
  }

  Widget _listaPedidos(Responsive responsive, List<Carrito> carritoList, UsuarioBloc usuarioBloc, Preferences preferences) {
    double subtotal = 0;
    for (int i = 0; i < carritoList.length; i++) {
      if (carritoList[i].productoTipo != '1') {
        subtotal = subtotal + (double.parse(carritoList[i].productoPrecio) * double.parse(carritoList[i].productoCantidad));
      }
    }

    return ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      physics: ScrollPhysics(),
      itemCount: carritoList.length + 1,
      itemBuilder: (context, i) {
        if (i == carritoList.length) {
          return Container(
            color: Color(0xE1F0EFEF),
            child: Column(
              children: [
                Container(
                  height: responsive.hp(4),
                  width: double.infinity,
                  color: Colors.white,
                ),
                SizedBox(
                  height: responsive.hp(3),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: responsive.wp(2),
                    vertical: responsive.hp(1),
                  ),
                  margin: EdgeInsets.symmetric(
                    horizontal: responsive.wp(3),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: responsive.wp(3),
                        ),
                        child: Row(
                          children: [
                            Text(
                              'SubTotal',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.grey,
                                fontSize: 16,
                              ),
                            ),
                            Spacer(),
                            Text(
                              'S/.${utils.format(subtotal)}',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.grey,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: responsive.hp(1),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: responsive.wp(3),
                        ),
                        child: Row(
                          children: [
                            Text(
                              'Envío',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.grey,
                                fontSize: 16,
                              ),
                            ),
                            Spacer(),
                            Text(
                              'S/.0.0',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.grey,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: responsive.hp(1),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: responsive.wp(3),
                        ),
                        child: Row(
                          children: [
                            Text(
                              'Total',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                              ),
                            ),
                            Spacer(),
                            Text(
                              'S/.${utils.format(subtotal)}',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: responsive.hp(2),
                ),
                (preferences.tipoCategoria == '1')
                    ? Container()
                    : InkWell(
                        onTap: () {
                          final prefs = Preferences();

                          if (prefs.email != null && prefs.email != "") {
                            prefs.propinaRepartidor = '0';
                            Navigator.pushNamed(context, 'detallePago');
                          } else {
                            pedirLogueo();
                          }
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(
                            horizontal: responsive.wp(3),
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: responsive.wp(3),
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.orange[300],
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset: Offset(0, 2), // changes position of shadow
                              ),
                            ],
                          ),
                          height: responsive.hp(8),
                          width: double.infinity,
                          child: Row(
                            children: [
                              Icon(
                                Ionicons.ios_cart,
                                color: Color(0xFF677281),
                              ),
                              SizedBox(
                                width: responsive.wp(3),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '${carritoList.length} Productos agregados',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey[700],
                                      fontSize: 13,
                                    ),
                                  ),
                                  Text(
                                    'S/.${utils.format(subtotal)}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                    ),
                                  )
                                ],
                              ),
                              Spacer(),
                              Text(
                                'Pagar',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                  fontSize: responsive.ip(1.5),
                                ),
                              ),
                              Icon(Icons.arrow_forward_ios)
                            ],
                          ),
                        ),
                      ),
                SizedBox(
                  height: responsive.hp(8),
                ),
              ],
            ),
          );
        }

        if (carritoList[i].idCategoria == '97') {
          return Padding(
            padding: EdgeInsets.symmetric(
              vertical: responsive.hp(2),
              horizontal: responsive.wp(2),
            ),
            child: Row(
              children: [
                Text(
                  '${carritoList[i].productoNombre}',
                  style: TextStyle(fontSize: responsive.ip(1.8), fontWeight: FontWeight.bold),
                ),
                Spacer(),
                Text(
                  'S/.${carritoList[i].productoPrecio}',
                  style: TextStyle(fontSize: responsive.ip(2), fontWeight: FontWeight.bold, color: Colors.red),
                ),
                IconButton(
                  icon: Icon(
                    Icons.delete_outline,
                    size: responsive.ip(4),
                  ),
                  onPressed: () {
                    utils.deleteProductoCarrito(context, carritoList[i].idProducto);
                  },
                ),
              ],
            ),
          );
        }

        var observacionProducto = 'Toca para agregar Observación';
        if (carritoList[i].productoObservacion != null && carritoList[i].productoObservacion != ' ') {
          observacionProducto = carritoList[i].productoObservacion;
        }
        return Container(
          padding: EdgeInsets.symmetric(
            horizontal: responsive.wp(2),
            vertical: responsive.hp(.5),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: responsive.wp(20),
                    height: responsive.hp(10),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: CachedNetworkImage(
                          progressIndicatorBuilder: (_, url, downloadProgress) {
                            return Container(
                              width: double.infinity,
                              height: double.infinity,
                              child: Stack(
                                children: [
                                  Center(
                                    child: CircularProgressIndicator(
                                      value: downloadProgress.progress,
                                      backgroundColor: Colors.green,
                                      valueColor: new AlwaysStoppedAnimation<Color>(Colors.red),
                                    ),
                                  ),
                                  Center(
                                    child: (downloadProgress.progress != null)
                                        ? Text(
                                            '${(downloadProgress.progress * 100).toInt().toString()}%',
                                          )
                                        : Container(),
                                  )
                                ],
                              ),
                            );
                          },
                          errorWidget: (context, url, error) => Image(image: AssetImage('assets/carga_fallida.jpg'), fit: BoxFit.cover),
                          imageUrl: '${carritoList[i].productoFoto}',
                          imageBuilder: (context, imageProvider) => Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                        ) /* CachedNetworkImage(
                        placeholder: (context, url) => Container(
                          width: double.infinity,
                          height: double.infinity,
                          child: Center(
                            child: CupertinoActivityIndicator(),
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          width: double.infinity,
                          height: double.infinity,
                          child: Center(
                            child: Icon(Icons.error),
                          ),
                        ),
                        imageUrl: '${carritoList[i].productoFoto}',
                        imageBuilder: (context, imageProvider) => Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ), */
                        ),
                  ),
                  SizedBox(
                    width: responsive.wp(3),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${carritoList[i].productoNombre}',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                        Text(
                          'S/.${carritoList[i].productoPrecio}',
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: responsive.wp(3),
                  ),
                  Container(
                    child: CantidadTab(carrito: carritoList[i], llamada: this.llamado),
                  ),
                  SizedBox(
                    width: responsive.wp(3),
                  ),
                  InkWell(
                    onTap: () {
                      utils.deleteProductoCarrito(context, carritoList[i].idProducto);
                    },
                    child: Icon(Icons.delete, color: Colors.grey),
                  ),
                  SizedBox(
                    width: responsive.wp(3),
                  ),
                ],
              ),
              SizedBox(
                height: responsive.hp(1),
              ),
              GestureDetector(
                onTap: () {
                  observacionProductoController.text = '${carritoList[i].productoObservacion}';
                  modaldialogoObservacionProducto('${carritoList[i].idProducto}');
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
              Divider()
            ],
          ),
        );
      },
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
                    style: TextStyle(fontSize: responsive.ip(2.5), fontWeight: FontWeight.bold),
                  ),
                  TextField(
                    maxLines: 3,
                    controller: observacionProductoController,
                  ),
                  SizedBox(
                    height: responsive.hp(3),
                  ),
                  TextButton(
                    onPressed: () async {
                      if (observacionProductoController.text.length > 0) {
                        utils.actualizarObservacion(context, observacionProductoController.text, id);

                        observacionProductoController.text = '';

                        Navigator.pop(context);
                      } else {
                        utils.showToast('El campo no puede quedar vacio', 2, ToastGravity.TOP);
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: responsive.ip(5),
                        vertical: responsive.ip(1),
                      ),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(50), color: Colors.red),
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
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                Navigator.pushNamedAndRemoveUntil(context, 'login', (route) => false);
              },
              child: Text('Continuar'),
            ),
          ],
        );
      },
    );
  }
}
