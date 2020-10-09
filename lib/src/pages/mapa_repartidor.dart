import 'dart:io';

import 'package:enchiladasapp/src/api/tracking_api.dart';
import 'package:enchiladasapp/src/models/pedidos_asignados_model.dart';
import 'package:enchiladasapp/src/utils/circle.dart';
import 'package:enchiladasapp/src/utils/responsive.dart';
import 'package:enchiladasapp/src/utils/utilidades.dart' as utils;
import 'package:enchiladasapp/src/widgets/preferencias_usuario.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:flutter/material.dart';
import 'dart:async';

const double CAMERA_ZOOM = 18;
/* 
const double CAMERA_TILT = 90;
const double CAMERA_BEARING = 80; */
const LatLng SOURCE_LOCATION = LatLng(42.747932, -71.167889);
const LatLng DEST_LOCATION = LatLng(37.335685, -122.0605916);

class MapaRepartidor extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MapaRepartidorState();
}

class MapaRepartidorState extends State<MapaRepartidor> {
  TextEditingController _comentariosController = TextEditingController();

  Completer<GoogleMapController> _controller = Completer();
  Set<Marker> _markers = Set<Marker>();
  final prefs = Preferences();
  bool mostrarCargandoTracking = false;
  bool pedidoTracking;
  int cant = 0;
// for my custom marker pins
  BitmapDescriptor sourceIcon;
  BitmapDescriptor destinationIcon;
// the user's initial location and current location
// as it moves
  LocationData currentLocation;
// a reference to the destination location
  LocationData destinationLocation;
// wrapper around the location API
  Location location;
  StreamSubscription<LocationData> locationSubscription;
  @override
  void initState() {
    super.initState();

    // create an instance of Location
    location = new Location();

    // subscribe to changes in the user's location
    // by "listening" to the location's onLocationChanged event
    locationSubscription =
        location.onLocationChanged().listen((LocationData cLoc) {
      // cLoc contains the lat and long of the
      // current user's position in real time,
      // so we're holding on to it
      currentLocation = cLoc;
      updatePinOnMap();
    });
    // set custom marker pins
    setSourceAndDestinationIcons();
    // set the initial location
    setInitialLocation();
  }

  @override
  void dispose() {
    locationSubscription.cancel();
    _comentariosController?.dispose();
    super.dispose();
  }

  void setSourceAndDestinationIcons() async {
    if (Platform.isAndroid) {
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
    } else {
      BitmapDescriptor.fromAssetImage(ImageConfiguration(devicePixelRatio: 2.0),
              'assets/pin_movil_ios.png')
          .then((onValue) {
        sourceIcon = onValue;
      });

      BitmapDescriptor.fromAssetImage(ImageConfiguration(devicePixelRatio: 2.0),
              'assets/destination_map_marker_ios.png')
          .then((onValue) {
        destinationIcon = onValue;
      });
    }
  }

  void setInitialLocation() async {
    // set the initial location by pulling the user's
    // current location from the location's getLocation()
    currentLocation = await location.getLocation();

    // hard-coded destination for this example
    destinationLocation = LocationData.fromMap({
      "latitude": DEST_LOCATION.latitude,
      "longitude": DEST_LOCATION.longitude
    });
  }

  @override
  Widget build(BuildContext context) {
    final PedidoAsignados data = ModalRoute.of(context).settings.arguments;
    final responsive = Responsive.of(context);

    if (cant == 0) {
      if (data.pedidoEstado == '2') {
        pedidoTracking = true;
      } else {
        pedidoTracking = false;
      }
    }

    CameraPosition initialCameraPosition = CameraPosition(
        zoom: CAMERA_ZOOM,
        /* 
        tilt: CAMERA_TILT,
        bearing: CAMERA_BEARING, */
        target: SOURCE_LOCATION);
    if (currentLocation != null) {
      initialCameraPosition = CameraPosition(
        target: LatLng(currentLocation.latitude, currentLocation.longitude),
        zoom:
            CAMERA_ZOOM, /* 
          tilt: CAMERA_TILT,
          bearing: CAMERA_BEARING */
      );
    }
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            GoogleMap(
                myLocationEnabled: true,
                compassEnabled: true,
                tiltGesturesEnabled: false,
                markers: _markers,
                mapType: MapType.normal,
                initialCameraPosition: initialCameraPosition,
                onTap: (LatLng loc) {},
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                  // my map has completed being created;
                  // i'm ready to show the pins on the map
                  showPinsOnMap();
                }),
            Positioned(
              top: responsive.hp(1),
              left: responsive.wp(18),
              right: responsive.wp(18),
              child: (!pedidoTracking)
                  ? GestureDetector(
                      child: CircleContainer(
                          widget: Text(
                            ' Terminar Tracking',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: responsive.ip(2)),
                          ),
                          radius: responsive.hp(3),
                          color: Colors.red),
                      onTap: () {
                        empezarTrackingApi(data.idEntrega, responsive);
                      },
                    )
                  : GestureDetector(
                      child: CircleContainer(
                          widget: Text(
                            'Empezar Tracking',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: responsive.ip(2),
                            ),
                          ),
                          radius: responsive.hp(3),
                          color: Colors.green),
                      onTap: () {
                        empezarTrackingApi(data.idEntrega, responsive);
                      },
                    ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Column(
                children: <Widget>[
                  (estadoTracking == 'activado')
                      ? GestureDetector(
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: responsive.wp(10),
                                vertical: responsive.hp(1.5)),
                            child: Text(
                              'desactivar ubicación',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: responsive.ip(2),
                              ),
                            ),
                            decoration: BoxDecoration(
                                color: (estadoTracking == 'activado')
                                    ? Colors.red
                                    : Colors.green,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20),
                                )),
                          ),
                          onTap: () {
                            activarUbicacion(data.idEntrega);
                          },
                        )
                      : GestureDetector(
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: responsive.wp(10),
                                vertical: responsive.hp(1.5)),
                            child: Text(
<<<<<<< HEAD
                              'activar ubicación',
=======
                              'Activar ubicación',
>>>>>>> 6d4518912d714fca50bd364fd78421c0bb01bf1a
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: responsive.ip(2),
                              ),
                            ),
                            decoration: BoxDecoration(
                                color: (estadoTracking == 'activado')
                                    ? Colors.red
                                    : Colors.green,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20),
                                )),
                          ),
                          onTap: () {
                            activarUbicacion(data.idEntrega);
                          },
                        ),
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300]),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                        color: Colors.grey[50]),
                    padding: EdgeInsets.symmetric(
                      horizontal: responsive.wp(3),
                      vertical: responsive.hp(2),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                '${data.pedidoNombre}',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                  fontSize: responsive.ip(2.5),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: responsive.hp(1),
                        ),
                        Row(
                          children: <Widget>[
                            Text('Dirección : ',
                                style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                    fontSize: responsive.ip(2))),
                            Expanded(child: Text('${data.pedidoDireccion} ')),
                          ],
                        ),
                        SizedBox(
                          height: responsive.hp(1),
                        ),
                        Row(
                          children: <Widget>[
                            Text('Referencia : ',
                                style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                    fontSize: responsive.ip(2))),
                            Expanded(child: Text('${data.pedidoReferencia} ')),
                          ],
                        ),
                        SizedBox(
                          height: responsive.hp(1),
                        ),
                        Row(
                          children: <Widget>[
                            Text(
                              'Teléfono : ',
                              style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                                fontSize: responsive.ip(2),
                              ),
                            ),
                            Expanded(child: Text(' ${data.pedidoTelefono}')),
                          ],
                        ),
                        SizedBox(
                          height: responsive.hp(1),
                        ),
                        Row(
                          children: <Widget>[
                            Text('Fecha : ',
                                style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                    fontSize: responsive.ip(2))),
                            Expanded(
                              child: Text(' ${data.pedidoFecha}'),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: responsive.hp(1),
                        ),
                        Text(
                          'S/. ${data.pedidoTotal}',
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                            fontSize: responsive.ip(3),
                          ),
                        ),
                        SizedBox(
                          height: responsive.hp(1),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            (mostrarCargandoTracking == true)
                ? Container(
                    width: double.infinity,
                    height: double.infinity,
                    color: Colors.white.withOpacity(.7),
                    child: Center(
                      child: CupertinoActivityIndicator(),
                    ),
                  )
                : Container(),
            Positioned(
              top: responsive.hp(1),
              left: responsive.wp(3),
              child: GestureDetector(
                child: CircleContainer(
                    radius: responsive.ip(2.5),
                    color: Colors.grey[200],
                    widget: BackButton()),
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

  var platform = MethodChannel('example/angelo/location');
  String estadoTracking = 'desactivado';

  void activarUbicacion(String idEntrega) async {
    String token = prefs.token;
    String idUser = prefs.idUser;

    if (estadoTracking == 'activado') {
      estadoTracking = 'desactivado';
      await platform.invokeMethod(
          "location", "$estadoTracking  - $token - $idUser - $idEntrega");
    } else {
      estadoTracking = 'activado';
      await platform.invokeMethod(
          "location", "$estadoTracking  - $token - $idUser - $idEntrega");
    }
  }

  void comentariosFinalizarEntrega(
      Responsive responsive, String idEntrega) async {
    return showDialog(
      barrierDismissible: true,
      context: context,
      builder: (_) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
          ),
          contentPadding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
          content: Container(
            margin: EdgeInsets.symmetric(horizontal: responsive.wp(2)),
            width: double.infinity,
            height: responsive.hp(28),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Ingrese los comentarios de la entrega',
                    style: TextStyle(
                        fontSize: responsive.ip(2.7),
                        color: Colors.red,
                        fontWeight: FontWeight.bold)),
                SizedBox(
                  height: responsive.hp(5),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: responsive.wp(2)),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.red),
                      borderRadius: BorderRadius.circular(5)),
                  child: TextField(
                    decoration:
                        InputDecoration(hintText: 'Ingrese lo comentarios'),
                    controller: _comentariosController,
                    maxLines: 3,
                  ),
                )
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              onPressed: () async {
                Navigator.pop(context);
              },
              child: Text('volver'),
            ),
            FlatButton(
                onPressed: () async {
                  final trackingApi = TrackingApi();
                  if (_comentariosController.text.isEmpty) {
                    //debe comentar algo pe tilin

                    utils.showToast(
                        'Por favor agregue comentarios', 2, ToastGravity.TOP);
                  } else {
                    final resp = await trackingApi.finalizarEntrega(
                        idEntrega, _comentariosController.text);
                    if (resp == 1) {
                      setState(() {
                        mostrarCargandoTracking = false;
                        pedidoTracking = true;
                        Navigator.pop(context);

                        cant++;
                      });
                    } else {
                      setState(() {
                        mostrarCargandoTracking = false;
                      });
                    }
                  }
                },
                child: Text('Continuar')),
          ],
        );
      },
    );
  }

  void empezarTrackingApi(String idEntrega, Responsive responsive) async {
    final trackingApi = TrackingApi();
    try {
      if (!pedidoTracking) {
        setState(() {
          mostrarCargandoTracking =
              true; //variable para mostrar la carga de la llamada de api
          comentariosFinalizarEntrega(responsive, idEntrega);
        });
      } else {
        setState(() {
          mostrarCargandoTracking = true;
        });

        final resp = await trackingApi.iniciarEntrega(idEntrega);
        if (resp == 1) {
          setState(() {
            mostrarCargandoTracking = false;

            pedidoTracking = false;
          });
        } else {
          setState(() {
            mostrarCargandoTracking = false;
          });
        }
        cant++;
      }
    } on Exception {}
  }

  void showPinsOnMap() {
    // get a LatLng for the source location
    // from the LocationData currentLocation object
    if (currentLocation != null) {
      var pinPosition =
          LatLng(currentLocation.latitude, currentLocation.longitude);
      // get a LatLng out of the LocationData object
      var destPosition =
          LatLng(destinationLocation.latitude, destinationLocation.longitude);

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

  void updatePinOnMap() async {
    // create a new CameraPosition instance
    // every time the location changes, so the camera
    // follows the pin as it moves with an animation
    CameraPosition cPosition = CameraPosition(
      zoom: CAMERA_ZOOM,
      /*  tilt: CAMERA_TILT,
      bearing: CAMERA_BEARING, */
      target: LatLng(currentLocation.latitude, currentLocation.longitude),
    );
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(cPosition));
    // do this inside the setState() so Flutter gets notified
    // that a widget update is due
    setState(() {
      // updated position
      var pinPosition =
          LatLng(currentLocation.latitude, currentLocation.longitude);

      // the trick is to remove the marker (by id)
      // and add it again at the updated location
      _markers.removeWhere((m) => m.markerId.value == 'sourcePin');
      _markers.add(
        Marker(
            markerId: MarkerId('sourcePin'),
            position: pinPosition, // updated position
            icon: sourceIcon),
      );
    });
  }
}
