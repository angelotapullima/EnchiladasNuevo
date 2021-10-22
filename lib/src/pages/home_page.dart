import 'package:enchiladasapp/src/bloc/provider.dart';
import 'package:enchiladasapp/src/models/carrito_model.dart';
import 'package:enchiladasapp/src/pages/tabsBottomPrincipales/categoria2.dart';
import 'package:enchiladasapp/src/utils/responsive.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'tabsBottomPrincipales/favoritos_tab.dart';
import 'tabsBottomPrincipales/mi_cuenta.dart';
import 'tabsBottomPrincipales/carrito_tab.dart';
import 'tabsBottomPrincipales/principal_tab.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Widget> pageList = [];

  @override
  void initState() {
    pageList.add(PrincipalTab());
    pageList.add(FavoritosTab());
    pageList.add(Categoria2());
    pageList.add(MiOrdenTab());
    pageList.add(MiCuentaTab());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Responsive responsive = new Responsive.of(context);

    final carritoBloc = ProviderBloc.carrito(context);
    carritoBloc.obtenerCarrito();

    final bottomBloc = ProviderBloc.bottom(context);

    bottomBloc.changePage(0);

    return Scaffold(
      body: StreamBuilder(
        stream: bottomBloc.selectPageStream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return Stack(
            children: [
              Container(
                padding: EdgeInsets.only(
                  bottom: kBottomNavigationBarHeight,
                ),
                child: IndexedStack(
                  index: snapshot.data,
                  children: pageList,
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: kBottomNavigationBarHeight * responsive.hp(.18),
                  padding: EdgeInsets.only(
                    bottom: responsive.hp(2),
                    left: responsive.wp(2),
                    right: responsive.wp(2),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadiusDirectional.only(
                      topStart: Radius.circular(20),
                      topEnd: Radius.circular(20),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: StreamBuilder(
                    stream: bottomBloc.selectPageStream,
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      return Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: responsive.wp(2),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () {
                                bottomBloc.changePage(0);
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: responsive.hp(1),
                                  ),
                                  Icon(
                                    Icons.home,
                                    size: responsive.ip(3),
                                    color: (bottomBloc.page == 0) ? Colors.red : Colors.grey,
                                  ),
                                  Text(
                                    'Inicio',
                                    style: TextStyle(
                                      fontSize: responsive.ip(1.5),
                                      color: (bottomBloc.page == 0) ? Colors.red : Colors.grey,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                bottomBloc.changePage(1);
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: responsive.hp(1),
                                  ),
                                  Icon(
                                    FontAwesome5Solid.heart,
                                    size: responsive.ip(3),
                                    color: (bottomBloc.page == 1) ? Colors.red : Colors.grey,
                                  ),
                                  Text(
                                    'Favoritos',
                                    style: TextStyle(
                                      fontSize: responsive.ip(1.5),
                                      color: (bottomBloc.page == 1) ? Colors.red : Colors.grey,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                bottomBloc.changePage(2);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.red.withOpacity(0.2),
                                      spreadRadius: .2,
                                      blurRadius: 8,
                                      offset: Offset(0, .5), // changes position of shadow
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: responsive.hp(.5),
                                    ),
                                    CircleAvatar(
                                      radius: responsive.ip(2.2),
                                      backgroundColor: Colors.red,
                                      child: Center(
                                        child: Icon(
                                          Icons.menu_rounded,
                                          color: Colors.white,
                                          size: responsive.ip(2.5),
                                        ),
                                      ),
                                    ),
                                    Text(
                                      'Categorías',
                                      style: TextStyle(
                                        fontSize: responsive.ip(1.5),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                bottomBloc.changePage(3);
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: responsive.hp(1),
                                  ),
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
                                                      Icon(
                                                        MaterialIcons.shopping_cart,
                                                        size: responsive.ip(3),
                                                        color: (bottomBloc.page == 3) ? Colors.red : Colors.grey,
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
                                                : Icon(
                                                    MaterialIcons.shopping_cart,
                                                    size: responsive.ip(3),
                                                    color: (bottomBloc.page == 3) ? Colors.red : Colors.grey,
                                                  ),
                                          ],
                                        );
                                      }),
                                  Text(
                                    'Carrito',
                                    style: TextStyle(
                                      fontSize: responsive.ip(1.6),
                                      color: (bottomBloc.page == 3) ? Colors.red : Colors.grey,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                bottomBloc.changePage(4);
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: responsive.hp(1),
                                  ),
                                  Icon(
                                    Icons.person,
                                    size: responsive.ip(3),
                                    color: (bottomBloc.page == 4) ? Colors.red : Colors.grey,
                                  ),
                                  Text(
                                    'Usuario',
                                    style: TextStyle(
                                      fontSize: responsive.ip(1.6),
                                      color: (bottomBloc.page == 4) ? Colors.red : Colors.grey,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              )

              /* IndexedStack(
                index: (bottomBloc.page == null) ? 0 : bottomBloc.page,
                children: pageList,
              ), */
            ],
          );
        },
      ),
    );
  }
}
