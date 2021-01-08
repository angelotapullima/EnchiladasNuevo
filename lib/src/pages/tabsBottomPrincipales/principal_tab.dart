import 'package:cached_network_image/cached_network_image.dart';
import 'package:enchiladasapp/src/api/categorias_api.dart';
import 'package:enchiladasapp/src/api/configuracion_api.dart';
import 'package:enchiladasapp/src/bloc/cerrar_publicidad_bloc.dart';
import 'package:enchiladasapp/src/bloc/provider.dart';
import 'package:enchiladasapp/src/models/arguments.dart';
import 'package:enchiladasapp/src/models/categoria_model.dart';
import 'package:enchiladasapp/src/models/pantalla_model.dart';
import 'package:enchiladasapp/src/models/productos_model.dart';
import 'package:enchiladasapp/src/models/publicidad_model.dart';
import 'package:enchiladasapp/src/pages/categorias_especiales.dart';
import 'package:enchiladasapp/src/pages/detalle_productos.dart';
import 'package:enchiladasapp/src/pages/detalle_productos_destacado.dart';
import 'package:enchiladasapp/src/utils/circle.dart';
import 'package:enchiladasapp/src/utils/responsive.dart';
import 'package:enchiladasapp/src/utils/preferencias_usuario.dart';
import 'package:enchiladasapp/src/widgets/customCacheManager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:enchiladasapp/src/search/search_delegate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_view_indicators/circle_page_indicator.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class PrincipalTab extends StatelessWidget {
  final _refreshController = RefreshController(initialRefresh: false);
  final _pageController = PageController(viewportFraction: 0.9, initialPage: 1);
  final _currentPageNotifier = ValueNotifier<int>(1);

  void _onRefresh(BuildContext context) async {
    print('_onRefresh pantalla');
    final pantallasBloc = ProviderBloc.pantalla(context);
    final categoriasBloc = ProviderBloc.cat(context);

    pantallasBloc.obtenerPantallas();
    final categoriasApi = CategoriasApi();
    await categoriasApi.obtenerAmbos();
    pantallasBloc.obtenerPantallas();
    categoriasBloc.obtenerCategoriasPromociones();
    _refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    final Responsive responsive = new Responsive.of(context);
    final usuarioBloc = ProviderBloc.user(context);
    usuarioBloc.obtenerUsuario();

    final publicidadBloc = ProviderBloc.publi(context);
    publicidadBloc.obtenerPublicidad();



    final provider = Provider.of<PrincipalChangeBloc>(context, listen: false);

    return Scaffold(
      body: StreamBuilder(
          stream: publicidadBloc.publicidadStream,
          builder: (context, AsyncSnapshot<List<PublicidadModel>> snapshot) {
            bool pase = false;
            if (snapshot.hasData) {
              if (snapshot.data.length > 0) {
                if (snapshot.data[0].publicidadEstado == '1') {
                  provider.setIndex(true);
                }
                pase = true;
              }
            }
            return Stack(
              children: [
                _inicio(context, responsive, _refreshController),
                (pase)
                    ? ValueListenableBuilder(
                        valueListenable: provider.cargando,
                        builder:
                            (BuildContext context, bool data, Widget child) {
                          return (data)
                              ? PublicidadDialog(
                                  publicidadModel: snapshot.data[0],
                                )
                              : Container();
                        })
                    /*  ? (provider.cargando.value)
                        ? PublicidadDialog(
                            publicidadModel: snapshot.data[0],
                          )
                        : Container() */
                    : Container()
              ],
            );
          }),
    );
  }

  Widget getAlias(String nombre, Responsive responsive) {
    final List<String> tmp = nombre.split(" ");

    String alias = "";
    if (tmp.length > 0) {
      alias = tmp[0][0];
      if (tmp.length == 2) {
        alias += tmp[1][0];
      }
    }

    return Center(
      child: Text(
        alias,
        style: TextStyle(
          fontSize: responsive.ip(7),
        ),
      ),
    );
  }

  Widget _inicio(BuildContext context, Responsive responsive,
      RefreshController refreshController) {
    final prefs = new Preferences();
    var nombre, alias;

    if (prefs.email != "" && prefs.email != null) {
      nombre = prefs.personName;
      final List<String> tmp = nombre.split(" ");
      final algo = tmp[0];
      alias = "Hola $algo";
    } else {
      alias = 'Bienvenido';
    }

    final noLogin = IconButton(
      icon: Icon(
        Icons.person,
        color: Colors.white,
        size: responsive.ip(2.3),
      ),
      onPressed: () {
        Navigator.pushNamedAndRemoveUntil(context, 'login', (route) => false);
      },
    );
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
            padding: EdgeInsets.symmetric(
              horizontal: responsive.hp(2),
            ),
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
                          '$alias',
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
                            delegate: DataSearch(hintText: 'Buscar'),
                          );
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
                      (prefs.email != "" && prefs.email != null)
                          ? (prefs.foto != null)
                              ? InkWell(
                                  onTap: () {
                                    final bottomBloc =
                                        ProviderBloc.bottom(context);

                                    bottomBloc.changePage(4);
                                  },
                                  child: CircleAvatar(
                                    radius: responsive.ip(2),
                                    child: ClipOval(
                                      child: Image.network(
                                        prefs.foto,
                                        width: responsive.ip(4),
                                        height: responsive.ip(4),
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),
                                )
                              : InkWell(
                                  onTap: () {
                                    final bottomBloc =
                                        ProviderBloc.bottom(context);

                                    bottomBloc.changePage(4);
                                  },
                                  child: getAlias(nombre, responsive),
                                )
                          : CircleContainer(
                              radius: responsive.ip(2.3),
                              color: Colors.red[800],
                              widget: noLogin,
                            )
                    ],
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: _contenido(context, responsive, refreshController),
          )
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
                  Arguments arg = new Arguments(
                      "${promociones[index].categoriaNombre}",
                      '${promociones[index].idCategoria}');
                  Navigator.pushNamed(context, 'detallePromociones',
                      arguments: arg);
                  //Navigator.pushNamed(context, 'detallePromociones');
                },
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
    final pantallasBloc = ProviderBloc.pantalla(context);
    final categoriasBloc = ProviderBloc.cat(context);
    pantallasBloc.obtenerPantallas();
    categoriasBloc.obtenerCategoriasPromociones();

    return Container(
      child: StreamBuilder(
        stream: pantallasBloc.pantallasStream,
        builder: (BuildContext context,
            AsyncSnapshot<List<PantallaModel>> snapshot) {
          final configuracionApi = ConfiguracionApi();
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
                        return StreamBuilder(
                            stream: categoriasBloc.categoriasPromociionesStream,
                            builder: (context,
                                AsyncSnapshot<List<CategoriaData>> cat) {
                              if (cat.hasData) {
                                if (cat.data.length > 0) {
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: responsive.wp(3),
                                        ),
                                        child: Text(
                                          'Promociones',
                                          style: GoogleFonts.montserrat(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w600,
                                            fontSize: responsive.ip(2.5),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(
                                          top: responsive.hp(1),
                                        ),
                                        height: responsive.hp(25),
                                        child: Stack(
                                          children: <Widget>[
                                            _buildPageView(
                                                responsive, cat.data),
                                            _buildCircleIndicator(
                                                responsive, cat.data),
                                          ],
                                        ),
                                      ),
                                      ProductosDestacados(),
                                      SizedBox(height: responsive.hp(1))
                                    ],
                                  );
                                } else {
                                  return Container();
                                }
                              } else {
                                return Container();
                              }
                            });
                      }
                      int index = i - 1;
                      return _cart(context, responsive, snapshot.data[index]);
                    }),
              );
            } else {
              configuracionApi.configuracion();
              return Center(
                child: CupertinoActivityIndicator(),
              );
            }
          } else {
            configuracionApi.configuracion();
            return Center(
              child: CupertinoActivityIndicator(),
            );
          }
        },
      ),
    );
  }

  Widget _cart(BuildContext context, Responsive responsive,
      PantallaModel pantallaModel) {
    double altoList = 35.0;
    double altoCard = 30.0;
    double anchoCard = 35.0;
    BoxFit boxfit;
    String tipo;
    if (pantallaModel.idPantalla == '2') {
      //market
      altoList = 28.0;
      altoCard = 23.0;
      anchoCard = 25;

      boxfit = BoxFit.cover;

      tipo = 'categoria';
    } else if (pantallaModel.idPantalla == '1') {
      //carta Principal
      altoList = 20.0;
      altoCard = 15.0;
      anchoCard = 18;

      tipo = 'categoria';

      boxfit = BoxFit.fill;
    } else if (pantallaModel.idPantalla == '3') {
      //puzzle
      altoList = 31.0;
      altoCard = 26.0;
      anchoCard = 20;

      boxfit = BoxFit.fill;

      tipo = 'puzzle';
    } else {
      boxfit = BoxFit.fill;
      tipo = 'producto';
    }

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
                    '${pantallaModel.pantallaNombre}',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: responsive.ip(2.5),
                        color: Colors.red,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    if (pantallaModel.idPantalla == '1') {
                      final bottomBloc = ProviderBloc.bottom(context);
                      bottomBloc.changePage(2);
                    } else if (pantallaModel.idPantalla == '2') {
                      Navigator.pushNamed(context, 'market');
                    } else if (pantallaModel.idPantalla == '3') {
                      Navigator.pushNamed(context, 'HomePuzzle');
                    } else {
                      Arguments arg = new Arguments(
                          "${pantallaModel.pantallaNombre}",
                          '${pantallaModel.pantallCategoria}');

                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          transitionDuration: const Duration(milliseconds: 100),
                          pageBuilder:
                              (context, animation, secondaryAnimation) {
                            return CategoriasEspecialesPage(
                              arg: arg,
                            );
                            //return DetalleProductitos(productosData: productosData);
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
                    }
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
                itemCount: pantallaModel.items.length,
                shrinkWrap: true,
                itemBuilder: (context, i) {
                  if (i == pantallaModel.items.length - 1) {
                    return GestureDetector(
                      onTap: () {
                        if (pantallaModel.idPantalla == '1') {
                          final bottomBloc = ProviderBloc.bottom(context);
                          bottomBloc.changePage(2);
                        } else if (pantallaModel.idPantalla == '2') {
                          Navigator.pushNamed(context, 'market');
                        } else if (pantallaModel.idPantalla == '3') {
                          Navigator.pushNamed(context, 'HomePuzzle');
                        } else {
                          Arguments arg = new Arguments(
                              "${pantallaModel.pantallaNombre}",
                              '${pantallaModel.pantallCategoria}');

                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              transitionDuration:
                                  const Duration(milliseconds: 100),
                              pageBuilder:
                                  (context, animation, secondaryAnimation) {
                                return CategoriasEspecialesPage(
                                  arg: arg,
                                );
                                //return DetalleProductitos(productosData: productosData);
                              },
                              transitionsBuilder: (context, animation,
                                  secondaryAnimation, child) {
                                return FadeTransition(
                                  opacity: animation,
                                  child: child,
                                );
                              },
                            ),
                          );
                        }
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
                                  placeholder: (context, url) => Image(
                                      image:
                                          AssetImage('assets/jar-loading.gif'),
                                      fit: BoxFit.cover),
                                  errorWidget: (context, url, error) => Image(
                                      image: AssetImage(
                                          'assets/carga_fallida.jpg'),
                                      fit: BoxFit.cover),
                                  imageUrl:
                                      '${pantallaModel.items[i].fotoItem}',
                                  imageBuilder: (context, imageProvider) =>
                                      Container(
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: imageProvider,
                                        fit: boxfit,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                vertical: responsive.hp(2),
                              ),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(.5),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: Text(
                                  'Ver más',
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
                  }
                  return GestureDetector(
                    onTap: () {
                      if (tipo == 'categoria') {
                        Arguments arg = new Arguments(
                            "${pantallaModel.items[i].nombreItem}",
                            '${pantallaModel.items[i].idCategoria}');

                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            transitionDuration:
                                const Duration(milliseconds: 100),
                            pageBuilder:
                                (context, animation, secondaryAnimation) {
                              return CategoriasEspecialesPage(
                                arg: arg,
                              );
                              //return DetalleProductitos(productosData: productosData);
                            },
                            transitionsBuilder: (context, animation,
                                secondaryAnimation, child) {
                              return FadeTransition(
                                opacity: animation,
                                child: child,
                              );
                            },
                          ),
                        );
                      } else if (tipo == 'producto') {
                        ProductosData productosData = ProductosData();
                        productosData.idProducto =
                            pantallaModel.items[i].idProducto;

                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            transitionDuration:
                                const Duration(milliseconds: 100),
                            pageBuilder:
                                (context, animation, secondaryAnimation) {
                              return SliderDetalleProductos(
                                numeroItem: pantallaModel.items[i].numeroItem,
                                idCategoria: pantallaModel.items[i].idCategoria,
                                cantidadItems:
                                    pantallaModel.items[i].cantidadItems,
                              );
                              //return DetalleProductitos(productosData: productosData);
                            },
                            transitionsBuilder: (context, animation,
                                secondaryAnimation, child) {
                              return FadeTransition(
                                opacity: animation,
                                child: child,
                              );
                            },
                          ),
                        );
                      } else if (tipo == 'puzzle') {
                        Navigator.pushNamed(context, 'HomePuzzle');
                      }
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
                                placeholder: (context, url) => Image(
                                    image: AssetImage('assets/jar-loading.gif'),
                                    fit: BoxFit.cover),
                                errorWidget: (context, url, error) => Image(
                                    image:
                                        AssetImage('assets/carga_fallida.jpg'),
                                    fit: BoxFit.cover),
                                imageUrl: '${pantallaModel.items[i].fotoItem}',
                                imageBuilder: (context, imageProvider) =>
                                    Container(
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: imageProvider,
                                      fit: boxfit,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          (tipo == 'producto')
                              ? ('${pantallaModel.items[i].productoNuevo}' ==
                                      '1')
                                  ? Positioned(
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
                                            fontSize: responsive.ip(1.7),
                                          ),
                                        ),
                                      ),
                                    )
                                  : Container()
                              : Container(),
                          (tipo != 'puzzle')
                              ? Positioned(
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
                                      '${pantallaModel.items[i].nombreItem}',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: responsive.ip(2),
                                          fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                )
                              : Container(),
                        ],
                      ),
                    ),
                  );
                }),
          )
        ],
      ),
    ) 
    
        ;
  }
}

class ProductosDestacados extends StatelessWidget {
  const ProductosDestacados({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);

    final productosDestacadosBloc = ProviderBloc.proDestacados(context);
    productosDestacadosBloc.obtenerProductosDestacados();

    return StreamBuilder(
        stream: productosDestacadosBloc.productosDestacadosStream,
        builder: (context, AsyncSnapshot<List<ProductosData>> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.length > 0) {
              return Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: responsive.wp(3)),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            'Destacados',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: responsive.ip(2.5),
                                color: Colors.red,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {},
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
                    height: responsive.hp(19),
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                transitionDuration:
                                    const Duration(milliseconds: 100),
                                pageBuilder:
                                    (context, animation, secondaryAnimation) {
                                  return SliderDetalleProductosDestacados(
                                    idCategoria:
                                        snapshot.data[index].idCategoria,
                                    numeroItem: snapshot.data[index].numeroitem,
                                    items: snapshot.data,
                                  );
                                  /* return DetalleProductitos(
                                  productosData: snapshot.data[index]); */
                                },
                                transitionsBuilder: (context, animation,
                                    secondaryAnimation, child) {
                                  return FadeTransition(
                                    opacity: animation,
                                    child: child,
                                  );
                                },
                              ),
                            );
                          },
                          child: Container(
                            width: responsive.ip(18),
                            height: responsive.ip(18),
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
                                  height: responsive.ip(18),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: CachedNetworkImage(
                                      cacheManager: CustomCacheManager(),
                                      placeholder: (context, url) => Image(
                                          image: AssetImage(
                                              'assets/jar-loading.gif'),
                                          fit: BoxFit.cover),
                                      errorWidget: (context, url, error) =>
                                          Image(
                                              image: AssetImage(
                                                  'assets/carga_fallida.jpg'),
                                              fit: BoxFit.cover),
                                      imageUrl:
                                          '${snapshot.data[index].productoFoto}',
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
                                  bottom: 0,
                                  left: 0,
                                  right: 0,
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      vertical: responsive.hp(1),
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(.5),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Center(
                                      child: Text(
                                        '${snapshot.data[index].productoNombre}',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: responsive.ip(2),
                                            fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                ),
                                ('${snapshot.data[index].productoNuevo}' == '1')
                                    ? Positioned(
                                        /*  left: responsive.wp(1),
                                        top: responsive.hp(.5), */
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: responsive.wp(3),
                                            vertical: responsive.wp(.2),
                                          ),
                                          decoration: BoxDecoration(
                                              /* borderRadius:
                                                  BorderRadius.circular(10), */
                                              color: Colors.red),
                                          child: Text(
                                            'Nuevo',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: responsive.ip(1.4),
                                            ),
                                          ),
                                        ),
                                      )
                                    : Container()
                              ],
                            ),
                          ),
                        );
                      },
                      itemCount: snapshot.data.length,
                    ),
                  ),
                ],
              );
            } else {
              return Container();
            }
          } else {
            return Center(
              child: CupertinoActivityIndicator(),
            );
          }
        });
  }
}

class PublicidadDialog extends StatelessWidget {
  final PublicidadModel publicidadModel;
  const PublicidadDialog({Key key, @required this.publicidadModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PrincipalChangeBloc>(context, listen: false);

    final responsive = Responsive.of(context);
    return Container(
      color: Colors.black.withOpacity(.4),
      padding: EdgeInsets.symmetric(
        horizontal: responsive.wp(7),
        vertical: responsive.hp(7),
      ),
      height: double.infinity,
      width: double.infinity,
      child: Stack(
        children: [
          GestureDetector(
            onTap: () {
              if (publicidadModel.publicidadTipo == 'producto') {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    transitionDuration: const Duration(milliseconds: 100),
                    pageBuilder: (context, animation, secondaryAnimation) {
                      ProductosData producto = ProductosData();
                      producto.idProducto = publicidadModel.idRelacionado;
                      return DetalleProductitoss(
                        productosData: producto,
                        mostrarback: true,
                      );
                      //return DetalleProductitos(productosData: productosData);
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
              } else {
                Arguments arg = new Arguments(
                    "Promociones", '${publicidadModel.idRelacionado}');

                Navigator.push(
                  context,
                  PageRouteBuilder(
                    transitionDuration: const Duration(milliseconds: 100),
                    pageBuilder: (context, animation, secondaryAnimation) {
                      return CategoriasEspecialesPage(
                        arg: arg,
                      );
                      //return DetalleProductitos(productosData: productosData);
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
              }
            },
            child: Container(
              height: double.infinity,
              width: double.infinity,
              child: CachedNetworkImage(
                cacheManager: CustomCacheManager(),
                placeholder: (context, url) => Image(
                    image: AssetImage('assets/jar-loading.gif'),
                    fit: BoxFit.cover),
                errorWidget: (context, url, error) => Image(
                    image: AssetImage('assets/carga_fallida.jpg'),
                    fit: BoxFit.cover),
                imageUrl: '${publicidadModel.publicidadImagen}',
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
            right: 0,
            top: 0,
            child: GestureDetector(
              onTap: () {
                provider.setIndex(false);
              },
              child: Container(
                transform: Matrix4.translationValues(
                    responsive.ip(1), -responsive.ip(1.3), 0),
                child: CircleAvatar(
                  radius: responsive.ip(2),
                  child: Icon(Icons.close),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
