import 'package:enchiladasapp/src/pages/detalle_productos.dart';
import 'package:enchiladasapp/src/search/search_delegate.dart';
import 'package:enchiladasapp/src/widgets/customCacheManager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:enchiladasapp/src/utils/responsive.dart';
import 'package:enchiladasapp/src/utils/utilidades.dart' as utils;
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:enchiladasapp/src/bloc/provider.dart';
import 'package:enchiladasapp/src/models/categoria_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:enchiladasapp/src/models/productos._model.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class CategoriasPage extends StatelessWidget {
  final _refreshController = RefreshController(initialRefresh: false);
  void _onRefresh(BuildContext context) async {
    print('_onRefresh');
    final categoriasBloc = ProviderBloc.cat(context);
    categoriasBloc.cargandoCategoriasFalse();
    //categoriasBloc.obtenerCategoriasEnchiladas();
    _refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    final categoriasBloc = ProviderBloc.cat(context);
    categoriasBloc.cargandoCategoriasFalse();
    categoriasBloc.obtenerCategoriasEnchiladas();

    return Scaffold(
      body: Stack(children: <Widget>[
        Container(
          height: double.infinity,
          width: double.infinity,
          color: Colors.red,
        ),
        rowDatos(context, categoriasBloc)
      ]),
    );
  }

  Widget _conte(double anchoCategorias, double anchoProductos,
      List<CategoriaData> categorias, BuildContext context) {
    final bottomBloc = ProviderBloc.bottom(context);
    final enchiladasNaviBloc = ProviderBloc.enchiNavi(context);
    enchiladasNaviBloc.changeIndexPage(categorias[0].idCategoria);

    return StreamBuilder(
        stream: bottomBloc.selectPageStream,
        builder: (context, snapshot) {
          return StreamBuilder(
              stream: enchiladasNaviBloc.enchiladasIndexStream,
              builder: (context, snapshot) {
                return Row(
                  children: <Widget>[
                    Container(
                      width: anchoCategorias,
                      child: CategoriasProducto(
                        ancho: anchoCategorias,
                        data: categorias,
                      ),
                    ),
                    Container(
                      width: anchoProductos,
                      child: ProductosIdPage(
                        index: enchiladasNaviBloc.index,
                        ancho: anchoProductos,
                      ),
                    )
                  ],
                );
              });
        });
  }

  Widget rowDatos(BuildContext context, CategoriasBloc categoriasBloc) {
    final responsive = Responsive.of(context);
    final anchoCategorias = responsive.wp(24);
    final anchoProductos = responsive.wp(70);

    return SafeArea(
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: responsive.wp(2),
              vertical: responsive.hp(1),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Categorías',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: responsive.ip(2.8),
                      fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: Icon(
                    Icons.search,
                    color: Colors.white,
                    size: responsive.ip(3.5),
                  ),
                  onPressed: () {
                    showSearch(
                      context: context,
                      delegate: DataSearch(hintText: 'Buscar'),
                    );
                  },
                )
              ],
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadiusDirectional.only(
                  topEnd: Radius.circular(13),
                  topStart: Radius.circular(13),
                ),
                color: Colors.grey[50],
              ),
              padding: EdgeInsets.symmetric(
                horizontal: responsive.wp(3),
                vertical: responsive.hp(1),
              ),
              child: SmartRefresher(
                controller: _refreshController,
                onRefresh: () {
                  _onRefresh(context);
                },
                child: StreamBuilder(
                  stream: categoriasBloc.categoriasEnchiladasStream,
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data.length > 0) {
                        return _conte(anchoCategorias, anchoProductos,
                            snapshot.data, context);
                      } else {
                        return Center(
                          child: Text('No hay datos de categorias'),
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
          ),
        ],
      ),
    );
  }
}

class CategoriasProducto extends StatefulWidget {
  final double ancho;
  final List<CategoriaData> data;

  const CategoriasProducto({Key key, @required this.ancho, @required this.data})
      : super(key: key);

  @override
  _CategoriasProductoState createState() => _CategoriasProductoState();
}

class _CategoriasProductoState extends State<CategoriasProducto> {
  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);
    return Scaffold(
      body: _listaCategorias(widget.data, responsive),
      /* _listaCategorias(categoriasBloc), */
    );
  }

  _listaCategorias(List<CategoriaData> categoriasBloc, Responsive responsive) {
    return Container(
      color: Colors.transparent,
      width: this.widget.ancho,
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: categoriasBloc.length,
        itemBuilder: (context, i) => _listaItems(context, categoriasBloc[i]),
      ),
    );
  }

  _listaItems(BuildContext context, CategoriaData categoria) {
    final size = MediaQuery.of(context).size;
    final responsive = Responsive.of(context);
    final enchiladasNaviBloc = ProviderBloc.enchiNavi(context);

    return StreamBuilder(
        stream: enchiladasNaviBloc.enchiladasIndexStream,
        builder: (context, snapshot) {
          return GestureDetector(
              child: Container(
                width: size.width * 0.25,
                decoration: BoxDecoration(
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
                  color: (categoria.idCategoria == snapshot.data)
                      ? Colors.red
                      : Colors.white,
                  border: Border.all(color: Colors.grey[100]),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Row(
                  children: <Widget>[
                    SizedBox(width: 4),
                    Expanded(
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 2),
                        color: Colors.white,
                        child: Column(
                          children: <Widget>[
                            Container(
                              height: responsive.ip(6),
                              width: responsive.ip(6),
                              child: SvgPicture(
                                  AdvancedNetworkSvg(
                                      '${categoria.categoriaIcono}',
                                      SvgPicture.svgByteDecoder,
                                      useDiskCache: true),
                                  fit: BoxFit.cover),
                            ),
                            SizedBox(
                              height: responsive.hp(1),
                            ),
                            Text(categoria.categoriaNombre,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: responsive.ip(1.5),
                                ),
                                textAlign: TextAlign.center),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              onTap: () {
                enchiladasNaviBloc.changeIndexPage(categoria.idCategoria);
                //Navigator.pushNamed(context, 'ProductosID',arguments: categoria);
              });
        });
  }
}

class ProductosIdPage extends StatefulWidget {
  final double ancho;
  final String index;

  const ProductosIdPage({Key key, @required this.ancho, @required this.index})
      : super(key: key);

  @override
  _ProductosIdPageState createState() => _ProductosIdPageState();
}

class _ProductosIdPageState extends State<ProductosIdPage> {
  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);
    final productosIdBloc = ProviderBloc.prod(context);

    productosIdBloc.cargandoProductosFalse();
    productosIdBloc.obtenerProductosEnchiladasPorCategoria(widget.index);

    return Scaffold(
      body: _listaProductosId(productosIdBloc, responsive),
    );
  }

  Widget _listaProductosId(
      ProductosBloc productosIdBloc, Responsive responsive) {
    return Container(
      color: Colors.transparent,
      width: this.widget.ancho,
      child: StreamBuilder(
        stream: productosIdBloc.productosEnchiladasStream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.length > 0) {
              final productos = snapshot.data;

              return ListView.builder(
                itemCount: productos.length,
                itemBuilder: (BuildContext context, int index) {
                  return _itemPedido(
                    context,
                    productos[index],
                  );
                },
              );
            }
            return Center(
              child: Text('no hay productos en esta categoría'),
            );
          } else {
            return Center(
              child: CupertinoActivityIndicator(),
            );
          }
        },
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
        margin: EdgeInsets.symmetric(vertical: responsive.hp(0.5)),
        //height: responsive.hp(13),
        child: Row(
          children: <Widget>[
            Hero(
              tag: '${productosData.idProducto}',
              child: Container(
                width: responsive.ip(15),
                height: responsive.ip(12),
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
                            fit: BoxFit.fill,
                          )),
                        ),
                      ),
                    ),
                    Positioned(
                        right: responsive.wp(1),
                        top: responsive.hp(.5),
                        child: (productosData.productoFavorito == 1)
                            ? Container(
                                height: responsive.ip(4),
                                width: responsive.ip(4),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.red.withOpacity(.3),
                                ),
                                child: Center(
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        utils.quitarFavoritos(
                                            context, productosData);
                                      });
                                    },
                                    child: Icon(FontAwesomeIcons.solidHeart,
                                        color: Colors.red,
                                        size: responsive.ip(3)),
                                  ),
                                ),
                              )
                            : Container(
                                height: responsive.ip(4),
                                width: responsive.ip(4),
                                 decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.red.withOpacity(.3),
                                ),
                                child: Center(
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        utils.agregarFavoritos(
                                            context, productosData);
                                      });
                                    },
                                    child: Icon(FontAwesomeIcons.heart,
                                        color: Colors.white,
                                        size: responsive.ip(3)),
                                  ),
                                ),
                              )),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: responsive.wp(1),
            ),
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
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: responsive.ip(2),
                    ),
                  ),
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
            transitionDuration: const Duration(milliseconds: 100),
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
          ),
        );
        //Navigator.pushNamed(context, 'detalleP', arguments: productosData);
      },
    );
  }
}
