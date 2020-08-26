import 'package:enchiladasapp/src/bloc/provider.dart';
import 'package:enchiladasapp/src/models/arguments.dart';
import 'package:enchiladasapp/src/utils/circle.dart';
import 'package:enchiladasapp/src/utils/responsive.dart';
import 'package:enchiladasapp/src/utils/utilidades.dart' as utils;
import 'package:enchiladasapp/src/widgets/preferencias_usuario.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:enchiladasapp/src/search/search_delegate.dart';
import 'package:fluttertoast/fluttertoast.dart';

class PrincipalTab extends StatelessWidget {
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
    return Stack(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(color: Colors.red),
          height: responsive.hp(13),
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: responsive.wp(2.5), vertical: responsive.hp(0.8)),
              child: Column(
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
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
                      IconButton(
                        onPressed: () {
                          showSearch(
                            context: context,
                            delegate: DataSearch(hintText: 'Buscar'),
                          );
                        },
                        icon: Icon(
                          Icons.search,
                          color: Colors.white,
                          size: responsive.ip(3.5),
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
        ),
        _contenido(context, responsive)
      ],
    );
  }

  Widget _contenido(BuildContext context, Responsive responsive) {
    return Padding(
        padding: EdgeInsets.only(top: responsive.hp(12)),
        child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadiusDirectional.circular(13.8),
                color: Colors.white),
            padding: EdgeInsets.symmetric(horizontal: responsive.wp(3)),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: responsive.hp(1.5),
                  ),
                  _comboDelDia(context, responsive),
                  SizedBox(
                    height: responsive.hp(1.5),
                  ),
                  _especialDia(context, responsive),
                  SizedBox(
                    height: responsive.hp(1.5),
                  ),
                  _categorias(responsive, context),
                  SizedBox(
                    height: responsive.hp(1.5),
                  ),
                  _tableRow(context, responsive),
                  SizedBox(
                    height: responsive.hp(1.5),
                  ),
                ],
              ),
            ),),);
  }

  Widget _comboDelDia(BuildContext context, Responsive responsive) {
    return GestureDetector(
      child: Container(
        width: double.infinity,
        height: responsive.hp(17),
        child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image(
              image: AssetImage('assets/combo.png'),
              fit: BoxFit.cover,
            )),
      ),
      onTap: () {
        Arguments arg = new Arguments("Combos Delivery", '54');
        //Navigator.pushNamed(context, 'timeline', arguments: arg);
        Navigator.pushNamed(context, 'combo', arguments: arg);
      },
    );
  }

  Widget _especialDia(BuildContext context, Responsive responsive) {
    return GestureDetector(
      child: Container(
        width: double.infinity,
        height: responsive.hp(17),
        child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image(
              image: AssetImage('assets/especial-dia.png'),
              fit: BoxFit.cover,
            )),
      ),
      onTap: () {
        Arguments arg = new Arguments("Especial del día", '52');
        Navigator.pushNamed(context, 'combo', arguments: arg);
      },
    );
  }

  Widget _tableRow(BuildContext context, Responsive responsive) {
    return Table(
      children: [
        TableRow(children: [
          _puzzle(context, responsive),
          _market247(responsive, context),
          //_market(responsive),
        ])
      ],
    );
  }

  Widget _market247(Responsive responsive, BuildContext context) {
    return GestureDetector(
      child: Container(
        width: double.infinity,
        height: responsive.hp(17),
        child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image(
              image: AssetImage('assets/market.png'),
              fit: BoxFit.cover,
            )),
      ),
      onTap: () {
        Navigator.pushNamed(context, 'market');
      },
    );
  }

  Widget _puzzle(BuildContext context, Responsive responsive) {
    final prefs = new Preferences();
    return GestureDetector(
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.only(right: responsive.wp(1.5)),
        height: responsive.hp(17),
        child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image(
              image: AssetImage('assets/enchilada-puzle.png'),
              fit: BoxFit.cover,
            ),),
      ),
      onTap: () {
        if(prefs.rol == '5') {

        Navigator.pushNamed(context, 'HomePuzzle');
        }else{
          utils.showToast('Debe registrarse para acceder al Puzzle', 2,ToastGravity.TOP);
        }
      },
    );
  }

  _categorias(Responsive responsive, BuildContext context) {
    return GestureDetector(
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.only(left: responsive.wp(0.5)),
        height: responsive.hp(17),
        child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image(
              image: AssetImage('assets/menu.png'),
              fit: BoxFit.cover,
            )),
      ),
      onTap: () {
        final bottomBloc = ProviderBloc.bottom(context);
        bottomBloc.changePage(2);
      },
    );
  }
}
