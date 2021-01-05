import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:enchiladasapp/src/models/tracking_model.dart';
import 'package:enchiladasapp/src/pages/blocMapa/helpers/helpers.dart';
import 'package:enchiladasapp/src/utils/geoUtils.dart';
import 'package:enchiladasapp/src/utils/responsive.dart';
import 'package:enchiladasapp/src/utils/utilidades.dart' as utils;
import 'package:enchiladasapp/src/utils/preferencias_usuario.dart';
import 'package:flutter/material.dart' show BuildContext, Offset;
import 'package:meta/meta.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';

part 'mapa_event.dart';
part 'mapa_state.dart';

class MapaBloc extends Bloc<MapaEvent, MapaState> {
  MapaBloc() : super(new MapaState());

  // Controlador del mapa
  GoogleMapController _mapController;

  void initMapa(GoogleMapController controller) {
    if (!state.mapaListo) {
      this._mapController = controller;
      //this._mapController.setMapStyle( jsonEncode(uberMapTheme) );

      add(OnMapaListo());
    } else {
      this._mapController = controller;
    }
  }

  void moverCamara(LatLng destino) {
    final cameraUpdate = CameraUpdate.newLatLng(destino);
    print('funciona');
    this._mapController?.animateCamera(cameraUpdate);
  }

  @override
  Stream<MapaState> mapEventToState(MapaEvent event) async* {
    if (event is OnMapaListo) {
      yield state.copyWith(mapaListo: true);
    } else if (event is OnNuevaUbicacion) {
      yield* this._onNuevaUbicacion(event);
    } /* else if ( event is OnMarcarRecorrido ) {
      yield* this._onMarcarRecorrido( event );

    } */
    else if (event is OnSeguirUbicacion) {
      yield* this._onSeguirUbicacion(event);
    } else if (event is OnMovioMapa) {
      yield state.copyWith(ubicacionCentral: event.centroMapa);
    }
    /* else if ( event is OnCrearRutaInicioDestino ) {
      yield* _onCrearRutaInicioDestino( event );
    }  */
  }

  String distancia;
  Stream<MapaState> _onNuevaUbicacion(OnNuevaUbicacion event) async* {
    final responsive = Responsive.of(event.context);

    final prefences = Preferences();
    if (state.seguirUbicacion) {
      this.moverCamara(event.ubicacion);
    }

    var repartidor = LatLng(
      double.parse(event.pedido[0].trackingX),
      double.parse(event.pedido[0].trackingY),
    );

    var destino = LatLng(
      double.parse(event.pedido[0].pedidoX),
      double.parse(event.pedido[0].pedidoY),
    );

    var distance = GeoUtils.distanceInKmBetweenEarthCoordinates(
        repartidor.latitude,
        repartidor.longitude,
        destino.latitude,
        destino.longitude);

    distancia = distance.toString();
    distancia = utils.format(distance);

    final iconInicio =
        await getMarkerInicioIcon(double.parse(distancia), responsive);
    final iconDestino = await getMarkerDestinoIcon(
        '${prefences.personName} ', double.parse(distancia));

    final markerInicio = new Marker(
      anchor: Offset(0.0, 1.0),
      markerId: MarkerId('inicio'),
      position: event.ubicacion,
      icon: iconInicio,
      infoWindow: InfoWindow(
        title: 'Repartidor',
        snippet: 'Duración recorrido: ${(1 / 60).floor()} minutos',
      ),
    );

    final markerDestino = new Marker(
      markerId: MarkerId('destino'),
      position: destino, 
      icon: iconDestino,
      anchor: Offset(0.1, 0.90),
      infoWindow: InfoWindow(
        title: 'detino',
        snippet: 'Distancia: kilometros Km',
      ),
    );

    final newMarkers = {...state.markers};
    newMarkers['inicio'] = markerInicio;
    newMarkers['destino'] = markerDestino;

    yield state.copyWith(markers: newMarkers, pedido: event.pedido);
  }

  Stream<MapaState> _onSeguirUbicacion(OnSeguirUbicacion event) async* {
    if (!state.seguirUbicacion) {
      //this.moverCamara( this._miRuta.points[ this._miRuta.points.length - 1 ] );
    }
    yield state.copyWith(seguirUbicacion: !state.seguirUbicacion);
  }
}
