import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:enchiladasapp/src/bloc/provider.dart';
import 'package:enchiladasapp/src/models/categoria_model.dart';
import 'package:enchiladasapp/src/pages/search.dart';
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

    if (preferences.tipoCategoria == '1') {
      categoriasBloc.obtenerCategoriasRestaurant('1');
      categoriasBloc.obtenerCategoriasCafe('3');
      categoriasBloc.obtenerCategoriasVar('4');
    } else {
      categoriasBloc.obtenerCategoriasRestaurant('5');
      categoriasBloc.obtenerCategoriasCafe('6');
      categoriasBloc.obtenerCategoriasVar('7');
    }

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
            color: Colors.grey[700],
            fontSize: responsive.ip(2.6),
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
        length: 3,
        child: Column(
          children: [
            SizedBox(
              height: responsive.hp(1),
            ),
            (preferences.tipoCategoriaNumero == '3')
                ? ButtonsTabBar(
                    backgroundColor: Colors.transparent,
                    duration: 0,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: responsive.wp(5),
                    ),
                    physics: NeverScrollableScrollPhysics(),
                    unselectedBackgroundColor: Colors.transparent,
                    unselectedLabelStyle: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'MADE-TOMMY',
                      fontSize: responsive.ip(2),
                    ),
                    labelStyle: TextStyle(
                      color: Colors.red,
                      fontFamily: 'MADE-TOMMY',
                      fontWeight: FontWeight.bold,
                      fontSize: responsive.ip(2),
                    ),
                    tabs: [
                      Tab(
                        text: "Cafe 24/7",
                      ),
                      Tab(
                        text: "Restaurant",
                      ),
                      Tab(
                        text: "Var 24/7",
                      ),
                    ],
                  )
                : (preferences.tipoCategoriaNumero == '4')
                    ? ButtonsTabBar(
                        backgroundColor: Colors.transparent,
                        duration: 0,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: responsive.wp(5),
                        ),
                        physics: NeverScrollableScrollPhysics(),
                        unselectedBackgroundColor: Colors.transparent,
                        unselectedLabelStyle: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'MADE-TOMMY',
                          fontSize: responsive.ip(2),
                        ),
                        labelStyle: TextStyle(
                          color: Colors.red,
                          fontFamily: 'MADE-TOMMY',
                          fontWeight: FontWeight.bold,
                          fontSize: responsive.ip(2),
                        ),
                        tabs: [
                          Tab(
                            text: "Var 24/7",
                          ),
                          Tab(
                            text: "Restaurant",
                          ),
                          Tab(
                            text: "Cafe 24/7",
                          ),
                        ],
                      )
                    : ButtonsTabBar(
                        backgroundColor: Colors.transparent,
                        duration: 0,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: responsive.wp(5),
                        ),
                        physics: NeverScrollableScrollPhysics(),
                        unselectedBackgroundColor: Colors.transparent,
                        unselectedLabelStyle: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'MADE-TOMMY',
                          fontSize: responsive.ip(2),
                        ),
                        labelStyle: TextStyle(
                          color: Colors.red,
                          fontFamily: 'MADE-TOMMY',
                          fontWeight: FontWeight.bold,
                          fontSize: responsive.ip(2),
                        ),
                        tabs: [
                          Tab(
                            text: "Restaurant",
                          ),
                          Tab(
                            text: "Cafe 24/7",
                          ),
                          Tab(
                            text: "Var 24/7",
                          ),
                        ],
                      ),
            Expanded(
              child: TabBarView(
                children: (preferences.tipoCategoriaNumero == '3')
                    ? <Widget>[
                        CafeWidget(categoriasBloc: categoriasBloc, responsive: responsive),
                        RestaurantWidget(categoriasBloc: categoriasBloc, responsive: responsive),
                        VarWidget(categoriasBloc: categoriasBloc, responsive: responsive),
                      ]
                    : (preferences.tipoCategoriaNumero == '4')
                        ? <Widget>[
                            VarWidget(categoriasBloc: categoriasBloc, responsive: responsive),
                            RestaurantWidget(categoriasBloc: categoriasBloc, responsive: responsive),
                            CafeWidget(categoriasBloc: categoriasBloc, responsive: responsive),
                          ]
                        : <Widget>[
                            RestaurantWidget(categoriasBloc: categoriasBloc, responsive: responsive),
                            CafeWidget(categoriasBloc: categoriasBloc, responsive: responsive),
                            VarWidget(categoriasBloc: categoriasBloc, responsive: responsive),
                          ],
              ),
            )
            /*  Expanded(
              child: StreamBuilder(
                stream: categoriasBloc.categoriaTipo,
                builder: (context, AsyncSnapshot<List<TipoModel>> snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data.length > 0) {
                      return ListView.builder(
                          itemCount: snapshot.data.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            
                            return ListView.builder(
                              itemCount: snapshot.data[index].cate.length + 1,
                              shrinkWrap: true,
                              physics: ClampingScrollPhysics(),
                              itemBuilder: (context, i) {
                                if (i == 0) {
                                  return Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: responsive.wp(2),
                                      vertical: responsive.hp(2),
                                    ),
                                    child: Text(
                                      '${snapshot.data[index].tipo}',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: responsive.ip(2.5),
                                      ),
                                    ),
                                  );
                                }
      
                                i = i - 1;
                                return InkWell(
                                  onTap: () {
                                    Navigator.of(context).push(PageRouteBuilder(
                                      pageBuilder: (context, animation, secondaryAnimation) {
                                        return Detallecategoria(
                                          idCategoria: '${snapshot.data[index].cate[i].idCategoria}',
                                          categoriaNombre: '${snapshot.data[index].cate[i].categoriaNombre}',
                                          categoriaIcono: '${snapshot.data[index].cate[i].categoriaIcono}',
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
                                                '${snapshot.data[index].cate[i].categoriaIcono}',
                                                semanticsLabel: 'A shark?!',
                                                placeholderBuilder: (BuildContext context) =>
                                                    Container(padding: const EdgeInsets.all(30.0), child: const CircularProgressIndicator()),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                            Expanded(
                                              child: Text(
                                                '${snapshot.data[index].cate[i].categoriaNombre}',
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
                          });
                    } else {
                      return Container(
                        child: Center(child: Text('No aye')),
                      );
                    }
                  } else {
                    return Container();
                  }
                },
              ),
            ),
           */
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
              child: Center(child: Text('No aye')),
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
              child: Center(child: Text('No aye')),
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
              child: Center(child: Text('No aye')),
            );
          }
        } else {
          return Container();
        }
      },
    );
  }
}
