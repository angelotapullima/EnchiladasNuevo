import 'dart:io';

import 'package:enchiladasapp/src/pages/ordenes/ordenes_pasadas.dart';
import 'package:enchiladasapp/src/pages/ordenes/ordenes_pendientes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OrdenesPagoPage extends StatefulWidget {
  @override
  _OrdenesPageState createState() => _OrdenesPageState();
}

class _OrdenesPageState extends State<OrdenesPagoPage> {
  List<Widget> pageList = List<Widget>();

  @override
  void initState() {
    pageList.add(OrdenesPendientes());
    pageList.add(OrdenesPasadas());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
        Navigator.popUntil(context, ModalRoute.withName('/'));
      },
      child: DefaultTabController(
        length: pageList.length,
        child: Scaffold(
          appBar: AppBar(
              title: Text('Pedidos'),
              leading: (Platform.isAndroid)
                  ? IconButton(
                      icon: Icon(Icons.arrow_back),
                      onPressed: () {
                        Navigator.popUntil(context, ModalRoute.withName('/'));
                      })
                  : IconButton(
                      icon: Icon(Icons.arrow_back_ios),
                      onPressed: () {
                        Navigator.popUntil(context, ModalRoute.withName('/'));
                      }),
              elevation: 0,
              backgroundColor: Colors.red,
              bottom: TabBar(
                labelColor: Colors.white,
                indicatorColor: Colors.white,
                indicator: UnderlineTabIndicator(
                  borderSide: BorderSide(color: Colors.white, width: 5.0),
                  insets: EdgeInsets.fromLTRB(70.0, 0.0, 70.0, 00.0),
                ),
                tabs: [
                  Tab(
                    //icon: Icon(Icons.add_location, color: Colors.white),
                    text: 'Pendientes',
                  ),
                  Tab(
                    //icon: Icon(Icons.add_location, color: Colors.white),
                    text: 'Pasados',
                  )
                ],
              )),
          body: TabBarView(
            children: pageList,
          ),
        ),
      ),
    );
  }
}
