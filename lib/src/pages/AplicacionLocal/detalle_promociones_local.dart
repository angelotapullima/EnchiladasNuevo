import 'package:cached_network_image/cached_network_image.dart';
import 'package:enchiladasapp/src/bloc/provider.dart';
import 'package:enchiladasapp/src/models/arguments.dart';
import 'package:enchiladasapp/src/models/categoria_model.dart';
import 'package:enchiladasapp/src/models/productos_model.dart';
import 'package:enchiladasapp/src/pages/AplicacionLocal/producto_foto_local.dart';
import 'package:enchiladasapp/src/pages/detalle_productos.dart';
import 'package:enchiladasapp/src/utils/responsive.dart';
import 'package:enchiladasapp/src/utils/utilidades.dart' as utils;
import 'package:enchiladasapp/src/widgets/customCacheManager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DetallePromocionesLocal extends StatefulWidget {
  const DetallePromocionesLocal({Key key}) : super(key: key);

  @override
  _DetallePromocionesLocalState createState() =>
      _DetallePromocionesLocalState();
}

class _DetallePromocionesLocalState extends State<DetallePromocionesLocal> {
  @override
  Widget build(BuildContext context) {
    final Arguments arg = ModalRoute.of(context).settings.arguments;

    final productosIdBloc = ProviderBloc.prod(context);
    final responsive = Responsive.of(context);
    productosIdBloc.cargandoProductosFalse();
    productosIdBloc.cargarCategoriaProducto(arg.productId);

    return Scaffold(
      body: StreamBuilder(
          stream: productosIdBloc.categoriasProductos,
          builder: (BuildContext context,
              AsyncSnapshot<List<CategoriaData>> snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data.length > 0) {
                var titulo = Padding(
                  padding: EdgeInsets.symmetric(horizontal: responsive.wp(3)),
                  child: Text(
                    '${snapshot.data[0].categoriaNombre}',
                    style: TextStyle(
                        fontSize: responsive.ip(3),
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold),
                  ),
                );
                return Column(
                  children: <Widget>[
                    Container(
                      height: responsive.hp(25),
                      color: Colors.green,
                      child: Stack(
                        children: <Widget>[
                          CachedNetworkImage(
                            cacheManager: CustomCacheManager(),
                            placeholder: (context, url) => Image(
                                image: AssetImage('assets/jar-loading.gif'),
                                fit: BoxFit.cover),
                            errorWidget: (context, url, error) => Image(
                                image: AssetImage('assets/carga_fallida.jpg'),
                                fit: BoxFit.cover),
                            imageUrl: '${snapshot.data[0].categoriaBanner}',
                            imageBuilder: (context, imageProvider) => Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: imageProvider,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          AppBar(
                            title: Text('${snapshot.data[0].categoriaNombre}'),
                            backgroundColor: Colors.transparent,
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadiusDirectional.circular(20),
                            color: Colors.white),
                        transform: Matrix4.translationValues(
                            0, -responsive.hp(2.5), 0),
                        child: (snapshot.data[0].productos.length > 0)
                            ? Container(
                                margin: EdgeInsets.only(top: responsive.hp(1)),
                                child: GridView.builder(
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 2),
                                    itemCount:
                                        snapshot.data[0].productos.length,
                                    itemBuilder: (context, i) {
                                      if (i == 0) {
                                        return Center(child: titulo);
                                      }

                                      int index = i - 1;
                                      return _itemPedido(
                                        context,
                                        snapshot.data[0].productos[index],
                                      );
                                    }),

                                /*  ListView.builder(
                                    scrollDirection: Axis.vertical,
                                    shrinkWrap: true,
                                    itemCount:
                                        snapshot.data[0].productos.length + 1,
                                    itemBuilder: (context, i) {
                                      if (i == 0) {
                                        return titulo;
                                      }

                                      int index = i - 1;
                                      return _itemPedido(
                                        context,
                                        snapshot.data[0].productos[index],
                                      );
                                    }), */
                              )
                            : Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: responsive.ip(3)),
                                width: double.infinity,
                                child: Column(
                                  children: <Widget>[
                                    titulo,
                                    Expanded(
                                      child: Center(
                                        child: Text(
                                            'No hay Productos disponibles'),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                      ),
                    )
                  ],
                );
              } else {
                return Center(child: Text('No hay Productos disponibles'));
              }
            } else {
              return Center(child: CupertinoActivityIndicator());
            }
          }),
    );
  }

  Widget _itemPedido(BuildContext context, ProductosData productosData) {
    final Responsive responsive = new Responsive.of(context);

    return GestureDetector(
      child: Container(
        width: responsive.ip(20),
        height: responsive.ip(16),
        decoration: BoxDecoration(
            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 3)],
            color: Colors.white,
            border: Border.all(color: Colors.white),
            borderRadius: BorderRadius.circular(8)),
        margin: EdgeInsets.symmetric(
            vertical: responsive.hp(0.5), horizontal: responsive.wp(2.5)),
        //height: responsive.hp(13),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: CachedNetworkImage(
                cacheManager: CustomCacheManager(),
                placeholder: (context, url) => Image(
                    image: AssetImage('assets/jar-loading.gif'),
                    fit: BoxFit.cover),
                errorWidget: (context, url, error) => Image(
                    image: AssetImage('assets/carga_fallida.jpg'),
                    fit: BoxFit.cover),
                imageUrl: '${productosData.productoFoto}',
                imageBuilder: (context, imageProvider) => Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.cover,
                  )),
                ),
              ),
            ),
            Positioned(
              right: 0,
              left: 0,
              bottom: 0,
              child: Container(
                padding: EdgeInsets.symmetric(
                  vertical: responsive.hp(2),
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(.5),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '${productosData.productoNombre}',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: responsive.ip(2),
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
            )
          ],
        ),
      ),
      onTap: () {
        Navigator.push(
            context,
            PageRouteBuilder(
              transitionDuration: const Duration(milliseconds: 400),
              pageBuilder: (context, animation, secondaryAnimation) {
                return DetalleProductoFotoLocal(
                  
                  productosData: productosData,
                  mostrarback: true,
                );
              },
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
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
