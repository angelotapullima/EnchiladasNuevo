import 'package:cached_network_image/cached_network_image.dart';
import 'package:enchiladasapp/src/bloc/provider.dart';
import 'package:enchiladasapp/src/models/arguments.dart';
import 'package:enchiladasapp/src/models/productos._model.dart';
import 'package:enchiladasapp/src/pages/detalle_productos.dart';
import 'package:enchiladasapp/src/utils/responsive.dart';
import 'package:enchiladasapp/src/widgets/customCacheManager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:enchiladasapp/src/utils/utilidades.dart' as utils;

class CategoriasEspecialesPage extends StatefulWidget {
  const CategoriasEspecialesPage({Key key}) : super(key: key);

  @override
  _CategoriasEspecialesPage createState() => _CategoriasEspecialesPage();
}

class _CategoriasEspecialesPage extends State<CategoriasEspecialesPage> {
  @override
  Widget build(BuildContext context) { 
    
    final Arguments arg = ModalRoute.of(context).settings.arguments;

    final productosIdBloc = ProviderBloc.prod(context);
    final responsive = Responsive.of(context);
    productosIdBloc.cargandoProductosFalse();
    productosIdBloc.obtenerProductosEnchiladasPorCategoria(arg.productId);

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
            elevation: 0,
            title: Text(title),
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
                      return ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, i) => _itemPedido(
                          context,
                          snapshot.data[i],
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

  Widget _itemPedido(BuildContext context, ProductosData productosData) {
    final Responsive responsive = new Responsive.of(context);

    return GestureDetector(
      child: Container(
        decoration: BoxDecoration(
            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 3)],
            color: Colors.white,
            border: Border.all(color: Colors.white),
            borderRadius: BorderRadius.circular(8)),
        margin: EdgeInsets.symmetric(
            vertical: responsive.hp(0.5), horizontal: responsive.wp(2.5)),
        //height: responsive.hp(13),
        child: Row(
          children: <Widget>[
            Container(
              width: responsive.wp(32),
              height: responsive.hp(16),
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
                  imageUrl:
                      '${productosData.productoFoto}',
                  imageBuilder: (context, imageProvider) => Container(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.fill,
                    )),
                  ),
                ),
              ),
            ),
            SizedBox(width: responsive.wp(2),),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    productosData.productoNombre,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: responsive.ip(1.8),
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'S/ ${productosData.productoPrecio}',
                    style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: responsive.ip(2)),
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
                return DetalleProductitos(productosData: productosData);
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
