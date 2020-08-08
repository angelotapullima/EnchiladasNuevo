
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LocationPage extends StatefulWidget { 


 

  @override
  _LocationPage createState() => _LocationPage();
}

class _LocationPage extends State<LocationPage> {
  var platform =MethodChannel('example/angelo/location');
  String text='';
  bool estadoUbicacion= false;


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('titulillo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              child: Text('prueba'),
              onPressed: (){
                location();
              },
            ),
            Text(text,
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void location() async {
    String res;
    String estadoTracking;
    try{

      if(estadoUbicacion){
        estadoTracking = 'desactivar';
      }else{
        estadoTracking = 'activar';
      }


      res = await platform.invokeMethod("location","$estadoTracking  - algo" );
    }on Exception{
      res ='fallo todo , vamonos de putas';
    }

    setState(() {
      text=res;
      if(res =='activar'){
        estadoUbicacion = true;
      }else{
        estadoUbicacion = false;
      }
    });
  }
}
