
import 'package:after_layout/after_layout.dart';
import 'package:enchiladasapp/src/pushProvider/push_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:enchiladasapp/src/utils/responsive.dart';

class DesicionPage extends StatefulWidget {
   
  @override
  _DesicionPageState createState() => _DesicionPageState();
}

class _DesicionPageState extends State<DesicionPage> with AfterLayoutMixin {
  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);
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
          _columDatos(context, responsive),
        ],
      ),
    );
  }

  Widget _columDatos(BuildContext context, Responsive responsive) {
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
            GestureDetector(
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
              onTap: (){
                Navigator.pushNamed(context, '/');
              },
            ),
            SizedBox(height: responsive.hp(5)),
            GestureDetector(
              child: Container(
                width: double.infinity,
                margin: EdgeInsets.only(left: responsive.wp(1.5)),
                height: responsive.hp(17),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image(
                      image: AssetImage('assets/market.png'),
                      fit: BoxFit.cover,
                    )),
              ),
              onTap: (){
                Navigator.pushNamed(context, 'market');
              },
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

  @override
  void afterFirstLayout(BuildContext context) {

    print('desicionPage');
    PushNotificationProvider pushNotificationProvider = PushNotificationProvider();
    pushNotificationProvider.initNotification();
  }
}
