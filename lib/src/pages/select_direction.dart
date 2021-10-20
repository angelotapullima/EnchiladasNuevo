import 'dart:async';

import 'package:enchiladasapp/src/bloc/provider.dart';
import 'package:enchiladasapp/src/models/zona_model.dart';
import 'package:flutter/material.dart';
import 'package:enchiladasapp/src/utils/circle.dart';
import 'package:fluttertoast/fluttertoast.dart';
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

  String dropdownDistrito = '';
  int cantItems = 0;

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
  String refe = "";
  String idDistrito;
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
            height: responsive.hp(61),
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
                widget: Center(child: BackButton()),
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ),
          contenidoDireccion(context, responsive),
          Container(
            height: responsive.hp(61),
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

    direccionController.text = direccion;
    
    latitude = latGeo;
    longitude = lonGeo;
    setState(() {});
  }

  List<String> list;
  Widget contenidoDireccion(
    BuildContext context,
    Responsive responsive,
  ) {
    final zonaBloc = ProviderBloc.zona(context);
    zonaBloc.obtenerZonas();
    //direccionController.text = direccion;
    if (refe.isEmpty) {
      refe = '1';
    } else {
      refe = refe;
    }
    //referenciaController.text = refe;
    return StreamBuilder(
        stream: zonaBloc.zonasStream,
        builder: (BuildContext context, AsyncSnapshot<List<Zona>> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.length > 0) {
              if (cantItems == 0) {
                list =[];
                list.add('Seleccionar Distrito');

                for (int i = 0; i < snapshot.data.length; i++) {
                  String nombreDistritos = snapshot.data[i].zonaNombre;
                  list.add(nombreDistritos);
                }
                dropdownDistrito = 'Seleccionar Distrito';
/* 
                dropdownDistrito = "${snapshot.data[0].zonaNombre}";
                idDistrito = "${snapshot.data[0].idZona}"; */
              }

              return Padding(
                padding: EdgeInsets.only(top: responsive.hp(55)),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: responsive.wp(5)),
                  width: double.infinity,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadiusDirectional.only(
                        topStart: Radius.circular(20),
                        topEnd: Radius.circular(20),
                      ),
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
                        height: responsive.hp(6),
                        padding: EdgeInsets.all(
                          responsive.ip(.5),
                        ),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.grey[200]),
                        child: GestureDetector(
                          onTap: (){
                            direccionController.text = direccion;
                            modalIngresarDireccion();
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              SizedBox(
                                width: responsive.wp(5),
                              ),
                              Icon(
                                FontAwesomeIcons.mapMarked,
                                color: Colors.red,
                                size: responsive.ip(2.5),
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
                                  size: responsive.ip(2.5),
                                ),
                                color: Colors.red,
                                onPressed: () {
                                  direccionController.text = direccion;
                                  modalIngresarDireccion();
                                },
                              )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: responsive.hp(1),
                      ),
                      Container(
                        height: responsive.hp(6),
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
                                size: responsive.ip(2.5),
                              ),
                              SizedBox(
                                width: responsive.wp(5),
                              ),
                              Expanded(
                                child: Text(
                                  (refe == '1')
                                      ? 'Agregar referencia de Dirección'
                                      : refe,
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style:
                                      TextStyle(fontSize: responsive.ip(1.8)),
                                ),
                              ),
                              SizedBox(
                                width: responsive.wp(5),
                              ),
                              IconButton(
                                icon: Icon(
                                  FontAwesomeIcons.pencilAlt,
                                  size: responsive.ip(2.5),
                                ),
                                color: Colors.red,
                                onPressed: () {
                                  modalIngresarReferencia();
                                },
                              )
                            ],
                          ),
                          onTap: () {
                            modalIngresarReferencia();
                          },
                        ),
                      ),
                      SizedBox(
                        height: responsive.hp(1),
                      ),
                      Container(
                        height: responsive.hp(6),
                        width: double.infinity,
                        padding: EdgeInsets.all(
                          responsive.ip(.5),
                        ),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.grey[200]),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: responsive.wp(4),
                          ),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            border: Border.all(color: Colors.transparent),
                          ),
                          child: DropdownButton<String>(
                            dropdownColor: Colors.white,
                            value: dropdownDistrito,
                            icon: Icon(Icons.arrow_drop_down),
                            iconSize: 24,
                            elevation: 16,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: responsive.ip(2.5),
                            ),
                            underline: Container(),
                            onChanged: (String data) {
                              setState(() {
                                dropdownDistrito = data;
                                cantItems++;
                                obtenerIdDistrito(data, snapshot.data);
                              });
                            },
                            isExpanded: true,
                            items: list.map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: responsive.ip(2),
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: (){

                          if (direccionController.text == '') {
                              utils.showToast('Por favor ingrese una dirección',
                                  2, ToastGravity.TOP);
                            } else {
                              
                              if (referenciaController.text == '') {
                                utils.showToast(
                                    'Por favor ingrese una referencia',
                                    2,
                                    ToastGravity.TOP);
                              } else {
                                if (dropdownDistrito ==
                                    'Seleccionar Distrito') {
                                  utils.showToast(
                                      'Por favor seleccione un distrito',
                                      2,
                                      ToastGravity.TOP);
                                } else {
                                  //aca es

                                  utils.agregarDireccion(
                                      context,
                                      direccionController.text,
                                      latitude,
                                      longitude,
                                      referenciaController.text,
                                      idDistrito);
                                  Navigator.pop(context);
                                }
                              }
                            }
                        },
                        child: Container(
                          margin: EdgeInsets.only(top: responsive.hp(.8)),
                          width: double.infinity,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.red),
                          child: MaterialButton(
                            child: Text(
                              'Confirmar',
                              style: TextStyle(
                                  fontSize: responsive.ip(2),
                                  color: Colors.white),
                            ),
                            onPressed: () {
                              if (direccionController.text == '') {
                                utils.showToast('Por favor ingrese una dirección',
                                    2, ToastGravity.TOP);
                              } else {
                                
                                if (referenciaController.text == '') {
                                  utils.showToast(
                                      'Por favor ingrese una referencia',
                                      2,
                                      ToastGravity.TOP);
                                } else {
                                  if (dropdownDistrito ==
                                      'Seleccionar Distrito') {
                                    utils.showToast(
                                        'Por favor seleccione un distrito',
                                        2,
                                        ToastGravity.TOP);
                                  } else {
                                    //aca es

                                    utils.agregarDireccion(
                                        context,
                                        direccionController.text,
                                        latitude,
                                        longitude,
                                        referenciaController.text,
                                        idDistrito);
                                    Navigator.pop(context);
                                  }
                                }
                              }
                            },
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              );
            } else {
              return Container();
            }
          } else {
            return Container();
          }
        });
  }

  void obtenerIdDistrito(String dato, List<Zona> list) {
    for (int i = 0; i < list.length; i++) {
      if (dato == list[i].zonaNombre) {
        idDistrito = list[i].idZona;
      }
    }
    
  }

  void modalIngresarReferencia() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        final responsive = Responsive.of(context);
        return GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Container(
            padding: MediaQuery.of(context).viewInsets,
            margin: EdgeInsets.only(top: responsive.hp(10)),
            decoration: BoxDecoration(
                borderRadius: BorderRadiusDirectional.only(
                  topEnd: Radius.circular(20),
                  topStart: Radius.circular(20),
                ),
                color: Colors.white),
            child: Padding(
              padding: EdgeInsets.only(
                top: responsive.hp(2),
                left: responsive.wp(5),
                right: responsive.wp(5),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    'Ingrese Referencia de Dirección',
                    style: TextStyle(
                        fontSize: responsive.ip(2.5),
                        fontWeight: FontWeight.bold),
                  ),
                  TextField(
                    controller: referenciaController,
                  ),
                  SizedBox(
                    height: responsive.hp(3),
                  ),
                  MaterialButton(
                    onPressed: () async {
                      Navigator.pop(context);
                      refe= referenciaController.text;
                      setState(() {});
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: responsive.ip(5),
                        vertical: responsive.ip(1),
                      ),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: Colors.red),
                      child: Text(
                        'Confirmar',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void modalIngresarDireccion() {
    //direccionController.text = "";
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        final responsive = Responsive.of(context);
        return GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Container(
            padding: MediaQuery.of(context).viewInsets,
            margin: EdgeInsets.only(top: responsive.hp(10)),
            decoration: BoxDecoration(
                borderRadius: BorderRadiusDirectional.only(
                  topEnd: Radius.circular(20),
                  topStart: Radius.circular(20),
                ),
                color: Colors.white),
            child: Padding(
              padding: EdgeInsets.only(
                top: responsive.hp(2),
                left: responsive.wp(5),
                right: responsive.wp(5),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    'Ingrese su Dirección',
                    style: TextStyle(
                        fontSize: responsive.ip(2.5),
                        fontWeight: FontWeight.bold),
                  ),
                  TextField(
                    controller: direccionController,
                  ),
                  SizedBox(
                    height: responsive.hp(3),
                  ),
                  MaterialButton(
                    onPressed: () async {
                      Navigator.pop(context);
                      direccion = direccionController.text;
                      setState(() {});
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: responsive.ip(5),
                        vertical: responsive.ip(1),
                      ),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: Colors.red),
                      child: Text(
                        'Confirmar',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
