part of 'mi_ubicacion_bloc.dart';

@immutable
class MiUbicacionState {

  final bool siguiendo;
  final bool existeUbicacion;
  final bool llegadaRepartidor;
  final LatLng ubicacion;
  final List<TrackingData> pedido;

  MiUbicacionState({
    this.siguiendo = true,
    this.existeUbicacion = false,
    this.llegadaRepartidor = false,
    this.ubicacion,
    this.pedido
  }); 

  MiUbicacionState copyWith({
    bool siguiendo,
    bool existeUbicacion,
    bool llegadaRepartidor,
    LatLng ubicacion,
    List<TrackingData> pedido,
  }) => new MiUbicacionState(
    siguiendo       : siguiendo ?? this.siguiendo,
    existeUbicacion : existeUbicacion ?? this.existeUbicacion,
    llegadaRepartidor : llegadaRepartidor ?? this.llegadaRepartidor,
    ubicacion       : ubicacion ?? this.ubicacion,
    pedido       : pedido ?? this.pedido,
  );
  

}
