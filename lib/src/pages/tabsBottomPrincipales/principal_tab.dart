import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:enchiladasapp/src/api/categorias_api.dart';
import 'package:enchiladasapp/src/api/configuracion_api.dart';
import 'package:enchiladasapp/src/bloc/cerrar_publicidad_bloc.dart';
import 'package:enchiladasapp/src/bloc/pantalla_bloc.dart';
import 'package:enchiladasapp/src/bloc/provider.dart';
import 'package:enchiladasapp/src/models/arguments.dart';
import 'package:enchiladasapp/src/models/carrito_model.dart';
import 'package:enchiladasapp/src/models/categoria_model.dart';
import 'package:enchiladasapp/src/models/pantalla_model.dart';
import 'package:enchiladasapp/src/models/productos_model.dart';
import 'package:enchiladasapp/src/models/publicidad_model.dart';
import 'package:enchiladasapp/src/pages/categorias_especiales.dart';
import 'package:enchiladasapp/src/pages/detalle_producto2.dart';
import 'package:enchiladasapp/src/pages/search.dart';
import 'package:enchiladasapp/src/pages/tabsBottomPrincipales/categoria2.dart';
import 'package:enchiladasapp/src/pages/tabsBottomPrincipales/detalle_categoria.dart';
import 'package:enchiladasapp/src/utils/circle.dart';
import 'package:enchiladasapp/src/utils/responsive.dart';
import 'package:enchiladasapp/src/utils/preferencias_usuario.dart';
import 'package:enchiladasapp/src/utils/sliver_header_delegate.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter_svg/svg.dart';

class PrincipalTab extends StatelessWidget {
  final _refreshController = RefreshController(initialRefresh: false);
  final _currentPageNotifier = ValueNotifier<int>(1);

  void _onRefresh(BuildContext context) async {
    print('_onRefresh pantalla');
    final prefs = new Preferences();
    final pantallasBloc = ProviderBloc.pantalla(context);
    final categoriasBloc = ProviderBloc.cat(context);

    final categoriasApi = CategoriasApi();
    await categoriasApi.obtenerAmbos(context);
    pantallasBloc.obtenerPantallas();
    if (prefs.tipoCategoria == '1') {
      categoriasBloc.obtenerCategoriasPromociones(prefs.tipoCategoriaNumero);
    } else {
      categoriasBloc.obtenerCategoriasPromocionesUnidas(prefs.tipoCategoriaNumero);
    }

    _refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    final Responsive responsive = new Responsive.of(context);

    final prefs = new Preferences();
    final usuarioBloc = ProviderBloc.user(context);
    usuarioBloc.obtenerUsuario();

    final publicidadBloc = ProviderBloc.publi(context);
    publicidadBloc.obtenerPublicidad();

    final pantallasBloc = ProviderBloc.pantalla(context);
    final categoriasBloc = ProviderBloc.cat(context);

    pantallasBloc.obtenerPantallas();

    if (prefs.tipoCategoria == '1') {
      categoriasBloc.obtenerCategoriasPromociones(prefs.tipoCategoriaNumero);
      categoriasBloc.obtenerCategoriasPorTipo(prefs.tipoCategoriaNumero);
    } else {
      categoriasBloc.obtenerCategoriasPromocionesUnidas(prefs.tipoCategoriaNumero);
      categoriasBloc.obtenerCategoriasPorTipoUnidos(prefs.tipoCategoriaNumero);
    }

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
              _inicio(responsive, pantallasBloc, categoriasBloc, _refreshController),
              (pase)
                  ? ValueListenableBuilder(
                      valueListenable: provider.cargando,
                      builder: (BuildContext context, bool data, Widget child) {
                        return (data)
                            ? PublicidadDialog(
                                publicidadModel: snapshot.data[0],
                              )
                            : Container();
                      },
                    )
                  : Container()
            ],
          );
        },
      ),
    );
  }

  Widget _inicio(Responsive responsive, PantallaBloc pantallasBloc, CategoriasBloc categoriasBloc, RefreshController refreshController) {
    return StreamBuilder(
      stream: pantallasBloc.pantallasStream,
      builder: (BuildContext context, AsyncSnapshot<List<PantallaModel>> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.length > 0) {
            return SmartRefresher(
              enablePullDown: true,
              footer: null,
              header: WaterDropHeader(
                refresh: CircularProgressIndicator(),
                complete: Text('Completado'),
                waterDropColor: Colors.red,
              ),
              controller: refreshController,
              onRefresh: () {
                _onRefresh(context);
              },
              child: CustomScrollView(
                slivers: [
                  CustomHeaderPrincipal1(),
                  SliverPadding(
                    padding: EdgeInsets.symmetric(horizontal: 0),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                          if (index == 0) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                StreamBuilder(
                                  stream: categoriasBloc.categoriasPromociionesStream,
                                  builder: (context, AsyncSnapshot<List<CategoriaData>> cat) {
                                    if (cat.hasData) {
                                      if (cat.data.length > 0) {
                                        return Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              height: responsive.hp(1),
                                            ),
                                            CarouselSlider.builder(
                                              itemCount: cat.data.length,
                                              itemBuilder: (context, x, y) {
                                                return InkWell(
                                                  onTap: () {
                                                    Arguments arg = new Arguments("${cat.data[x].categoriaNombre}", '${cat.data[x].idCategoria}');
                                                    Navigator.pushNamed(context, 'detallePromociones', arguments: arg);
                                                    //Navigator.pushNamed(context, 'detallePromociones');
                                                  },
                                                  child: Container(
                                                    margin: EdgeInsets.symmetric(horizontal: responsive.wp(1), vertical: responsive.hp(1)),
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(10.0),
                                                    ),
                                                    height: responsive.hp(20),
                                                    child: ClipRRect(
                                                      borderRadius: BorderRadius.circular(10.0),
                                                      child: CachedNetworkImage(
                                                        placeholder: (context, url) => Container(
                                                            width: double.infinity,
                                                            height: double.infinity,
                                                            child: Center(
                                                              child: CupertinoActivityIndicator(),
                                                            )),
                                                        errorWidget: (context, url, error) => Container(
                                                          width: double.infinity,
                                                          height: double.infinity,
                                                          child: Center(
                                                            child: Icon(Icons.error),
                                                          ),
                                                        ),
                                                        imageUrl: '${cat.data[x].categoriaBanner}',
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
                                              options: CarouselOptions(
                                                  height: responsive.hp(20),
                                                  onPageChanged: (index, page) {
                                                    _currentPageNotifier.value = index;
                                                  },
                                                  enlargeCenterPage: true,
                                                  autoPlay: true,
                                                  autoPlayCurve: Curves.fastOutSlowIn,
                                                  autoPlayInterval: Duration(seconds: 6),
                                                  autoPlayAnimationDuration: Duration(milliseconds: 2000),
                                                  viewportFraction: 0.85),
                                            ),
                                            SizedBox(
                                              height: responsive.hp(1),
                                            ),
                                            ValueListenableBuilder(
                                                valueListenable: _currentPageNotifier,
                                                builder: (BuildContext context, int data, Widget child) {
                                                  return Container(
                                                    margin: EdgeInsets.symmetric(
                                                      horizontal: responsive.wp(10),
                                                    ),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: List.generate(
                                                        cat.data.length,
                                                        (index) => Container(
                                                          width: (_currentPageNotifier.value >= index - 0.5 && _currentPageNotifier.value < index + 0.5) ? 10 : 5,
                                                          height: 5,
                                                          margin: EdgeInsets.symmetric(horizontal: 5),
                                                          decoration: BoxDecoration(
                                                            borderRadius: (_currentPageNotifier.value >= index - 0.5 && _currentPageNotifier.value < index + 0.5)
                                                                ? BorderRadius.circular(8)
                                                                : BorderRadius.circular(10),
                                                            color: (_currentPageNotifier.value >= index - 0.5 && _currentPageNotifier.value < index + 0.5)
                                                                ? Colors.green
                                                                : Colors.grey,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                }),
                                          ],
                                        );
                                      } else {
                                        return Container();
                                      }
                                    } else {
                                      return Container();
                                    }
                                  },
                                ),
                                SizedBox(
                                  height: responsive.hp(2),
                                ),
                                StreamBuilder(
                                    stream: categoriasBloc.categoriasPantallaInicialStream,
                                    builder: (context, AsyncSnapshot<List<CategoriaData>> snapshot) {
                                      if (snapshot.hasData) {
                                        if (snapshot.data.length > 0) {
                                          return Container(
                                            height: responsive.hp(11),
                                            child: ListView.builder(
                                              itemCount: snapshot.data.length + 1,
                                              scrollDirection: Axis.horizontal,
                                              itemBuilder: (context, index) {
                                                if (index == 0) {
                                                  return InkWell(
                                                    onTap: () {
                                                      Navigator.of(context).push(
                                                        PageRouteBuilder(
                                                          pageBuilder: (context, animation, secondaryAnimation) {
                                                            return Categoria2();
                                                          },
                                                          transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                                            var begin = Offset(0.0, 1.0);
                                                            var end = Offset.zero;
                                                            var curve = Curves.ease;

                                                            var tween = Tween(begin: begin, end: end).chain(
                                                              CurveTween(curve: curve),
                                                            );

                                                            return SlideTransition(
                                                              position: animation.drive(tween),
                                                              child: child,
                                                            );
                                                          },
                                                        ),
                                                      );
                                                    },
                                                    child: Container(
                                                      width: responsive.hp(9),
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        children: [
                                                          CircleAvatar(
                                                            backgroundColor: Colors.red,
                                                            radius: responsive.ip(2.5),
                                                            child: Center(
                                                              child: Icon(
                                                                Ionicons.ios_alert,
                                                                color: Colors.white,
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: responsive.hp(.5),
                                                          ),
                                                          Text(
                                                            'Categorías',
                                                            style: TextStyle(
                                                              fontSize: responsive.ip(1.2),
                                                              fontWeight: FontWeight.w600,
                                                              color: Colors.grey[800],
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                }
                                                index = index - 1;

                                                return InkWell(
                                                  onTap: () {
                                                    Navigator.of(context).push(
                                                      PageRouteBuilder(
                                                        pageBuilder: (context, animation, secondaryAnimation) {
                                                          return Detallecategoria(
                                                            idCategoria: '${snapshot.data[index].idCategoria}',
                                                            categoriaNombre: '${snapshot.data[index].categoriaNombre}',
                                                            categoriaIcono: '${snapshot.data[index].categoriaIcono}',
                                                          );
                                                        },
                                                        transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                                          var begin = Offset(0.0, 1.0);
                                                          var end = Offset.zero;
                                                          var curve = Curves.ease;

                                                          var tween = Tween(begin: begin, end: end).chain(
                                                            CurveTween(curve: curve),
                                                          );

                                                          return SlideTransition(
                                                            position: animation.drive(tween),
                                                            child: child,
                                                          );
                                                        },
                                                      ),
                                                    );
                                                  },
                                                  child: Container(
                                                    width: responsive.hp(9),
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: [
                                                        Container(
                                                          height: responsive.ip(5),
                                                          width: responsive.ip(5),
                                                          child: SvgPicture.network(
                                                            '${snapshot.data[index].categoriaIcono}',
                                                            semanticsLabel: 'A shark?!',
                                                            //color:Colors.black,
                                                            placeholderBuilder: (BuildContext context) =>
                                                                Container(padding: const EdgeInsets.all(30.0), child: const CircularProgressIndicator()),
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: responsive.hp(.5),
                                                        ),
                                                        Padding(
                                                          padding: EdgeInsets.symmetric(
                                                            horizontal: responsive.wp(1),
                                                          ),
                                                          child: Text(
                                                            '${snapshot.data[index].categoriaNombre}',
                                                            maxLines: 2,
                                                            textAlign: TextAlign.center,
                                                            style: TextStyle(
                                                              fontSize: responsive.ip(1.2),
                                                              fontWeight: FontWeight.w600,
                                                              color: ('${snapshot.data[index].categoriaMostrarApp}' =='1')?Colors.grey[800]:Colors.red,
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          );
                                        } else {
                                          return Container();
                                        }
                                      } else {
                                        return Container();
                                      }
                                    }),
                              ],
                            );
                          }

                          if (index == snapshot.data.length) {
                            return SizedBox(
                              height: responsive.hp(1),
                            );
                          }
                          return _cart(context, responsive, snapshot.data[index]);
                        },
                        childCount: snapshot.data.length + 1,
                      ),
                    ),
                  )
                ],
              ),
            );
          } else {
            final configuracionApi = ConfiguracionApi();
            configuracionApi.configuracion();
            return Center(
              child: CupertinoActivityIndicator(),
            );
          }
        } else {
          final configuracionApi = ConfiguracionApi();
          configuracionApi.configuracion();
          return Center(
            child: CupertinoActivityIndicator(),
          );
        }
      },
    );
  }

  Widget _cart(BuildContext context, Responsive responsive, PantallaModel pantallaModel) {
    double altoCard = 30.0;
    double anchoCard = 35.0;
    BoxFit boxfit;
    String tipo;
    if (pantallaModel.idPantalla == '2') {
      //market

      altoCard = 23.0;
      anchoCard = 25;

      boxfit = BoxFit.cover;

      tipo = 'categoria';
    } else if (pantallaModel.idPantalla == '1') {
      //carta Principal

      altoCard = 15.0;
      anchoCard = 18;

      tipo = 'categoria';

      boxfit = BoxFit.fill;
    } else if (pantallaModel.idPantalla == '4') {
      //carta Principal

      altoCard = 15.0;
      anchoCard = 18;

      tipo = 'categoria';

      boxfit = BoxFit.fill;
    } else if (pantallaModel.idPantalla == '5') {
      //carta Principal

      altoCard = 15.0;
      anchoCard = 18;

      tipo = 'categoria';

      boxfit = BoxFit.fill;
    } else {
      boxfit = BoxFit.fill;
      tipo = 'producto';
    }

    return ListView.builder(
      padding: EdgeInsets.only(
        top: responsive.hp(1),
      ),
      physics: ClampingScrollPhysics(),
      shrinkWrap: true,
      itemCount: 2,
      itemBuilder: (context, j) {
        if (j == 0) {
          return Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              '${pantallaModel.pantallaNombre}',
              style: TextStyle(
                color: Colors.black,
                fontFamily: 'Aeonik',
                fontSize: 19,
              ),
            ),
          );
        }
        return GridView.builder(
          padding: EdgeInsets.zero,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            childAspectRatio: .9,
            crossAxisCount: 2,
            mainAxisSpacing: responsive.hp(1),
          ),
          itemCount: (pantallaModel.items.length > 3) ? 4 : pantallaModel.items.length,
          physics: ClampingScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, i) {
            return GestureDetector(
              onTap: () {
                if (pantallaModel.idPantalla == '1') {
                  final bottomBloc = ProviderBloc.bottom(context);
                  bottomBloc.changePage(2);
                } else if (pantallaModel.idPantalla == '5') {
                  /* Navigator.push(
                    context,
                    PageRouteBuilder(
                      transitionDuration: const Duration(milliseconds: 400),
                      pageBuilder: (context, animation, secondaryAnimation) {
                        return CategoriasPorTipo(
                          nombreTipo: 'Var 247',
                          tipo: '4',
                        );
                        //return DetalleProductitos(productosData: productosData);
                      },
                      transitionsBuilder: (context, animation, secondaryAnimation, child) {
                        return FadeTransition(
                          opacity: animation,
                          child: child,
                        );
                      },
                    ),
                  ); */
                } else if (pantallaModel.idPantalla == '4') {
                  /* Navigator.push(
                    context,
                    PageRouteBuilder(
                      transitionDuration: const Duration(milliseconds: 400),
                      pageBuilder: (context, animation, secondaryAnimation) {
                        return CategoriasPorTipo(
                          nombreTipo: 'Café 247',
                          tipo: '3',
                        );
                        //return DetalleProductitos(productosData: productosData);
                      },
                      transitionsBuilder: (context, animation, secondaryAnimation, child) {
                        return FadeTransition(
                          opacity: animation,
                          child: child,
                        );
                      },
                    ),
                  );
                */
                } else {
                  Arguments arg = new Arguments("${pantallaModel.pantallaNombre}", '${pantallaModel.pantallCategoria}');

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
                      transitionsBuilder: (context, animation, secondaryAnimation, child) {
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
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  width: responsive.ip(anchoCard),
                  //height: (tipo=='puzzle')?responsive.hp(20):responsive.ip(altoCard),
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
                            width: double.infinity,
                            height: (tipo == 'puzzle')
                                ? responsive.hp(25)
                                : (tipo == 'producto')
                                    ? responsive.ip(altoCard) - responsive.ip(15)
                                    : responsive.ip(altoCard) - responsive.ip(0),
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
                                          child: (downloadProgress.progress != null) ? Text('${(downloadProgress.progress * 100).toInt().toString()}%') : Container(),
                                        )
                                      ],
                                    ),
                                  );
                                },
                                errorWidget: (context, url, error) => Image(image: AssetImage('assets/carga_fallida.jpg'), fit: BoxFit.cover),
                                imageUrl: '${pantallaModel.items[i].fotoItem}',
                                imageBuilder: (context, imageProvider) => Container(
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
                              ? ('${pantallaModel.items[i].productoNuevo}' != '1')
                                  ? Positioned(
                                      top: 5,
                                      left: 0,
                                      right: 0,
                                      /*  left: responsive.wp(1),
                                    top: responsive.hp(.5), */
                                      child: Row(
                                        children: [
                                          Container(
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
                                          ),
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
                                  : Container()
                              : Container(),
                        ],
                      ),
                      (tipo == 'puzzle')
                          ? Container()
                          : Container(
                              padding: EdgeInsets.only(
                                right: responsive.wp(1.5),
                                left: responsive.wp(1.5),
                              ),
                              height: responsive.hp(3),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'S/ 23',
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontFamily: 'Aeonik',
                                      fontSize: 17,
                                    ),
                                  ),
                                  Container(
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
                                  ),
                                ],
                              ),
                            ),
                      (tipo == 'puzzle')
                          ? Container()
                          : Padding(
                              padding: EdgeInsets.only(
                                right: responsive.wp(1.5),
                                left: responsive.wp(1.5),
                              ),
                              child: Text(
                                '${pantallaModel.items[i].nombreItem}',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'Aeonik',
                                  fontSize: 14,
                                ),
                              ),
                            ),
                    ],
                  )),
            );
          },
        );
      },
    );
  }
}

class CustomHeaderPrincipal1 extends StatefulWidget {
  const CustomHeaderPrincipal1({
    Key key,
  }) : super(key: key);

  @override
  _CustomHeaderPrincipal1State createState() => _CustomHeaderPrincipal1State();
}

class _CustomHeaderPrincipal1State extends State<CustomHeaderPrincipal1> {
  //String saldoActual, comisionActual;

  TextEditingController inputfieldDateController = new TextEditingController();

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

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    inputfieldDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);
    final carritoBloc = ProviderBloc.carrito(context);
    carritoBloc.obtenerCarrito();

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

    //canchasBloc.obtenerSaldo();
    return SliverPersistentHeader(
      floating: true,
      delegate: SliverCustomHeaderDelegate(
        maxHeight: responsive.ip(14) + kToolbarHeight,
        minHeight: responsive.ip(14) + kToolbarHeight,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10),
            ),
          ),
          // color: Colors.red,
          child: SafeArea(
            bottom: false,
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 23,
                  ),
                  height: responsive.hp(8),
                  child: Row(
                    children: [
                      (prefs.email != "" && prefs.email != null)
                          ? (prefs.foto != null)
                              ? InkWell(
                                  onTap: () {
                                    final bottomBloc = ProviderBloc.bottom(context);

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
                                    final bottomBloc = ProviderBloc.bottom(context);

                                    bottomBloc.changePage(4);
                                  },
                                  child: getAlias(nombre, responsive),
                                )
                          : CircleContainer(
                              radius: responsive.ip(2.3),
                              color: Colors.red[800],
                              widget: noLogin,
                            ),
                      SizedBox(
                        width: responsive.wp(2),
                      ),
                      Text(
                        '$alias',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: responsive.ip(2.4),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Spacer(),
                      StreamBuilder(
                          stream: carritoBloc.carritoIdStream,
                          builder: (BuildContext context, AsyncSnapshot<List<Carrito>> snapshot) {
                            int cantidad = 0;

                            if (snapshot.hasData) {
                              if (snapshot.data.length > 0) {
                                for (int i = 0; i < snapshot.data.length; i++) {
                                  if (snapshot.data[i].productoTipo != '1') {
                                    cantidad++;
                                  }
                                }
                              } else {
                                cantidad = 0;
                              }
                            } else {
                              cantidad = 0;
                            }
                            return Stack(
                              children: [
                                (cantidad != 0)
                                    ? Stack(
                                        children: <Widget>[
                                          Container(
                                            decoration: BoxDecoration(
                                              color: Color(0x30F3EFE8),
                                              borderRadius: BorderRadius.circular(5),
                                            ),
                                            padding: EdgeInsets.symmetric(
                                              horizontal: responsive.wp(2),
                                              vertical: responsive.hp(.5),
                                            ),
                                            child: Icon(
                                              Ionicons.ios_cart,
                                              color: Colors.white,
                                            ),
                                          ),
                                          Positioned(
                                            top: 0,
                                            right: 0,
                                            child: Container(
                                              child: Text(
                                                cantidad.toString(),
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: responsive.ip(1),
                                                ),
                                              ),
                                              alignment: Alignment.center,
                                              width: responsive.ip(1.6),
                                              height: responsive.ip(1.6),
                                              decoration: BoxDecoration(color: Colors.green, shape: BoxShape.circle),
                                            ),
                                            //child: Icon(Icons.brightness_1, size: 8,color: Colors.redAccent,  )
                                          )
                                        ],
                                      )
                                    : Container(
                                        decoration: BoxDecoration(
                                          color: Color(0x30F3EFE8),
                                          borderRadius: BorderRadius.circular(5),
                                        ),
                                        padding: EdgeInsets.symmetric(
                                          horizontal: responsive.wp(2),
                                          vertical: responsive.hp(.5),
                                        ),
                                        child: Icon(
                                          Ionicons.ios_cart,
                                          color: Colors.white,
                                        ),
                                      )
                              ],
                            );
                          }),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(
                    left: responsive.wp(6),
                    right: responsive.wp(10),
                  ),
                  child: Row(
                    children: [
                      Text(
                        '" Lo tenemos todo, solo faltas tú "',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: responsive.ip(2.1),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: responsive.hp(1),
                ),
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) {
                          return SearchPage();
                        },
                        transitionsBuilder: (context, animation, secondaryAnimation, child) {
                          var begin = Offset(0.0, 1.0);
                          var end = Offset.zero;
                          var curve = Curves.ease;

                          var tween = Tween(begin: begin, end: end).chain(
                            CurveTween(curve: curve),
                          );

                          return SlideTransition(
                            position: animation.drive(tween),
                            child: child,
                          );
                        },
                      ),
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: responsive.wp(6),
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    height: responsive.hp(4),
                    width: double.infinity,
                    child: Row(
                      children: [
                        SizedBox(
                          width: responsive.wp(3),
                        ),
                        Icon(
                          Icons.search,
                          color: Colors.grey,
                        ),
                        Expanded(
                          child: Text(
                            '¿Qué está buscando?',
                            style: TextStyle(color: Colors.grey),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PublicidadDialog extends StatelessWidget {
  final PublicidadModel publicidadModel;
  const PublicidadDialog({Key key, @required this.publicidadModel}) : super(key: key);

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
                      return DetalleProductitoss2(
                        productosData: producto,
                        mostrarback: true,
                      );
                      //return DetalleProductitos(productosData: productosData);
                    },
                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                      return FadeTransition(
                        opacity: animation,
                        child: child,
                      );
                    },
                  ),
                );
              } else {
                Arguments arg = new Arguments("Promociones", '${publicidadModel.idRelacionado}');

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
                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
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
                transform: Matrix4.translationValues(responsive.ip(1), -responsive.ip(1.3), 0),
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
