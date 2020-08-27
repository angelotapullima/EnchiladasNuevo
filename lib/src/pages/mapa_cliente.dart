import 'dart:async';

import 'package:enchiladasapp/src/api/tracking_api.dart';
import 'package:enchiladasapp/src/utils/circle.dart';
import 'package:enchiladasapp/src/utils/geoUtils.dart';
import 'package:enchiladasapp/src/utils/responsive.dart';
import 'package:enchiladasapp/src/utils/utilidades.dart' as utils;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapaCliente extends StatefulWidget {
  @override
  _MapaClienteState createState() => _MapaClienteState();
}

class _MapaClienteState extends State<MapaCliente> {
  Completer<GoogleMapController> _controller = Completer();
  int count = 1;
  Set<Marker> _markers = Set<Marker>();
  CameraPosition currentPosition;
  double latitude = -3.7545224;
  double longitude = -73.2714435;
  bool banderaTimer = true;
  Timer timer;
  int cant = 0;

  void _obtenerUbicacion() async {
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    latitude = position.latitude;
    longitude = position.longitude;
    currentPosition = CameraPosition(
      target: LatLng(latitude, longitude),
      zoom: 19,
    );
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(currentPosition));
  }

  @override
  void dispose() {
    banderaTimer = false;
    print('dispose bb');

    timer.cancel();
    super.dispose();
  }

  String idPedidoTrack = "0";
  String nombreRepartidor = '--';
  String distancia = '';
  String direccionEntrega = '--';
  String idRepartidor = '--';
  String imagenRepartidor;
  @override
  void initState() {
    setSourceAndDestinationIcons();
    _obtenerUbicacion();
    currentPosition = CameraPosition(
      target: LatLng(latitude, longitude),
      zoom: 19,
    );

     timer = Timer.periodic(Duration(seconds: 3), (Timer t) {
      if(banderaTimer){
        print('pedido true ');
        trackingRepartidor(idPedidoTrack);
     } else {
        print('cancelar pedido ');
        timer.cancel();
      } 
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final String idPedido = ModalRoute.of(context).settings.arguments;
    idPedidoTrack = idPedido;
    print('id pedido $idPedido');
    final responsive = Responsive.of(context);

   
    /*  */
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Container(
              height: responsive.hp(62),
              child: GoogleMap(
                  myLocationEnabled: true,
                  compassEnabled: true,
                  tiltGesturesEnabled: true,
                  markers: _markers,
                  mapType: MapType.normal,
                  initialCameraPosition: currentPosition,
                  onTap: (LatLng loc) {},
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                  }),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: responsive.hp(35),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20)),
                    color: Colors.white),
                child: Column(
                  children: <Widget>[
                    Container(
                        height: responsive.hp(12),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20)),
                            color: Colors.red),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: responsive.wp(2),
                              vertical: responsive.hp(2)),
                          child: Row(
                            children: <Widget>[
                              CircleAvatar(
                                radius: 25,
                                child: ClipOval(
                                    child: Image.network(
                                  '$imagenRepartidor',
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                )),
                              ),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      '$nombreRepartidor',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: responsive.ip(2)),
                                    ),
                                    Text(
                                      'Repartidor $idRepartidor',
                                      style: TextStyle(color: Colors.white),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: responsive.hp(1)),
                      height: responsive.hp(23),
                      child: Row(
                        children: <Widget>[
                          Container(
                            width: responsive.wp(20),
                            color: Colors.white,
                            child: Column(
                              children: <Widget>[
                                Icon(
                                  Icons.directions_transit,
                                  color: Colors.red,
                                ),
                                Container(
                                  margin: EdgeInsets.symmetric(
                                      vertical: responsive.hp(.5)),
                                  width: responsive.wp(1),
                                  height: responsive.hp(2),
                                  color: Colors.orange,
                                ),
                                Container(
                                  margin: EdgeInsets.symmetric(
                                      vertical: responsive.hp(.5)),
                                  width: responsive.wp(1),
                                  height: responsive.hp(2),
                                  color: Colors.orange,
                                ),
                                Container(
                                  margin: EdgeInsets.symmetric(
                                      vertical: responsive.hp(.5)),
                                  width: responsive.wp(1),
                                  height: responsive.hp(2),
                                  color: Colors.orange,
                                ),
                                Container(
                                  margin: EdgeInsets.symmetric(
                                      vertical: responsive.hp(.5)),
                                  width: responsive.wp(1),
                                  height: responsive.hp(2),
                                  color: Colors.orange,
                                ),
                                Icon(Icons.map)
                              ],
                            ),
                          ),
                          Container(
                            width: responsive.wp(80),
                            color: Colors.white,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  'Distancia aprox. de Repartidor',
                                  style: TextStyle(fontSize: responsive.ip(2)),
                                ),
                                Text('$distancia Km',
                                    style: TextStyle(
                                        fontSize: responsive.ip(2.1),
                                        fontWeight: FontWeight.bold)),
                                SizedBox(
                                  height: responsive.hp(8),
                                ),
                                Text('Dirección de entrega',
                                    style:
                                        TextStyle(fontSize: responsive.ip(2))),
                                Text('$direccionEntrega',
                                    style: TextStyle(
                                        fontSize: responsive.ip(2.1),
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            Positioned(
              top: responsive.hp(2.8),
              left: responsive.wp(3),
              child: GestureDetector(
                child: CircleContainer(
                  radius: responsive.ip(2.5),
                  color: Colors.grey[200],
                  widget: Icon(Icons.arrow_back, color: Colors.black),
                ),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  BitmapDescriptor sourceIcon;
  BitmapDescriptor destinationIcon;

  void setSourceAndDestinationIcons() async {
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration(devicePixelRatio: 2.0), 'assets/pin_movil.png')
        .then((onValue) {
      sourceIcon = onValue;
    });

    BitmapDescriptor.fromAssetImage(ImageConfiguration(devicePixelRatio: 2.0),
            'assets/destination_map_marker.png')
        .then((onValue) {
      destinationIcon = onValue;
    });
  }

  void showPinsOnMap(LatLng repartidor, LatLng destino) {
    // get a LatLng for the source location
    // from the LocationData currentLocation object
    if (repartidor != null) {
      var pinPosition = LatLng(repartidor.latitude, repartidor.longitude);
      // get a LatLng out of the LocationData object
      var destPosition = LatLng(destino.latitude, destino.longitude);

      // add the initial source location pin
      _markers.add(Marker(
          markerId: MarkerId('sourcePin'),
          position: pinPosition,
          icon: sourceIcon));
      // destination pin
      _markers.add(Marker(
          markerId: MarkerId('destPin'),
          position: destPosition,
          icon: destinationIcon));
    }

    // set the route lines on the map from source to destination
    // for more info follow this tutorial
    //setPolylines();
  }

  void updatePinOnMap(double latitud, double longitud) async {
    // create a new CameraPosition instance
    // every time the location changes, so the camera
    // follows the pin as it moves with an animation
    CameraPosition cPosition = CameraPosition(
      zoom: 16,
      //tilt: CAMERA_TILT,
      //bearing: CAMERA_BEARING,
      target: LatLng(latitud, longitud),
    );
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(cPosition));
    // do this inside the setState() so Flutter gets notified
    // that a widget update is due
    setState(() {
      // updated position
      var pinPosition = LatLng(latitud, longitud);

      // the trick is to remove the marker (by id)
      // and add it again at the updated location
      _markers.removeWhere((m) => m.markerId.value == 'sourcePin');
      _markers.add(Marker(
          markerId: MarkerId('sourcePin'),
          position: pinPosition, // updated position
          icon: sourceIcon));
    });
  }

  LatLng destino, repartidor;
  void trackingRepartidor(String idPedido) async {
    print('empezamos el timer $idPedido');
    final trackingApi = TrackingApi();
    final list = await trackingApi.trackingRepartidor(idPedido);
    if (list.length > 0) {
      print('resp aceptada');
      print(list[0].pedidoEstado);
      if (list[0].pedidoEstado == '3') {
        if (count == 1) {
          nombreRepartidor = list[0].personName;

          direccionEntrega = list[0].pedidoDireccion;
          idRepartidor = list[0].idRepartidor;
          imagenRepartidor = list[0].userImage;
          //repartidor = list[0].
          repartidor = LatLng(
              double.parse(list[0].trackingX), double.parse(list[0].trackingY));
          destino = LatLng(
              double.parse(list[0].pedidoX), double.parse(list[0].pedidoY));

          showPinsOnMap(repartidor, destino);
          count++;
          setState(() {});
        } else {
          //actualixavion de prueba
          nombreRepartidor = list[0].personName;

          direccionEntrega = list[0].pedidoDireccion;
          idRepartidor = list[0].idRepartidor;
          imagenRepartidor = list[0].userImage;
          print("latitud ${list[0].trackingX} , longitud ${list[0].trackingY}");
          repartidor = LatLng(
              double.parse(list[0].trackingX), double.parse(list[0].trackingY));
          updatePinOnMap(
              double.parse(list[0].trackingX), double.parse(list[0].trackingY));
          var distance = GeoUtils.distanceInKmBetweenEarthCoordinates(
              repartidor.latitude,
              repartidor.longitude,
              destino.latitude,
              destino.longitude);
          print('distance $distance');
          distancia = distance.toString();
          distancia = utils.format(distance);

          setState(() {});
        }
      } else {
        //mostrar funcion de que el pedido ya fue
        banderaTimer = false;
        _pedidoYaFue(context);
      }
    } else {
      Fluttertoast.showToast(
          msg: 'Problemas con la conexion a internet',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 3,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  void _pedidoYaFue(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (contextd) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            title: Text('El repartidor ya llego a su destino'),
            actions: <Widget>[
              FlatButton(
                  onPressed: () async {
                    Navigator.pop(context);
                  },
                  child: Text('Continuar')),
            ],
          );
        });
  }
}
