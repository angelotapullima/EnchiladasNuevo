import 'package:cached_network_image/cached_network_image.dart';
import 'package:enchiladasapp/src/bloc/provider.dart';
import 'package:enchiladasapp/src/models/arguments.dart';
import 'package:enchiladasapp/src/models/categoria_model.dart';
import 'package:enchiladasapp/src/models/productos_model.dart';
import 'package:enchiladasapp/src/pages/AplicacionLocal/detalle_promociones_local.dart';
import 'package:enchiladasapp/src/pages/AplicacionLocal/producto_foto_local.dart';
import 'package:enchiladasapp/src/search/search_local.dart';
import 'package:enchiladasapp/src/utils/responsive.dart';
import 'package:enchiladasapp/src/widgets/customCacheManager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_view_indicators/circle_page_indicator.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class PrincipalLocal extends StatelessWidget {
  final _refreshController = RefreshController(initialRefresh: false);
  final _pageController = PageController(viewportFraction: 0.9, initialPage: 1);
  final _currentPageNotifier = ValueNotifier<int>(1);

  void _onRefresh(BuildContext context) async {
    print('_onRefresh pantalla');
    final pantallasBloc = ProviderBloc.pantallaLocal(context);
    final categoriasBloc = ProviderBloc.cat(context);
    pantallasBloc.obtenerPantallasLocal();
    categoriasBloc.obtenerCategoriasPromociones();
    _refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    final Responsive responsive = new Responsive.of(context);

    final pantallasBloc = ProviderBloc.pantallaLocal(context);
    final categoriasBloc = ProviderBloc.cat(context);
    pantallasBloc.obtenerPantallasLocal();
    categoriasBloc.obtenerCategoriasPromociones();
    /*  final usuarioBloc = ProviderBloc.user(context);
    usuarioBloc.obtenerUsuario(); */

    return Scaffold(
      body: _inicio(context, responsive, _refreshController),
    );
  }

  Widget _inicio(BuildContext context, Responsive responsive,
      RefreshController refreshController) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
                color: Colors.red),
            height: responsive.hp(12),
            padding: EdgeInsets.symmetric(horizontal: responsive.hp(2)),
            child: SafeArea(
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: responsive.hp(1),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          'Bienvenido',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: responsive.ip(3),
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          showSearch(
                              context: context,
                              delegate: SearchLocal(hintText: 'Buscar'));
                        },
                        child: Icon(
                          Icons.search,
                          color: Colors.white,
                          size: responsive.ip(4),
                        ),
                      ),
                      SizedBox(
                        width: responsive.wp(2),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Expanded(child: _contenido(context, responsive, refreshController))
        ],
      ),
    );
  }

  _buildPageView(Responsive responsive, List<CategoriaData> promociones) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
        color: Colors.transparent,
      ),
      height: responsive.hp(19),
      child: PageView.builder(
          itemCount: promociones.length,
          controller: _pageController,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              margin: EdgeInsets.symmetric(horizontal: responsive.wp(1)),
              //padding: EdgeInsets.symmetric(horizontal: responsive.wp(3)),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      PageRouteBuilder(
                        transitionDuration: const Duration(milliseconds: 400),
                        pageBuilder: (context, animation, secondaryAnimation) {
                          return DetallePromocionesLocal(
                              categoriaNombre:
                                  "${promociones[index].categoriaNombre}",
                              idcategoria: '${promociones[index].idCategoria}');
                          //return DetalleProductitos(productosData: productosData);
                        },
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                          return FadeTransition(
                            opacity: animation,
                            child: child,
                          );
                        },
                      ));

                  //Navigator.pushNamed(context, 'detallePromociones');
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: CachedNetworkImage(
                    cacheManager: CustomCacheManager(),
                   progressIndicatorBuilder: (_, url, downloadProgress) {
                          return Stack(
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
                          );
                        },
                    errorWidget: (context, url, error) => Image(
                        image: AssetImage('assets/carga_fallida.jpg'),
                        fit: BoxFit.cover),
                    imageUrl: '${promociones[index].categoriaBanner}',
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
            );
          },
          onPageChanged: (int index) {
            _currentPageNotifier.value = index;
          }),
    );
  }

  _buildCircleIndicator(
      Responsive responsive, List<CategoriaData> promociones) {
    return Positioned(
      left: 0.0,
      right: 0.0,
      bottom: responsive.hp(3.2),
      child: CirclePageIndicator(
        selectedDotColor: Colors.black,
        dotColor: Colors.grey[400],
        itemCount: promociones.length,
        currentPageNotifier: _currentPageNotifier,
      ),
    );
  }

  Widget _contenido(BuildContext context, Responsive responsive,
      RefreshController refreshController) {
    final pantallasBloc = ProviderBloc.pantallaLocal(context);
    final categoriasBloc = ProviderBloc.cat(context);
    pantallasBloc.obtenerPantallasLocal();
    categoriasBloc.obtenerCategoriasPromociones();

    return Container(
      child: StreamBuilder(
        stream: pantallasBloc.pantallasLocalStream,
        builder: (BuildContext context,
            AsyncSnapshot<List<CategoriaData>> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.length > 0) {
              return SmartRefresher(
                enablePullDown: true,
                footer: null,
                header: WaterDropHeader(
                    refresh: CircularProgressIndicator(),
                    complete: Text('Completado'),
                    waterDropColor: Colors.red),
                controller: refreshController,
                onRefresh: () {
                  _onRefresh(context);
                },
                child: ListView.builder(
                    shrinkWrap: true,
                    padding: EdgeInsets.symmetric(vertical: 0.0),
                    itemCount: snapshot.data.length + 1,
                    itemBuilder: (context, i) {
                      if (i == 0) {
                        return Column(
                          children: [
                            StreamBuilder(
                                stream:
                                    categoriasBloc.categoriasPromociionesStream,
                                builder: (context,
                                    AsyncSnapshot<List<CategoriaData>> cat) {
                                  if (cat.hasData) {
                                    if (cat.data.length > 0) {
                                      return Container(
                                        margin: EdgeInsets.only(
                                            top: responsive.hp(1)),
                                        height: responsive.hp(25),
                                        child: Stack(
                                          children: <Widget>[
                                            _buildPageView(
                                                responsive, cat.data),
                                            _buildCircleIndicator(
                                                responsive, cat.data),
                                          ],
                                        ),
                                      );
                                    } else {
                                      return Container();
                                    }
                                  } else {
                                    return Container();
                                  }
                                }),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: responsive.wp(3)),
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Text(
                                      'Carta Principal',
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontSize: responsive.ip(2.5),
                                          color: Colors.red,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      final bottomBloc =
                                          ProviderBloc.bottomLocal(context);
                                      bottomBloc.changePageLocal(1);
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: responsive.hp(1.5),
                                        vertical: responsive.hp(.5),
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius:
                                            BorderRadius.circular(100),
                                      ),
                                      child: Row(
                                        children: <Widget>[
                                          Text(
                                            'Ver más',
                                            style: TextStyle(
                                                fontSize: responsive.ip(1.7),
                                                color: Colors.white),
                                          ),
                                          Icon(
                                            Icons.arrow_forward_ios,
                                            color: Colors.white,
                                            size: responsive.ip(2.2),
                                          )
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              height: responsive.hp(1),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: responsive.hp(.5)),
                              height: responsive.hp(19),
                              child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: snapshot.data.length,
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                      onTap: () {
                                        Arguments arg = new Arguments(
                                            "${snapshot.data[index].categoriaNombre}",
                                            '${snapshot.data[index].idCategoria}');
                                        Navigator.pushNamed(
                                            context, 'productosCategoria',
                                            arguments: arg);
                                      },
                                      child: Container(
                                        width: responsive.ip(18),
                                        height: responsive.ip(15),
                                        padding: EdgeInsets.only(
                                          left: responsive.wp(3),
                                        ),
                                        margin: EdgeInsets.only(
                                          right: responsive.wp(1.5),
                                        ),
                                        child: Stack(
                                          children: <Widget>[
                                            Container(
                                              width: responsive.ip(18),
                                              height: responsive.ip(19),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                child: CachedNetworkImage(
                                                  cacheManager:
                                                      CustomCacheManager(),
                                                  progressIndicatorBuilder: (_, url, downloadProgress) {
                          return Stack(
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
                          );
                        },
                                                  errorWidget: (context, url,
                                                          error) =>
                                                      Image(
                                                          image: AssetImage(
                                                              'assets/carga_fallida.jpg'),
                                                          fit: BoxFit.cover),
                                                  imageUrl:
                                                      '${snapshot.data[index].categoriaFoto}',
                                                  imageBuilder: (context,
                                                          imageProvider) =>
                                                      Container(
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
                                              right: 0,
                                              left: 0,
                                              bottom: 0,
                                              child: Container(
                                                padding: EdgeInsets.symmetric(
                                                  vertical: responsive.hp(2),
                                                ),
                                                decoration: BoxDecoration(
                                                  color: Colors.black
                                                      .withOpacity(.5),
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                child: Text(
                                                  '${snapshot.data[index].categoriaNombre}',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize:
                                                          responsive.ip(2),
                                                      fontWeight:
                                                          FontWeight.bold),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    );
                                  }),
                            )
                          ],
                        );
                      }
                      int index = i - 1;
                      return _cart(context, responsive, snapshot.data[index]);
                    }),
              );
            } else {
              return Center(child: CupertinoActivityIndicator());
            }
          } else {
            return Center(child: CupertinoActivityIndicator());
          }
        },
      ),
    );
  }

  Widget _cart(BuildContext context, Responsive responsive,
      CategoriaData categoriaData) {
    double altoList = 35.0;
    double altoCard = 30.0;
    double anchoCard = 35.0;

    return Container(
      margin: EdgeInsets.only(bottom: responsive.hp(1)),
      width: double.infinity,
      height: responsive.ip(altoList),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: responsive.wp(3)),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    '${categoriaData.categoriaNombre}',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: responsive.ip(2.5),
                        color: Colors.red,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Arguments arg = new Arguments(
                        "${categoriaData.categoriaNombre}",
                        '${categoriaData.idCategoria}');
                    Navigator.pushNamed(context, 'productosCategoria',
                        arguments: arg);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: responsive.hp(1.5),
                      vertical: responsive.hp(.5),
                    ),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Row(
                      children: <Widget>[
                        Text(
                          'Ver más',
                          style: TextStyle(
                              fontSize: responsive.ip(1.7),
                              color: Colors.white),
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white,
                          size: responsive.ip(2.2),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: responsive.hp(1),
          ),
          Container(
            height: responsive.ip(altoCard),
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categoriaData.productos.length,
                shrinkWrap: true,
                itemBuilder: (context, i) {
                  return GestureDetector(
                    onTap: () {
                      ProductosData productosData = ProductosData();
                      productosData.idProducto =
                          categoriaData.productos[i].idProducto;

                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          transitionDuration: const Duration(milliseconds: 100),
                          pageBuilder:
                              (context, animation, secondaryAnimation) {
                            return ProductoFotoLocal(
                                cantidadItems:
                                    categoriaData.productos.length.toString(),
                                idCategoria: categoriaData.idCategoria,
                                numeroItem:
                                    categoriaData.productos[i].numeroitem);
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
                    },
                    child: Container(
                      width: responsive.ip(anchoCard),
                      height: responsive.ip(altoCard),
                      padding: EdgeInsets.only(
                        left: responsive.wp(3),
                      ),
                      margin: EdgeInsets.only(
                        right: responsive.wp(1.5),
                      ),
                      child: Stack(
                        children: <Widget>[
                          Container(
                            width: responsive.ip(anchoCard),
                            height: responsive.ip(altoCard),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: CachedNetworkImage(
                                cacheManager: CustomCacheManager(),
                                progressIndicatorBuilder: (_, url, downloadProgress) {
                          return Stack(
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
                          );
                        },
                                errorWidget: (context, url, error) => Image(
                                    image:
                                        AssetImage('assets/carga_fallida.jpg'),
                                    fit: BoxFit.cover),
                                imageUrl:
                                    '${categoriaData.productos[i].productoFoto}',
                                imageBuilder: (context, imageProvider) =>
                                    Container(
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
                                '${categoriaData.productos[i].productoNombre}',
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
                  );
                }),
          )
        ],
      ),
    );
  }
}
