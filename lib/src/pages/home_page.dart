import 'package:enchiladasapp/src/bloc/bottom_navigation_bloc.dart';
import 'package:enchiladasapp/src/bloc/provider.dart';
import 'package:enchiladasapp/src/models/carrito_model.dart';
import 'package:enchiladasapp/src/utils/responsive.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart'; 

import 'tabsBottomPrincipales/categorias_page.dart';
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
  List<Widget> pageList = List<Widget>();

  @override
  void initState() {
    pageList.add(PrincipalTab());
    pageList.add(FavoritosTab());
    pageList.add(CategoriasPage());
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
            return IndexedStack(
              index: (bottomBloc.page==null)?0:bottomBloc.page,
              children: pageList,
            );
          }),
      bottomNavigationBar: StreamBuilder(
        stream: carritoBloc.carritoIdStream,
        builder: (BuildContext context, AsyncSnapshot<List<Carrito>> snapshot) {
          int cantidadCarrito = 0;
          if (snapshot.hasData) {
            if (snapshot.data.length > 0) {
              cantidadCarrito = snapshot.data.length;
              return bottonNaviga(responsive, cantidadCarrito, bottomBloc);
            } else {
              return bottonNaviga(responsive, cantidadCarrito, bottomBloc);
            }
          } else {
            return bottonNaviga(responsive, cantidadCarrito, bottomBloc);
          }
          //return bottonNaviga(responsive, cantidadCarrito);
        },
      ),
    );
  }

  Widget bottonNaviga(
      Responsive responsive, int cantidad, BottomNaviBloc bottomBloc) {
    return StreamBuilder(
        stream: bottomBloc.selectPageStream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return BottomNavigationBar(
              backgroundColor: Colors.white,
              elevation: 0.0,
              selectedItemColor: Colors.green[400],
              unselectedItemColor: Colors.red,
              selectedLabelStyle: TextStyle(fontWeight: FontWeight.w600),
              unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w600),
              type: BottomNavigationBarType.fixed,
              items: [
                BottomNavigationBarItem(
                    icon: Icon(Icons.home, size: responsive.ip(3)),
                    title: Text('Principal')),
                BottomNavigationBarItem(
                    icon: Icon(
                      FontAwesomeIcons.solidHeart,
                      size: responsive.ip(2.7),
                    ),
                    title: Text('Favoritos')),
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.near_me,
                      size: responsive.ip(3),
                    ),
                    title: Text('Categorías')),
                BottomNavigationBarItem(
                    icon: (cantidad != 0)
                        ? Stack(children: <Widget>[
                            Icon(Icons.shopping_cart, size: responsive.ip(3)),
                            Positioned(
                              top: 0,
                              right: 0,
                              child: Container(
                                child: Text(
                                  cantidad.toString(),
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 8),
                                ),
                                alignment: Alignment.center,
                                width: 13,
                                height: 13,
                                decoration: BoxDecoration(
                                    color: Colors.green,
                                    shape: BoxShape.circle),
                              ),
                              //child: Icon(Icons.brightness_1, size: 8,color: Colors.redAccent,  )
                            )
                          ])
                        : Icon(Icons.shopping_cart, size: responsive.ip(3)),
                    title: Text('Carrito')),
                BottomNavigationBarItem(
                    icon: Icon(Icons.person, size: responsive.ip(3)),
                    title: Text('Cuenta'))
              ],
              currentIndex: bottomBloc.page,
              onTap: (index) => {bottomBloc.changePage(index)});
        });
  }

   
}
