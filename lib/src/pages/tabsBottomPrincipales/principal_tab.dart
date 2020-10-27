import 'package:cached_network_image/cached_network_image.dart';
import 'package:enchiladasapp/src/api/configuracion_api.dart';
import 'package:enchiladasapp/src/bloc/provider.dart';
import 'package:enchiladasapp/src/models/arguments.dart';
import 'package:enchiladasapp/src/models/categoria_model.dart';
import 'package:enchiladasapp/src/models/pantalla_model.dart';
import 'package:enchiladasapp/src/models/productos._model.dart';
import 'package:enchiladasapp/src/pages/detalle_productos.dart';
import 'package:enchiladasapp/src/utils/circle.dart';
import 'package:enchiladasapp/src/utils/responsive.dart';
import 'package:enchiladasapp/src/utils/preferencias_usuario.dart';
import 'package:enchiladasapp/src/widgets/customCacheManager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:enchiladasapp/src/search/search_delegate.dart';
import 'package:page_view_indicators/circle_page_indicator.dart';

class PrincipalTab extends StatelessWidget {
  final _pageController = PageController(viewportFraction: 0.9,initialPage: 1);
  final _currentPageNotifier = ValueNotifier<int>(1);
  final _boxHeight = 150.0;

  @override
  Widget build(BuildContext context) {
    final Responsive responsive = new Responsive.of(context);
    final usuarioBloc = ProviderBloc.user(context);
    usuarioBloc.obtenerUsuario();

    return Scaffold(
      body: _inicio(context, responsive),
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
        child: Text(alias, style: TextStyle(fontSize: responsive.ip(7))));
  }

  Widget _inicio(BuildContext context, Responsive responsive) {
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
    return Column(
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
                        '$alias',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: responsive.ip(3),
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        showSearch(context: context, delegate: DataSearch(hintText: 'Buscar'));
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
                            ? CircleAvatar(
                                radius: responsive.ip(2),
                                child: ClipOval(
                                  child: Image.network(
                                    prefs.foto,
                                    width: responsive.ip(4),
                                    height: responsive.ip(4),
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              )
                            : getAlias(nombre, responsive)
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
        Expanded(child: _contenido(context, responsive))
      ],
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
      height: _boxHeight,
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
                  Navigator.pushNamed(context, 'detallePromociones', arguments: arg); 
                  //Navigator.pushNamed(context, 'detallePromociones');
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: CachedNetworkImage(
                    cacheManager: CustomCacheManager(),
                    placeholder: (context, url) => Image(
                        image: AssetImage('assets/jar-loading.gif'),
                        fit: BoxFit.cover),errorWidget: (context, url, error) => Image(
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
        dotColor: Colors.white,
        itemCount: promociones.length,
        currentPageNotifier: _currentPageNotifier,
      ),
    );
  }

  Widget _contenido(BuildContext context, Responsive responsive) {
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
              return ListView.builder(
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
                                return Container(
                                  margin: EdgeInsets.only(top:responsive.hp(1)),
                                  height: responsive.hp(25),
                                  child: Stack(
                                    children: <Widget>[
                                      _buildPageView(responsive, cat.data),
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
                          });
                    }
                    int index = i - 1;
                    return _cart(context, responsive, snapshot.data[index]);
                  });
            } else {
              configuracionApi.configuracion();
              return Center(child: CupertinoActivityIndicator());
            }
          } else {
            configuracionApi.configuracion();
            return Center(child: CupertinoActivityIndicator());
          }
        },
      ),
    );
  }

  Widget _cart(BuildContext context, Responsive responsive,
      PantallaModel pantallaModel) {
    double altoList = 18.0;
    double altoCard = 13.0;
    double anchoCard = 25.0;
    BoxFit boxfit;
    String tipo;
    if (pantallaModel.idPantalla == '5') {
      //combos
      altoList = 40.0;
      altoCard = 35.0;
      anchoCard = 85;
      boxfit = BoxFit.fill;
      tipo = 'producto';
    } else if (pantallaModel.idPantalla == '4') {
      //especiales
      altoList = 35.0;
      altoCard = 30.0;
      anchoCard = 60;

      tipo = 'producto';

      boxfit = BoxFit.fill;
    } else if (pantallaModel.idPantalla == '2') {
      //market
      altoList = 28.0;
      altoCard = 23.0;
      anchoCard = 45;

      boxfit = BoxFit.fill;

      tipo = 'categoria';
    } else if (pantallaModel.idPantalla == '1') {
      //carta Principal
      altoList = 20.0;
      altoCard = 15.0;
      anchoCard = 35;

      tipo = 'categoria';

      boxfit = BoxFit.fill;
    } else if (pantallaModel.idPantalla == '3') {
      //puzzle
      altoList = 28.0;
      altoCard = 23.0;
      anchoCard = 40;

      boxfit = BoxFit.fill;

      tipo = 'puzzle';
    }

    return GestureDetector(
      child: Container(
        margin: EdgeInsets.only(bottom: responsive.hp(1)),
        width: double.infinity,
        height: responsive.hp(altoList),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: responsive.wp(3)),
              child: Row(
                children: <Widget>[
                  Text(
                    '${pantallaModel.pantallaNombre}',
                    style: TextStyle(
                        fontSize: responsive.ip(2.5),
                        color: Colors.red,
                        fontWeight: FontWeight.bold),
                  ),
                  Spacer(),
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


                        Navigator.pushNamed(context, 'combo', arguments: arg);

                        
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
              height: responsive.hp(altoCard),
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: pantallaModel.items.length,
                  shrinkWrap: true,
                  itemBuilder: (context, i) {

                    if(i==pantallaModel.items.length-1){
                      return GestureDetector(
                        onTap: (){
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
                        Navigator.pushNamed(context, 'combo', arguments: arg);
                      }
                        },

                        child: Container(
                          width: responsive.wp(anchoCard),
                          height: responsive.hp(altoCard),
                          padding: EdgeInsets.only(
                            left: responsive.wp(3),
                          ),
                          margin: EdgeInsets.only(
                            right: responsive.wp(1.5),
                          ),
                          child: Stack(
                            children: <Widget>[
                              Container(
                                width: responsive.wp(anchoCard),
                                height: responsive.hp(altoCard),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: CachedNetworkImage(
                                    cacheManager: CustomCacheManager(),
                                    placeholder: (context, url) => Image(
                                        image:
                                            AssetImage('assets/jar-loading.gif'),
                                        fit: BoxFit.cover),errorWidget: (context, url, error) => Image(
                  image: AssetImage('assets/carga_fallida.jpg'),
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
                              '${pantallaModel.items[i].id}');
                          Navigator.pushNamed(context, 'combo', arguments: arg);
                        } else if (tipo == 'producto') {
                          ProductosData productosData = ProductosData();
                          productosData.idProducto = pantallaModel.items[i].id;

                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              transitionDuration:
                                  const Duration(milliseconds: 100),
                              pageBuilder:
                                  (context, animation, secondaryAnimation) {
                                return DetalleProductitos(
                                    productosData: productosData);
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
                        } else if (tipo == 'puzzle'){

                        Navigator.pushNamed(context, 'HomePuzzle');

                        }
                      },
                      child: Container(
                        width: responsive.wp(anchoCard),
                        height: responsive.hp(altoCard),
                        padding: EdgeInsets.only(
                          left: responsive.wp(3),
                        ),
                        margin: EdgeInsets.only(
                          right: responsive.wp(1.5),
                        ),
                        child: Stack(
                          children: <Widget>[
                            Container(
                              width: responsive.wp(anchoCard),
                              height: responsive.hp(altoCard),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: CachedNetworkImage(
                                  cacheManager: CustomCacheManager(),
                                  placeholder: (context, url) => Image(
                                      image:
                                          AssetImage('assets/jar-loading.gif'),
                                      fit: BoxFit.cover),errorWidget: (context, url, error) => Image(
                  image: AssetImage('assets/carga_fallida.jpg'),
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
                                  '${pantallaModel.items[i].nombreItem}',
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
      ),
      onTap: () {
        Arguments arg = new Arguments("Combos Delivery", '54');
        //Navigator.pushNamed(context, 'timeline', arguments: arg);
        Navigator.pushNamed(context, 'combo', arguments: arg);
      },
    );
  }
}
