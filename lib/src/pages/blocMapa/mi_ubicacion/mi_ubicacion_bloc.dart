import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:enchiladasapp/src/api/tracking_api.dart';
import 'package:enchiladasapp/src/models/tracking_model.dart';
import 'package:enchiladasapp/src/utils/geoUtils.dart';
import 'package:enchiladasapp/src/utils/utilidades.dart' as utils;
import 'package:meta/meta.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' show LatLng;

part 'mi_ubicacion_event.dart';
part 'mi_ubicacion_state.dart';

class MiUbicacionBloc extends Bloc<MiUbicacionEvent, MiUbicacionState> {
  MiUbicacionBloc() : super(MiUbicacionState());

  bool llamarApi = true;
  String distancia;

  //final _geolocator = new Geolocator();
  StreamSubscription<List<TrackingData>> _positionSubscription;

  void iniciarSeguimiento(String idPedido) {
    final List<TrackingData> listaTrack = [];

    _positionSubscription = Stream.periodic(Duration(seconds: 2), (_) {}).asyncMap((event2) async {
      //print(event2);

      if (llamarApi) {
        List<TrackingData> list = [];
        final trackingApi = TrackingApi();
        list = await trackingApi.trackingRepartidor(idPedido);

        if (list[0].pedidoEstado != '3') {
          llamarApi = false;
        }

        return list;
      }
    }).listen((respuestaAPI) {
      if (respuestaAPI != null) {
        listaTrack.clear();

        var repartidor = LatLng(
          double.parse(respuestaAPI[0].trackingX),
          double.parse(respuestaAPI[0].trackingY),
        );

        var destino = LatLng(
          double.parse(respuestaAPI[0].pedidoX),
          double.parse(respuestaAPI[0].pedidoY),
        );

        var distance = GeoUtils.distanceInKmBetweenEarthCoordinates(repartidor.latitude, repartidor.longitude, destino.latitude, destino.longitude);

        distancia = distance.toString();
        distancia = utils.format(distance);

        print('csmare $distance');

        TrackingData trackingData = new TrackingData();
        trackingData.idPedido = respuestaAPI[0].idPedido;
        trackingData.idEntrega = respuestaAPI[0].idEntrega;
        trackingData.pedidoEstado = respuestaAPI[0].pedidoEstado;
        trackingData.personName = respuestaAPI[0].personName;
        trackingData.pedidoDireccion = respuestaAPI[0].pedidoDireccion;
        trackingData.idRepartidor = respuestaAPI[0].idRepartidor;
        trackingData.userImage = respuestaAPI[0].userImage;
        trackingData.pedidoX = respuestaAPI[0].pedidoX;
        trackingData.pedidoY = respuestaAPI[0].pedidoY;
        trackingData.trackingX = respuestaAPI[0].trackingX;
        trackingData.trackingY = respuestaAPI[0].trackingY;
        trackingData.distancia = distancia;

        listaTrack.add(trackingData);

        if (respuestaAPI[0].pedidoEstado != '3') {
          add(OnMostrarRepartidor(true));
        } else {
          add(OnMostrarRepartidor(false));
        }

        add(OnUbicacionCambio(repartidor, listaTrack));
      } else {
        print('cerramos el stream');

        _positionSubscription?.cancel();
      }
    });
  }

  @override
  Future<void> close() {
    print('salta1');
    _positionSubscription?.cancel();
    return super.close();
  }

  void cancelarSeguimiento() {
    _positionSubscription?.cancel();
  }

  @override
  Stream<MiUbicacionState> mapEventToState(MiUbicacionEvent event) async* {
    if (event is OnUbicacionCambio) {
      yield state.copyWith(existeUbicacion: true, ubicacion: event.ubicacion, pedido: event.pedido);
    } else if (event is OnMostrarRepartidor) {
      yield state.copyWith(llegadaRepartidor: event.mostrar);
    }
  }
}
