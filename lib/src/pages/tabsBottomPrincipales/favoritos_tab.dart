import 'package:cached_network_image/cached_network_image.dart';
import 'package:enchiladasapp/src/bloc/provider.dart';
import 'package:enchiladasapp/src/models/productos_model.dart';
import 'package:enchiladasapp/src/pages/detalle_producto2.dart';
import 'package:enchiladasapp/src/utils/responsive.dart';
import 'package:enchiladasapp/src/utils/utilidades.dart' as utils;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';

class FavoritosTab extends StatefulWidget {
  const FavoritosTab({Key key}) : super(key: key);

  @override
  _FavoritosTabState createState() => _FavoritosTabState();
}

class _FavoritosTabState extends State<FavoritosTab> {
  @override
  Widget build(BuildContext context) {
    final Responsive responsive = new Responsive.of(context);

    final favoritosBloc = ProviderBloc.fav(context);
    favoritosBloc.obtenerProductosFavoritos();

    setState(() {
      favoritosBloc.obtenerProductosFavoritos();
    });
    return Scaffold(
      backgroundColor: Color(0xE1F0EFEF),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Favoritos',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.grey[700],
            fontSize: responsive.ip(2.6),
          ),
        ),
      ),
      body: Stack(
        children: <Widget>[
          _favoritos(responsive, favoritosBloc),
        ],
      ),
    );
  }

  Widget _favoritos(Responsive responsive, FavoritosBloc favoritosBloc) {
    return StreamBuilder(
      stream: favoritosBloc.productosFavoritosStream,
      builder: (BuildContext context, AsyncSnapshot<List<ProductosData>> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.length > 0) {
            return GridView.builder(
              padding: EdgeInsets.zero,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio: 1,
                crossAxisCount: 2,
                mainAxisSpacing: responsive.hp(2),
                crossAxisSpacing: responsive.wp(3),
              ),
              itemCount: snapshot.data.length,
              itemBuilder: (context, i) {
                return Transform.translate(
                  offset: Offset(00, i.isOdd ? 100 : 0),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          PageRouteBuilder(
                            transitionDuration: const Duration(milliseconds: 400),
                            pageBuilder: (context, animation, secondaryAnimation) {
                              return DetalleProductitoss2(
                                productosData: snapshot.data[i],
                                mostrarback: true,
                              );
                            },
                            transitionsBuilder: (context, animation, secondaryAnimation, child) {
                              return FadeTransition(
                                opacity: animation,
                                child: child,
                              );
                            },
                          ));
                    },
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                      ),
                      margin: EdgeInsets.only(
                        right: responsive.wp(1.5),
                        left: responsive.wp(1.5),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Stack(
                            children: <Widget>[
                              Container(
                                height: responsive.hp(14),
                                width: double.infinity,
                                child: ClipRRect(
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
                                    imageUrl: '${snapshot.data[i].productoFoto}',
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
                              Positioned(
                                top: 5,
                                left: 0,
                                right: 0,
                                /*  left: responsive.wp(1),
                                              top: responsive.hp(.5), */
                                child: Row(
                                  children: [
                                    ('${snapshot.data[i].productoNuevo}' == '1')
                                        ? Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: responsive.wp(3),
                                              vertical: responsive.hp(.5),
                                            ),
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.only(
                                                  bottomRight: Radius.circular(10),
                                                ),
                                                color: Colors.red),
                                            child: Text(
                                              'Nuevo',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: responsive.ip(1.5),
                                              ),
                                            ),
                                          )
                                        : Container(),
                                    Spacer(),
                                    Container(
                                      padding: EdgeInsets.all(5),
                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(100), color: Colors.white),
                                      child: Center(
                                        child: Icon(
                                          Ionicons.md_heart,
                                          color: Colors.red,
                                          size: 15,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: responsive.wp(2),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                          Container(
                            padding: EdgeInsets.only(
                              right: responsive.wp(1.5),
                              left: responsive.wp(1.5),
                            ),
                            height: responsive.hp(3),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'S/ ${snapshot.data[i].productoPrecio}',
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontFamily: 'Aeonik',
                                    fontSize: responsive.ip(1.9),
                                  ),
                                ),
                                ('${snapshot.data[i].productoDestacado}' != '0')
                                    ? Container(
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
                                      )
                                    : Container(),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              right: responsive.wp(1.5),
                              left: responsive.wp(1.5),
                            ),
                            child: Text(
                              '${snapshot.data[i].productoNombre.toLowerCase()}',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: responsive.ip(1.8),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          } else {
            return SafeArea(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadiusDirectional.only(
                    topStart: Radius.circular(13),
                    topEnd: Radius.circular(13),
                  ),
                  color: Colors.grey[50],
                ),
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
                        padding: EdgeInsets.symmetric(horizontal: responsive.wp(2)),
                        child: Text(
                          'No hay Productos en la sección Favoritos',
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
            );
          }
        } else {
          return Center(
            child: CupertinoActivityIndicator(),
          );
        }
      },
    );
  }
}
