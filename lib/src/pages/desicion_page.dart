import 'package:enchiladasapp/src/bloc/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:enchiladasapp/src/utils/responsive.dart';
import 'package:flutter_svg/svg.dart';

class DesicionPage extends StatefulWidget {
  @override
  _DesicionPageState createState() => _DesicionPageState();
}

class _DesicionPageState extends State<DesicionPage> {
  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);

    final pantallaBloc = ProviderBloc.pantalla(context);
    pantallaBloc.estadoPantalla();
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            decoration: new BoxDecoration(
              color: Colors.black12,
              image: new DecorationImage(
                image: new ExactAssetImage('assets/ladrillos.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: responsive.ip(1),
              ),
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: responsive.hp(12),
                  ),
                  Text(
                    'Elige una Opción',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: responsive.ip(3.8),
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: responsive.hp(10),
                  ),
                  GestureDetector(
                    child: Container(
                      width: double.infinity,
                      height: responsive.ip(20),
                      child: SvgPicture.asset('assets/icono_delivery.svg'),
                    ),
                    onTap: () {
                      Navigator.pushNamed(context, '/');
                    },
                  ),
                  SizedBox(
                    height: responsive.hp(10),
                  ),
                  GestureDetector(
                    child: Container(
                      width: double.infinity,
                      height: responsive.ip(20),
                      child: SvgPicture.asset('assets/icono_local.svg'),
                    ),
                    onTap: () {
                      Navigator.pushNamed(context, 'homeLocal');
                    },
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
