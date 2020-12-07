part of 'mi_ubicacion_bloc.dart';

@immutable
abstract class MiUbicacionEvent {}

class OnUbicacionCambio extends MiUbicacionEvent {

  final LatLng ubicacion;
  final List<TrackingData> pedido;
  OnUbicacionCambio(this.ubicacion, this.pedido); 

}

class OnMostrarRepartidor extends MiUbicacionEvent{
  final bool mostrar;

  OnMostrarRepartidor(this.mostrar);
}