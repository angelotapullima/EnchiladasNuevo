


import 'package:enchiladasapp/src/bloc/provider.dart';
import 'package:enchiladasapp/src/utils/preferencias_usuario.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:enchiladasapp/src/utils/responsive.dart';
import 'package:showcaseview/showcaseview.dart';

class DesicionPage extends StatefulWidget {
  @override
  _DesicionPageState createState() => _DesicionPageState();
}

class _DesicionPageState extends State<DesicionPage> {
  GlobalKey _one = GlobalKey();
  GlobalKey _two = GlobalKey();




  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);
    final preferences = Preferences();

    final pantallaBloc = ProviderBloc.pantalla(context);
    pantallaBloc.estadoPantalla();
    return StreamBuilder(
      stream: pantallaBloc.estadoDesicionStream,
      builder: (context, snapshot) {

        if(snapshot.hasData){
          if(snapshot.data){
          return _conMarket(preferences, responsive);
        }else{
          return _sinMarket(preferences, responsive);
        }
        }else{
          return Center(child:CupertinoActivityIndicator());
        }
        
        
      }
    );
  }

  Widget _conMarket(Preferences preferences, Responsive responsive) {
    return ShowCaseWidget(
        onFinish: () {
          preferences.pantallaSeleccion = '1';
        },
        autoPlay: false,
        autoPlayDelay: Duration(seconds: 7),
        autoPlayLockEnable: true,
        builder: Builder(builder: (context) {
          if (preferences.pantallaSeleccion != "1") {
            WidgetsBinding.instance.addPostFrameCallback(
                (_) => ShowCaseWidget.of(context).startShowCase([_one, _two]));
          }

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
                _columDatosConMarket(context, responsive),
              ],
            ),
          );
        }),
      );
  }


  Widget _sinMarket(Preferences preferences, Responsive responsive) {
    return ShowCaseWidget(
        onFinish: () {
          preferences.pantallaSeleccion = '1';
        },
        autoPlay: false,
        autoPlayDelay: Duration(seconds: 7),
        autoPlayLockEnable: true,
        builder: Builder(builder: (context) {
          if (preferences.pantallaSeleccion != "1") {
            WidgetsBinding.instance.addPostFrameCallback(
                (_) => ShowCaseWidget.of(context).startShowCase([_one]));
          }

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
                _columDatosSinMarket(context, responsive),
              ],
            ),
          );
        }),
      );
  }


 Widget _columDatosSinMarket(BuildContext context, Responsive responsive) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: responsive.ip(5)),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: responsive.hp(12)),
              Text(
                'Elige una Opción',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: responsive.ip(3.8),
                    fontWeight: FontWeight.bold),
              ),
              Container(
                height: responsive
                    .hp(5), /*  child: SizedBox(height: responsive.hp(20)) */
              ),
              Showcase(
                key: _one,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: responsive.wp(20),
                  vertical: responsive.hp(2),
                ),
                description:
                    'Aquí podrás ver toda la información  de La Casa de las Enchiladas',
                child: GestureDetector(
                  child: Container(
                    width: double.infinity,
                    margin: EdgeInsets.only(left: responsive.wp(1.5)),
                    height: responsive.hp(23),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image(
                          image: AssetImage('assets/logo_enchilada.png'),
                          fit: BoxFit.contain,
                        )),
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, '/');
                  },
                ),
              ),
              SizedBox(
                height: responsive.hp(5),
              ),
              Container(
                height: responsive
                    .hp(23), /*  child: SizedBox(height: responsive.hp(20)) */
              ),
            ],
          ),
        ),
      ),
    );
  }



  Widget _columDatosConMarket(BuildContext context, Responsive responsive) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: responsive.ip(5)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: responsive.hp(12)),
            Text(
              'Elige una Opción',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: responsive.ip(3.8),
                  fontWeight: FontWeight.bold),
            ),
            Container(
              height: responsive
                  .hp(5), /*  child: SizedBox(height: responsive.hp(20)) */
            ),
            Showcase(
              key: _one,
              contentPadding: EdgeInsets.symmetric(
                horizontal: responsive.wp(20),
                vertical: responsive.hp(2),
              ),
              description:
                  'Aquí podrás ver toda la información  de La Casa de las Enchiladas',
              child: GestureDetector(
                child: Container(
                  width: double.infinity,
                  margin: EdgeInsets.only(left: responsive.wp(1.5)),
                  height: responsive.hp(23),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image(
                        image: AssetImage('assets/logo_enchilada.png'),
                        fit: BoxFit.contain,
                      )),
                ),
                onTap: () {
                  Navigator.pushNamed(context, '/');
                },
              ),
            ),
            SizedBox(
              height: responsive.hp(5),
            ),
            Showcase(
              key: _two,
              contentPadding: EdgeInsets.symmetric(
                  horizontal: responsive.wp(20), vertical: responsive.hp(2)),
              description: 'Aquí podrás ver toda la información de Market247',
              child: GestureDetector(
                child: Container(
                  width: double.infinity,
                  margin: EdgeInsets.only(
                    left: responsive.wp(1.5),
                  ),
                  height: responsive.hp(17),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image(
                      image: AssetImage('assets/market.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                onTap: () {
                  Navigator.pushNamed(context, 'market');
                },
              ),
            ),
            Container(
              height: responsive
                  .hp(23), /*  child: SizedBox(height: responsive.hp(20)) */
            ),
          ],
        ),
      ),
    );
  }
/* 
  @override
  void afterFirstLayout(BuildContext context) {
    print('desicionPage');
    PushNotificationProvider pushNotificationProvider =
        PushNotificationProvider();
    pushNotificationProvider.initNotification();
  } */
}
