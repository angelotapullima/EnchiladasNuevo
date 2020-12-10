import 'package:enchiladasapp/src/bloc/bottom_local.dart';
import 'package:enchiladasapp/src/bloc/provider.dart';
import 'package:enchiladasapp/src/pages/AplicacionLocal/categorias_local.dart';
import 'package:enchiladasapp/src/pages/AplicacionLocal/principal_local.dart';
import 'package:enchiladasapp/src/utils/responsive.dart';
import 'package:flutter/material.dart';

class HomeLocal extends StatefulWidget {
  const HomeLocal({Key key}) : super(key: key);

  @override
  _HomeLocalState createState() => _HomeLocalState();
}

class _HomeLocalState extends State<HomeLocal> {
  List<Widget> pageListLocal = List<Widget>();

  @override
  void initState() {
    pageListLocal.add(PrincipalLocal());
    pageListLocal.add(CategoriasLocal());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Responsive responsive = new Responsive.of(context);

    final bottomBloc = ProviderBloc.bottomLocal(context);
    if (bottomBloc.pageLocal == null) {
      bottomBloc.changePageLocal(0);
    }

    return Scaffold(
      body: StreamBuilder(
        stream: bottomBloc.selectPageLocalStream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return IndexedStack(
            index: (bottomBloc.pageLocal == null) ? 0 : bottomBloc.pageLocal,
            children: pageListLocal,
          );
        },
      ),
      bottomNavigationBar: bottonNaviga(responsive, bottomBloc),
    );
  }

  Widget bottonNaviga(Responsive responsive, BottomLocalBloc bottomBloc) {
    return StreamBuilder(
      stream: bottomBloc.selectPageLocalStream,
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
              icon: Icon(
                Icons.home,
                size: responsive.ip(3),
              ),
              label: 'Principal',
            ),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.near_me,
                  size: responsive.ip(3),
                ),
                label: 'Categorías'),
          ],
          currentIndex: bottomBloc.pageLocal,
          onTap: (index) => {
            bottomBloc.changePageLocal(index),
          },
        );
      },
    );
  }
}
