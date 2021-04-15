import 'package:cached_network_image/cached_network_image.dart';
import 'package:enchiladasapp/src/bloc/provider.dart';
import 'package:enchiladasapp/src/models/arguments.dart';
import 'package:enchiladasapp/src/models/productos_model.dart';
import 'package:enchiladasapp/src/pages/AplicacionLocal/producto_foto_local.dart';
import 'package:enchiladasapp/src/utils/responsive.dart';
import 'package:enchiladasapp/src/widgets/customCacheManager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProductosCategoria extends StatefulWidget {
  const ProductosCategoria({Key key}) : super(key: key);

  @override
  _ProductosCategoriaPage createState() => _ProductosCategoriaPage();
}

class _ProductosCategoriaPage extends State<ProductosCategoria> {
  @override
  Widget build(BuildContext context) {
    final Arguments arg = ModalRoute.of(context).settings.arguments;

    final productosIdBloc = ProviderBloc.prod(context);
    final responsive = Responsive.of(context);
    productosIdBloc.cargandoProductosFalse();
    productosIdBloc.obtenerProductosLocalEnchiladasPorCategoria(arg.productId);

    return Scaffold(
        body: Stack(children: <Widget>[
      Container(
        height: responsive.hp(70),
        width: double.infinity,
        color: Colors.red,
      ),
      _listaEspeciales(responsive, productosIdBloc, arg.title)
      //_favoritos(responsive, favoritosBloc),
    ]));
  }

  Widget _listaEspeciales(
      Responsive responsive, ProductosBloc productosIdBloc, String title) {
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
                builder: (BuildContext context,
                    AsyncSnapshot<List<ProductosData>> snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data.length > 0) {
                      return GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2),
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, i) => _itemPedido(context,
                            snapshot.data[i], snapshot.data.length.toString()),
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

  Widget _itemPedido(
      BuildContext context, ProductosData productosData, String cantidad) {
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
                                    valueColor: new AlwaysStoppedAnimation<Color>(
                                        Colors.red),
                                  ),
                                ),
                                Center(
                                  child: (downloadProgress.progress != null)
                                      ? Text(
                                          '${(downloadProgress.progress * 100).toInt().toString()}%')
                                      : Container(),
                                )
                              ],
                            ),
                          );
                        },
                errorWidget: (context, url, error) => Image(
                    image: AssetImage('assets/carga_fallida.jpg'),
                    fit: BoxFit.cover),
                imageUrl: '${productosData.productoFoto}',
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
                return ProductoFotoLocal(
                    cantidadItems: cantidad,
                    idCategoria: productosData.idCategoria,
                    numeroItem: productosData.numeroitem);
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
