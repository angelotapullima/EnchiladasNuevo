import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:enchiladasapp/src/bloc/provider.dart';
import 'package:enchiladasapp/src/models/categoria_model.dart';
import 'package:enchiladasapp/src/search/search.dart';
import 'package:enchiladasapp/src/pages/tabsBottomPrincipales/detalle_categoria.dart';
import 'package:enchiladasapp/src/utils/preferencias_usuario.dart';
import 'package:enchiladasapp/src/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Categoria2 extends StatelessWidget {
  const Categoria2({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final preferences = Preferences();
    final categoriasBloc = ProviderBloc.cat(context);

    categoriasBloc.obtenerCategoriasRestaurant('1');
    categoriasBloc.obtenerCategoriasCafe('3');
    categoriasBloc.obtenerCategoriasVar('4');

    categoriasBloc.obtenerCategoriasRestaurantDelivery('5');
    categoriasBloc.obtenerCategoriasCafeDelivery('6');
    categoriasBloc.obtenerCategoriasVarDelivery('7');

    final responsive = Responsive.of(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Categorías',
          style: TextStyle(
            fontFamily: 'MADE-TOMMY',
            fontWeight: FontWeight.bold,
            color: Colors.grey[700], /* 
            fontSize: responsive.ip(2.6), */
          ),
        ),
        bottom: PreferredSize(
          child: InkWell(
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
                horizontal: responsive.wp(4),
              ),
              padding: EdgeInsets.symmetric(
                horizontal: responsive.wp(4),
              ),
              height: responsive.hp(5),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Text(
                    '¿Qué esta buscando?',
                    style: TextStyle(
                      fontFamily: 'MADE-TOMMY',
                      color: Color(0xffB0BED1),
                      fontWeight: FontWeight.w600,
                      fontSize: responsive.ip(1.8),
                    ),
                  ),
                  Spacer(),
                  Icon(
                    Icons.search,
                    size: responsive.ip(2.6),
                    color: Colors.black,
                  ),
                ],
              ),
            ),
          ),
          preferredSize: Size.fromHeight(50),
        ),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: DefaultTabController(
        length: 6,
        child: Column(
          children: [
            SizedBox(
              height: responsive.hp(1),
            ),
            (preferences.tipoCategoriaNumero == '3')
                ? ButtonsTabBar(
                    height: responsive.hp(8),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.red,
                          width: 1.5,
                        ),
                      ),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: responsive.wp(3),
                    ),
                    unselectedLabelStyle: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'MADE-TOMMY',
                      fontSize: responsive.ip(1.6),
                    ),
                    labelStyle: TextStyle(
                      color: Colors.red,
                      fontFamily: 'MADE-TOMMY',
                      fontWeight: FontWeight.bold,
                      fontSize: responsive.ip(1.6),
                    ),
                    tabs: [
                      Tab(
                        text: "Cafe 24/7",
                      ),
                      Tab(
                        text: "Cafe 24/7 \n Delivery",
                      ),
                      Tab(
                        text: "Restaurant",
                      ),
                      Tab(
                        text: "Restaurant \n Delivery",
                      ),
                      Tab(
                        text: "Var 24/7",
                      ),
                      Tab(
                        text: "Var 24/7 \n Delivery",
                      ),
                    ],
                  )
                : (preferences.tipoCategoriaNumero == '4')
                    ? ButtonsTabBar(
                        height: responsive.hp(8),
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          border: Border(
                            bottom: BorderSide(
                              color: Colors.red,
                              width: 1.5,
                            ),
                          ),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: responsive.wp(3),
                        ),
                        unselectedBackgroundColor: Colors.transparent,
                        unselectedLabelStyle: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'MADE-TOMMY',
                          fontSize: responsive.ip(1.6),
                        ),
                        labelStyle: TextStyle(
                          color: Colors.red,
                          fontFamily: 'MADE-TOMMY',
                          fontWeight: FontWeight.bold,
                          fontSize: responsive.ip(1.6),
                        ),
                        tabs: [
                          Tab(
                            text: "Var 24/7",
                          ),
                          Tab(
                            text: "Var 24/7 \n Delivery",
                          ),
                          Tab(
                            text: "Restaurant",
                          ),
                          Tab(
                            text: "Restaurant \n Delivery",
                          ),
                          Tab(
                            text: "Cafe 24/7",
                          ),
                          Tab(
                            text: "Cafe 24/7 \n Delivery",
                          ),
                        ],
                      )
                    : ButtonsTabBar(
                        height: responsive.hp(8), 
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          border: Border(
                            bottom: BorderSide(
                              color: Colors.red,
                              width: 1.5,
                            ),
                          ),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: responsive.wp(3),
                        ),
                        unselectedBackgroundColor: Colors.transparent,
                        unselectedLabelStyle: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'MADE-TOMMY',
                          fontSize: responsive.ip(1.6),
                        ),
                        labelStyle: TextStyle(
                          color: Colors.red,
                          fontFamily: 'MADE-TOMMY',
                          fontWeight: FontWeight.bold,
                          fontSize: responsive.ip(1.6),
                        ),
                        tabs: [
                          Tab(
                            text: "Restaurant",
                          ),
                          Tab(
                            text: "Restaurant \n Delivery",
                          ),
                          Tab(
                            text: "Cafe 24/7",
                          ),
                          Tab(
                            text: "Cafe 24/7 \n Delivery",
                          ),
                          Tab(
                            text: "Var 24/7",
                          ),
                          Tab(
                            text: "Var 24/7 \n Delivery",
                          ),
                        ],
                      ),
            Expanded(
              child: TabBarView(
                children: (preferences.tipoCategoriaNumero == '3')
                    ? <Widget>[
                        CafeWidget(categoriasBloc: categoriasBloc, responsive: responsive),
                        CafeDeliveryWidget(categoriasBloc: categoriasBloc, responsive: responsive),
                        RestaurantWidget(categoriasBloc: categoriasBloc, responsive: responsive),
                        RestaurantDeliveryWidget(categoriasBloc: categoriasBloc, responsive: responsive),
                        VarWidget(categoriasBloc: categoriasBloc, responsive: responsive),
                        VarDeliveryWidget(categoriasBloc: categoriasBloc, responsive: responsive),
                      ]
                    : (preferences.tipoCategoriaNumero == '4')
                        ? <Widget>[
                            VarWidget(categoriasBloc: categoriasBloc, responsive: responsive),
                            VarDeliveryWidget(categoriasBloc: categoriasBloc, responsive: responsive),
                            RestaurantWidget(categoriasBloc: categoriasBloc, responsive: responsive),
                            RestaurantDeliveryWidget(categoriasBloc: categoriasBloc, responsive: responsive),
                            CafeWidget(categoriasBloc: categoriasBloc, responsive: responsive),
                            CafeDeliveryWidget(categoriasBloc: categoriasBloc, responsive: responsive),
                          ]
                        : <Widget>[
                            RestaurantWidget(categoriasBloc: categoriasBloc, responsive: responsive),
                            RestaurantDeliveryWidget(categoriasBloc: categoriasBloc, responsive: responsive),
                            CafeWidget(categoriasBloc: categoriasBloc, responsive: responsive),
                            CafeDeliveryWidget(categoriasBloc: categoriasBloc, responsive: responsive),
                            VarWidget(categoriasBloc: categoriasBloc, responsive: responsive),
                            VarDeliveryWidget(categoriasBloc: categoriasBloc, responsive: responsive),
                          ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class RestaurantWidget extends StatelessWidget {
  const RestaurantWidget({
    Key key,
    @required this.categoriasBloc,
    @required this.responsive,
  }) : super(key: key);

  final CategoriasBloc categoriasBloc;
  final Responsive responsive;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: categoriasBloc.categoriasRestaurantStream,
      builder: (BuildContext context, AsyncSnapshot<List<CategoriaData>> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.length > 0) {
            return ListView.builder(
              itemCount: snapshot.data.length,
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              itemBuilder: (context, i) {
                return InkWell(
                  onTap: () {
                    Navigator.of(context).push(PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) {
                        return Detallecategoria(
                          idCategoria: '${snapshot.data[i].idCategoria}',
                          categoriaNombre: '${snapshot.data[i].categoriaNombre}',
                          categoriaIcono: '${snapshot.data[i].categoriaIcono}',
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
                    ));
                  },
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: responsive.wp(5),
                        ),
                        child: Row(
                          children: [
                            Container(
                              height: responsive.ip(4),
                              width: responsive.ip(4),
                              child: SvgPicture.network(
                                '${snapshot.data[i].categoriaIcono}',
                                semanticsLabel: 'A shark?!',
                                placeholderBuilder: (BuildContext context) => Container(padding: const EdgeInsets.all(30.0), child: const CircularProgressIndicator()),
                                fit: BoxFit.cover,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                '${snapshot.data[i].categoriaNombre}',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                  fontSize: responsive.ip(1.5),
                                ),
                              ),
                            ),
                            Icon(Ionicons.ios_arrow_forward, color: Colors.black, size: responsive.hp(3)),
                          ],
                        ),
                      ),
                      Divider()
                    ],
                  ),
                );
              },
            );
          } else {
            return Container(
              child: Center(child: Text('No Existen categorías ')),
            );
          }
        } else {
          return Container();
        }
      },
    );
  }
}

class CafeWidget extends StatelessWidget {
  const CafeWidget({
    Key key,
    @required this.categoriasBloc,
    @required this.responsive,
  }) : super(key: key);

  final CategoriasBloc categoriasBloc;
  final Responsive responsive;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: categoriasBloc.categoriasCafeStream,
      builder: (BuildContext context, AsyncSnapshot<List<CategoriaData>> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.length > 0) {
            return ListView.builder(
              itemCount: snapshot.data.length,
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              itemBuilder: (context, i) {
                return InkWell(
                  onTap: () {
                    Navigator.of(context).push(PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) {
                        return Detallecategoria(
                          idCategoria: '${snapshot.data[i].idCategoria}',
                          categoriaNombre: '${snapshot.data[i].categoriaNombre}',
                          categoriaIcono: '${snapshot.data[i].categoriaIcono}',
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
                    ));
                  },
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: responsive.wp(5),
                        ),
                        child: Row(
                          children: [
                            Container(
                              height: responsive.ip(4),
                              width: responsive.ip(4),
                              child: SvgPicture.network(
                                '${snapshot.data[i].categoriaIcono}',
                                semanticsLabel: 'A shark?!',
                                placeholderBuilder: (BuildContext context) => Container(padding: const EdgeInsets.all(30.0), child: const CircularProgressIndicator()),
                                fit: BoxFit.cover,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                '${snapshot.data[i].categoriaNombre}',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                  fontSize: responsive.ip(1.5),
                                ),
                              ),
                            ),
                            Icon(Ionicons.ios_arrow_forward, color: Colors.black, size: responsive.hp(3)),
                          ],
                        ),
                      ),
                      Divider()
                    ],
                  ),
                );
              },
            );
          } else {
            return Container(
              child: Center(child: Text('No Existen categorías')),
            );
          }
        } else {
          return Container();
        }
      },
    );
  }
}

class VarWidget extends StatelessWidget {
  const VarWidget({
    Key key,
    @required this.categoriasBloc,
    @required this.responsive,
  }) : super(key: key);

  final CategoriasBloc categoriasBloc;
  final Responsive responsive;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: categoriasBloc.categoriasVarStream,
      builder: (BuildContext context, AsyncSnapshot<List<CategoriaData>> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.length > 0) {
            return ListView.builder(
              itemCount: snapshot.data.length,
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              itemBuilder: (context, i) {
                return InkWell(
                  onTap: () {
                    Navigator.of(context).push(PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) {
                        return Detallecategoria(
                          idCategoria: '${snapshot.data[i].idCategoria}',
                          categoriaNombre: '${snapshot.data[i].categoriaNombre}',
                          categoriaIcono: '${snapshot.data[i].categoriaIcono}',
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
                    ));
                  },
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: responsive.wp(5),
                        ),
                        child: Row(
                          children: [
                            Container(
                              height: responsive.ip(4),
                              width: responsive.ip(4),
                              child: SvgPicture.network(
                                '${snapshot.data[i].categoriaIcono}',
                                semanticsLabel: 'A shark?!',
                                placeholderBuilder: (BuildContext context) => Container(padding: const EdgeInsets.all(30.0), child: const CircularProgressIndicator()),
                                fit: BoxFit.cover,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                '${snapshot.data[i].categoriaNombre}',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                  fontSize: responsive.ip(1.5),
                                ),
                              ),
                            ),
                            Icon(Ionicons.ios_arrow_forward, color: Colors.black, size: responsive.hp(3)),
                          ],
                        ),
                      ),
                      Divider()
                    ],
                  ),
                );
              },
            );
          } else {
            return Container(
              child: Center(child: Text('No Existen categorías')),
            );
          }
        } else {
          return Container();
        }
      },
    );
  }
}

class RestaurantDeliveryWidget extends StatelessWidget {
  const RestaurantDeliveryWidget({
    Key key,
    @required this.categoriasBloc,
    @required this.responsive,
  }) : super(key: key);

  final CategoriasBloc categoriasBloc;
  final Responsive responsive;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: categoriasBloc.categoriasRestaurantDeliveryStream,
      builder: (BuildContext context, AsyncSnapshot<List<CategoriaData>> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.length > 0) {
            return ListView.builder(
              itemCount: snapshot.data.length,
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              itemBuilder: (context, i) {
                return InkWell(
                  onTap: () {
                    Navigator.of(context).push(PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) {
                        return Detallecategoria(
                          idCategoria: '${snapshot.data[i].idCategoria}',
                          categoriaNombre: '${snapshot.data[i].categoriaNombre}',
                          categoriaIcono: '${snapshot.data[i].categoriaIcono}',
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
                    ));
                  },
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: responsive.wp(5),
                        ),
                        child: Row(
                          children: [
                            Container(
                              height: responsive.ip(4),
                              width: responsive.ip(4),
                              child: SvgPicture.network(
                                '${snapshot.data[i].categoriaIcono}',
                                semanticsLabel: 'A shark?!',
                                placeholderBuilder: (BuildContext context) => Container(
                                  padding: const EdgeInsets.all(30.0),
                                  child: const CircularProgressIndicator(),
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                '${snapshot.data[i].categoriaNombre}',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                  fontSize: responsive.ip(1.5),
                                ),
                              ),
                            ),
                            Icon(Ionicons.ios_arrow_forward, color: Colors.black, size: responsive.hp(3)),
                          ],
                        ),
                      ),
                      Divider()
                    ],
                  ),
                );
              },
            );
          } else {
            return Container(
              child: Center(child: Text('No Existen categorías')),
            );
          }
        } else {
          return Container();
        }
      },
    );
  }
}

class CafeDeliveryWidget extends StatelessWidget {
  const CafeDeliveryWidget({
    Key key,
    @required this.categoriasBloc,
    @required this.responsive,
  }) : super(key: key);

  final CategoriasBloc categoriasBloc;
  final Responsive responsive;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: categoriasBloc.categoriasCafeDeliveryStream,
      builder: (BuildContext context, AsyncSnapshot<List<CategoriaData>> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.length > 0) {
            return ListView.builder(
              itemCount: snapshot.data.length,
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              itemBuilder: (context, i) {
                return InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) {
                          return Detallecategoria(
                            idCategoria: '${snapshot.data[i].idCategoria}',
                            categoriaNombre: '${snapshot.data[i].categoriaNombre}',
                            categoriaIcono: '${snapshot.data[i].categoriaIcono}',
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
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: responsive.wp(5),
                        ),
                        child: Row(
                          children: [
                            Container(
                              height: responsive.ip(4),
                              width: responsive.ip(4),
                              child: SvgPicture.network(
                                '${snapshot.data[i].categoriaIcono}',
                                semanticsLabel: 'A shark?!',
                                placeholderBuilder: (BuildContext context) => Container(padding: const EdgeInsets.all(30.0), child: const CircularProgressIndicator()),
                                fit: BoxFit.cover,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                '${snapshot.data[i].categoriaNombre}',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                  fontSize: responsive.ip(1.5),
                                ),
                              ),
                            ),
                            Icon(Ionicons.ios_arrow_forward, color: Colors.black, size: responsive.hp(3)),
                          ],
                        ),
                      ),
                      Divider()
                    ],
                  ),
                );
              },
            );
          } else {
            return Container(
              child: Center(child: Text('No Existen categorías')),
            );
          }
        } else {
          return Container();
        }
      },
    );
  }
}

class VarDeliveryWidget extends StatelessWidget {
  const VarDeliveryWidget({
    Key key,
    @required this.categoriasBloc,
    @required this.responsive,
  }) : super(key: key);

  final CategoriasBloc categoriasBloc;
  final Responsive responsive;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: categoriasBloc.categoriasVarDeliveryStream,
      builder: (BuildContext context, AsyncSnapshot<List<CategoriaData>> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.length > 0) {
            return ListView.builder(
              itemCount: snapshot.data.length,
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              itemBuilder: (context, i) {
                return InkWell(
                  onTap: () {
                    Navigator.of(context).push(PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) {
                        return Detallecategoria(
                          idCategoria: '${snapshot.data[i].idCategoria}',
                          categoriaNombre: '${snapshot.data[i].categoriaNombre}',
                          categoriaIcono: '${snapshot.data[i].categoriaIcono}',
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
                    ));
                  },
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: responsive.wp(5),
                        ),
                        child: Row(
                          children: [
                            Container(
                              height: responsive.ip(4),
                              width: responsive.ip(4),
                              child: SvgPicture.network(
                                '${snapshot.data[i].categoriaIcono}',
                                semanticsLabel: 'A shark?!',
                                placeholderBuilder: (BuildContext context) => Container(padding: const EdgeInsets.all(30.0), child: const CircularProgressIndicator()),
                                fit: BoxFit.cover,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                '${snapshot.data[i].categoriaNombre}',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                  fontSize: responsive.ip(1.5),
                                ),
                              ),
                            ),
                            Icon(Ionicons.ios_arrow_forward, color: Colors.black, size: responsive.hp(3)),
                          ],
                        ),
                      ),
                      Divider()
                    ],
                  ),
                );
              },
            );
          } else {
            return Container(
              child: Center(child: Text('No Existen categorías')),
            );
          }
        } else {
          return Container();
        }
      },
    );
  }
}
