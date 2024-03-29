import 'package:cached_network_image/cached_network_image.dart';
import 'package:enchiladasapp/src/bloc/provider.dart';
import 'package:enchiladasapp/src/models/arguments.dart';
import 'package:enchiladasapp/src/models/productos_model.dart';
import 'package:enchiladasapp/src/pages/detalle_productos.dart';
import 'package:enchiladasapp/src/utils/responsive.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:enchiladasapp/src/utils/utilidades.dart' as utils;

class CategoriasEspecialesPage extends StatefulWidget {
  final Arguments arg;
  const CategoriasEspecialesPage({Key key, @required this.arg}) : super(key: key);

  @override
  _CategoriasEspecialesPage createState() => _CategoriasEspecialesPage();
}

class _CategoriasEspecialesPage extends State<CategoriasEspecialesPage> {
  @override
  Widget build(BuildContext context) {
    //final Arguments arg = ModalRoute.of(context).settings.arguments;

    final productosIdBloc = ProviderBloc.prod(context);
    final responsive = Responsive.of(context);
    productosIdBloc.cargandoProductosFalse();
    productosIdBloc.obtenerProductosdeliveryEnchiladasPorCategoria(widget.arg.productId);

    return Scaffold(
        body: Stack(children: <Widget>[
      Container(
        height: responsive.hp(70),
        width: double.infinity,
        color: Colors.red,
      ),
      _listaEspeciales(responsive, productosIdBloc, widget.arg.title)
      //_favoritos(responsive, favoritosBloc),
    ]));
  }

  Widget _listaEspeciales(Responsive responsive, ProductosBloc productosIdBloc, String title) {
    return SafeArea(
      child: Column(
        children: <Widget>[
          AppBar(
            toolbarHeight: responsive.hp(8),
            elevation: 0,
            title: Text(
              title,
              style: TextStyle(fontSize: responsive.ip(2.4)),
            ),
            /* actions: <Widget>[
              IconButton(
                icon: Icon(Icons.card_giftcard),
                onPressed: () {},
              )
            ], */
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadiusDirectional.only(
                  topStart: Radius.circular(13),
                  topEnd: Radius.circular(13),
                ),
                color: Colors.grey[50],
              ),
              //padding: EdgeInsets.symmetric(horizontal: responsive.wp(3)),
              child: StreamBuilder(
                stream: productosIdBloc.productosEnchiladasStream,
                builder: (BuildContext context, AsyncSnapshot<List<ProductosData>> snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data.length > 0) {
                      return ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, i) => _itemPedido(
                          context,
                          snapshot.data[i],
                          snapshot.data.length.toString(),
                        ),
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
            ),
          ),
        ],
      ),
    );
  }

  Widget _itemPedido(BuildContext context, ProductosData productosData, String cantidadItems) {
    final Responsive responsive = new Responsive.of(context);

    return GestureDetector(
      child: Container(
        decoration: BoxDecoration(
            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 3)], color: Colors.white, border: Border.all(color: Colors.white), borderRadius: BorderRadius.circular(8)),
        margin: EdgeInsets.symmetric(vertical: responsive.hp(0.5), horizontal: responsive.wp(2.5)),
        //height: responsive.hp(13),
        child: Row(
          children: <Widget>[
            Container(
              width: responsive.ip(20),
              height: responsive.ip(16),
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
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
                                child: (downloadProgress.progress != null) ? Text('${(downloadProgress.progress * 100).toInt().toString()}%') : Container(),
                              )
                            ],
                          ),
                        );
                      },
                      errorWidget: (context, url, error) => Image(image: AssetImage('assets/carga_fallida.jpg'), fit: BoxFit.cover),
                      imageUrl: '${productosData.productoFoto}',
                      imageBuilder: (context, imageProvider) => Container(
                        decoration: BoxDecoration(
                            image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.fill,
                        )),
                      ),
                    ),
                  ),
                  ('${productosData.productoNuevo}' == '1')
                      ? Positioned(
                          bottom: 0,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: responsive.wp(3),
                              vertical: responsive.wp(.5),
                            ),
                            decoration: BoxDecoration(
                                //borderRadius: BorderRadius.circular(10),
                                color: Colors.red),
                            child: Text(
                              'Nuevo',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: responsive.ip(1.5),
                              ),
                            ),
                          ),
                        )
                      : Container(),
                  ('${productosData.productoDestacado}' != '0')
                      ? Positioned(
                          //right: 0,
                          //left: 0,
                          child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: responsive.wp(2),
                            vertical: responsive.hp(.5),
                          ),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              /* borderRadius: BorderRadius.only(
                                                    bottomRight: Radius.circular(10),
                                                  ), */
                              color: Colors.orange),
                          child: Text(
                            'Destacado',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: responsive.ip(1.3),
                            ),
                          ),
                        ))
                      : Container(),
                ],
              ),
            ),
            SizedBox(
              width: responsive.wp(2),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    productosData.productoNombre,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black, fontSize: responsive.ip(1.8), fontWeight: FontWeight.bold),
                  ),
                  
                ],
              ),
            ),
            Column(
              children: <Widget>[
                (productosData.productoFavorito == 1)
                    ? IconButton(
                        onPressed: () {
                          setState(() {
                            utils.quitarFavoritos(context, productosData);
                          });
                        },
                        icon: Icon(
                          FontAwesomeIcons.solidHeart,
                          color: Colors.red,
                        ),
                      )
                    : IconButton(
                        onPressed: () {
                          setState(() {
                            utils.agregarFavoritos(context, productosData);
                          });
                        },
                        icon: Icon(
                          FontAwesomeIcons.heart,
                          color: Colors.red,
                        ))
              ],
            ),
          ],
        ),
      ),
      onTap: () {
        Navigator.push(
            context,
            PageRouteBuilder(
              transitionDuration: const Duration(milliseconds: 400),
              pageBuilder: (context, animation, secondaryAnimation) {
                return SliderDetalleProductos(
                  numeroItem: productosData.numeroitem,
                  idCategoria: productosData.idCategoria,
                  cantidadItems: cantidadItems,
                );
                //return DetalleProductitos(productosData: productosData);
              },
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                return FadeTransition(
                  opacity: animation,
                  child: child,
                );
              },
            ));
        //Navigator.pushNamed(context, 'detalleP', arguments: productosData);
      },
    );
  }
}
