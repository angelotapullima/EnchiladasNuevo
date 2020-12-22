part of 'mapa_bloc.dart';

@immutable
abstract class MapaEvent {}

class OnMapaListo extends MapaEvent{}

class OnMarcarRecorrido extends MapaEvent{}

class OnSeguirUbicacion extends MapaEvent{}



class OnMovioMapa extends MapaEvent{
  final LatLng centroMapa;
  OnMovioMapa(this.centroMapa);
  
}

class OnNuevaUbicacion extends MapaEvent{
  final BuildContext context;
  final LatLng ubicacion;
  final List<TrackingData> pedido;
  OnNuevaUbicacion(this.ubicacion, this.pedido, this.context);

} 


