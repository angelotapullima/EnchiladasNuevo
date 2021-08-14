import 'package:cached_network_image/cached_network_image.dart';
import 'package:enchiladasapp/src/bloc/provider.dart';
import 'package:enchiladasapp/src/models/productos_model.dart';
import 'package:enchiladasapp/src/pages/detalle_producto2.dart';
import 'package:enchiladasapp/src/utils/responsive.dart';
import 'package:enchiladasapp/src/utils/utilidades.dart' as utils;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
      body: Stack(
        children: <Widget>[
          Container(
            height: double.infinity,
            width: double.infinity,
            color: Colors.red,
          ),
          _favoritos(responsive, favoritosBloc),
        ],
      ),
    );
  }

  Widget _favoritos(Responsive responsive, FavoritosBloc favoritosBloc) {
    return StreamBuilder(
      stream: favoritosBloc.productosFavoritosStream,
      builder: (BuildContext context, AsyncSnapshot<List<ProductosData>> snapshot) {
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
                    'Favoritos',
                    style: TextStyle(color: Colors.white, fontSize: responsive.ip(2.6), fontWeight: FontWeight.bold),
                  ),
                  /* IconButton(
                    icon: Icon(
                      Icons.card_giftcard,
                      color: Colors.white,
                      size: responsive.ip(3.5),
                    ),
                    onPressed: () {},
                  ) */
                ],
              ),
            ),
            Expanded(
              child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadiusDirectional.only(topStart: Radius.circular(13), topEnd: Radius.circular(13)), color: Colors.grey[50]),
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
                  )),
            )
          ],
        ));
        if (snapshot.hasData) {
          if (snapshot.data.length > 0) {
            return _listaFavoritos(responsive, snapshot.data);
          } else {
            return sinDatos;
          }
        } else {
          return Center(
            child: CupertinoActivityIndicator(),
          );
        }
      },
    );
  }

  Widget _listaFavoritos(Responsive responsive, List<ProductosData> favoritos) {
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
                  'Favoritos',
                  style: TextStyle(color: Colors.white, fontSize: responsive.ip(2.7), fontWeight: FontWeight.bold),
                ),
                /* IconButton(
                  icon: Icon(
                    Icons.card_giftcard,
                    color: Colors.white,
                    size: responsive.ip(3),
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
                  borderRadius: BorderRadiusDirectional.only(topStart: Radius.circular(13), topEnd: Radius.circular(13)), color: Colors.grey[50]),
              //padding: EdgeInsets.symmetric(horizontal: responsive.wp(3)),
              child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: favoritos.length,
                  itemBuilder: (context, i) => _itemPedido(responsive, favoritos[i])),
            ),
          ),
        ],
      ),
    );
  }

  Widget _itemPedido(Responsive responsive, ProductosData productosData) {
    return GestureDetector(
      child: Container(
        margin: EdgeInsets.symmetric(
          vertical: responsive.hp(0.5),
          horizontal: responsive.wp(3),
        ),
        padding: EdgeInsets.only(right: responsive.wp(3)),
        decoration: BoxDecoration(color: Colors.grey[50], border: Border.all(color: Colors.white), borderRadius: BorderRadius.circular(13)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Container(
              width: responsive.ip(15),
              height: responsive.ip(12),
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
                                child: (downloadProgress.progress != null)
                                    ? Text('${(downloadProgress.progress * 100).toInt().toString()}%')
                                    : Container(),
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
                  ('${productosData.productoDestacado}' != '0')
                      ? Positioned(
                          //right: 0,
                          //left: 0,
                          child: Container(
                            transform: Matrix4.translationValues(-responsive.wp(13), 0, 0),
                            height: responsive.ip(4),
                            child: SvgPicture.asset('assets/medalla.svg'),
                          ),
                        )
                      : Container(),
                  ('${productosData.productoNuevo}' == '1')
                      ? Positioned(
                          bottom: 0,
                          /*  left: responsive.wp(1),
                                  top: responsive.hp(.5), */
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: responsive.wp(3),
                              vertical: responsive.hp(.5),
                            ),
                            decoration: BoxDecoration(
                                //borderRadius: BorderRadius.circular(10),
                                color: Colors.red),
                            child: Text(
                              'Nuevo',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: responsive.ip(1.3),
                              ),
                            ),
                          ),
                        )
                      : Container(),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: responsive.wp(.8)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      productosData.productoNombre,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: responsive.ip(1.8)),
                    ),
                    Text(
                      'S/ ${productosData.productoPrecio}',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: responsive.ip(2)),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: responsive.hp(1)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  IconButton(
                      icon: Icon(
                        Icons.delete_outline,
                        size: responsive.ip(3.5),
                      ),
                      onPressed: () {
                        utils.quitarFavoritos(context, productosData);
                        setState(() {});
                      }),
                  SizedBox(
                    height: responsive.hp(2),
                  ),
                  GestureDetector(
                    child: Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: Colors.red),
                      child: Text(
                        'Agregar',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: responsive.ip(1.8),
                        ),
                      ),
                    ),
                    onTap: () {
                      utils.showToast('Producto agregado al carrito', 2, ToastGravity.TOP);
                      utils.agregarCarrito(productosData, context, "1");
                    },
                  )
                ],
              ),
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
                return DetalleProductitoss2(
                  productosData: productosData,
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
        //Navigator.pushNamed(context, 'detalleP', arguments: productosData);
      },
    );
  }
}
