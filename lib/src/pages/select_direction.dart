import 'dart:async';

import 'package:enchiladasapp/src/bloc/provider.dart';
import 'package:enchiladasapp/src/models/direccion_model.dart';
import 'package:flutter/material.dart';
import 'package:enchiladasapp/src/utils/circle.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:enchiladasapp/src/utils/responsive.dart';
import 'package:enchiladasapp/src/utils/utilidades.dart' as utils;
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapsSample extends StatefulWidget {
  @override
  _MapsSampleState createState() => _MapsSampleState();
}

class _MapsSampleState extends State<MapsSample> {
  TextEditingController referenciaController = TextEditingController();
  TextEditingController direccionController = TextEditingController();
  final Set<Marker> _markers = Set();
  MapType _defaultMapType = MapType.normal;
  Completer<GoogleMapController> _controller = Completer();
  Timer _timer;

  @override
  void dispose() {
    direccionController.dispose();
    referenciaController.dispose();
    super.dispose();
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  CameraPosition currentPosition;
  double latitude = -3.747620420285213;
  double longitude = -73.24365925043821;
  String direccion = "";
  void _obtenerUbicacion() async {
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    latitude = position.latitude;
    longitude = position.longitude;
    _cargarGeocoding(context, latitude, longitude);
    currentPosition = CameraPosition(
      target: LatLng(latitude, longitude),
      zoom: 20,
    );
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(currentPosition));
  }

  @override
  void initState() {
    _obtenerUbicacion();
    currentPosition = CameraPosition(
      target: LatLng(latitude, longitude),
      zoom: 20,
    );
    //agregarMarket(LatLng(latitude,longitude));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);
    return Scaffold(
      body: Stack(
          children: <Widget>[
            Container(
              height: responsive.hp(65),
              child: GoogleMap(
                
                markers: _markers,
                mapType: _defaultMapType,
                myLocationEnabled: true,
                onMapCreated: _onMapCreated,
                initialCameraPosition: currentPosition,
                onCameraMove: (CameraPosition position) {
                  _timer?.cancel();
                  _timer = null;
                  _timer = new Timer(Duration(seconds: 1), () async {
                    print('${position.target}');

                    //agregarMarket(position.target);
                    _cargarGeocoding(context, position.target.latitude,
                        position.target.longitude);

                    setState(() {});
                  });
                },
              ),
            ),
            Positioned(
              top: responsive.hp(5),
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
            _modalDireccion(context, responsive),
            Container(
              height: responsive.hp(65),
              child: Center(
                child: Icon(
                  FontAwesomeIcons.mapPin,
                  color: Colors.red,
                ),
              ),
            )
          ],
        ),
    );
  }

  void agregarMarket(LatLng target) {
    setState(
      () {
        _markers.clear();
        _markers.add(
          Marker(
            markerId: MarkerId('Posición'),
            position: LatLng(target.latitude, target.longitude),
            infoWindow:
                InfoWindow(title: 'Posición', snippet: 'esta en mi posición'),
          ),
        );
      },
    );
  }

  void _cargarGeocoding(
      BuildContext context, double latGeo, double lonGeo) async {
    List<Placemark> placemark =
        await Geolocator().placemarkFromCoordinates(latGeo, lonGeo);
    direccion = "${placemark[0].thoroughfare} ${placemark[0].subThoroughfare}";
    print(direccion);
    utils.agregarDireccion(context, direccion, latitude, longitude, "");
    latitude = latGeo;
    longitude = lonGeo;
  }

  Widget _modalDireccion(BuildContext context, Responsive responsive) {
    final direcionBloc = ProviderBloc.dire(context);
    direcionBloc.obtenerDireccion();

    return StreamBuilder(
      stream: direcionBloc.direccionStream,
      builder: (BuildContext context, AsyncSnapshot<List<Direccion>> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.length > 0) {
            return contenidoDireccion(responsive, snapshot.data[0].direccion,
                snapshot.data[0].referencia);
          } else {
            return contenidoDireccion(responsive, "", "");
          }
        } else {
          return contenidoDireccion(responsive, "", "");
        }
      },
    );
  }

  Widget contenidoDireccion(
      Responsive responsive, String direccion, String referencia) {
    String refe = "";
    direccionController.text = direccion;
    if (referencia.isEmpty || referencia == null) {
      refe = 'Agregar referencia de dirección';
    } else {
      refe = referencia;
    }
    referenciaController.text = refe;
    return Padding(
      padding: EdgeInsets.only(top: responsive.hp(65)),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: responsive.wp(5)),
        width: double.infinity,
        decoration: BoxDecoration(
            borderRadius: BorderRadiusDirectional.only(
                topStart: Radius.circular(20), topEnd: Radius.circular(20)),
            boxShadow: [
              BoxShadow(color: Colors.black26, blurRadius: 5),
            ],
            color: Colors.white),
        child: Column(
          children: <Widget>[
            SizedBox(
              height: responsive.wp(2),
            ),
            Text(
              'Dirección de entrega',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: responsive.ip(2.5),
              ),
            ),
            SizedBox(
              height: responsive.hp(2),
            ),
            Container(
              padding: EdgeInsets.all(
                responsive.ip(.5),
              ),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.grey[200]),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  SizedBox(
                    width: responsive.wp(5),
                  ),
                  Icon(
                    FontAwesomeIcons.mapMarked,
                    color: Colors.red,
                  ),
                  SizedBox(
                    width: responsive.wp(5),
                  ),
                  Expanded(
                    child: Text(
                      direccion,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: responsive.ip(2),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: responsive.wp(5),
                  ),
                  IconButton(
                    icon: Icon(
                      FontAwesomeIcons.pencilAlt,
                    ),
                    color: Colors.red,
                    onPressed: () {
                      dialogoIngresarDireccion();
                    },
                  )
                ],
              ),
            ),
            SizedBox(
              height: responsive.hp(1),
            ),
            Container(
              padding: EdgeInsets.all(
                responsive.ip(.5),
              ),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.grey[200]),
              child: GestureDetector(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    SizedBox(
                      width: responsive.wp(5),
                    ),
                    Icon(
                      Icons.add,
                      color: Colors.red,
                    ),
                    SizedBox(
                      width: responsive.wp(5),
                    ),
                    Expanded(
                      child: Text(
                        refe,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: responsive.ip(2)),
                      ),
                    ),
                    SizedBox(
                      width: responsive.wp(5),
                    ),
                    IconButton(
                      icon: Icon(
                        FontAwesomeIcons.pencilAlt,
                      ),
                      color: Colors.red,
                      onPressed: () {
                        dialogoIngresarReferencia();
                      },
                    )
                  ],
                ),onTap: (){
                  dialogoIngresarReferencia();
                },
              ),
            ),
            SizedBox(
              height: responsive.hp(1),
            ),
             Container(
               width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.red),
                child: FlatButton(
                  child: Text(
                    'Confirmar',
                    style: TextStyle(fontSize: responsive.ip(2),color: Colors.white),
                  ),onPressed: () {
                Navigator.pop(context);
              },
                ),
              ) 
          ],
        ),
      ),
    );
  }

  void dialogoIngresarReferencia() {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (contextd) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            title: Text('Ingrese referencia de la dirección'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
                  controller: referenciaController,
                ),
                //Text('Producto agregado al carrito correctamente'),
                SizedBox(
                  height: 20.0,
                ),
              ],
            ),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancelar')),
              FlatButton(
                  onPressed: () async {
                    utils.agregarDireccion(context, direccionController.text,
                        latitude, longitude, referenciaController.text);

                    Navigator.pop(context);
                  },
                  child: Text('Ok')),
            ],
          );
        });
  }

  void dialogoIngresarDireccion() {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (contextd) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            title: Text('Ingrese su Dirección'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
                  controller: direccionController,
                ),
                //Text('Producto agregado al carrito correctamente'),
                SizedBox(
                  height: 20.0,
                ),
              ],
            ),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('cancelar')),
              FlatButton(
                  onPressed: () async {
                    utils.agregarDireccion(context, direccionController.text,
                        latitude, longitude, referenciaController.text);

                    Navigator.pop(context);
                  },
                  child: Text('ok')),
            ],
          );
        });
  }
}
