import 'package:enchiladasapp/src/pages/blocMapa/widgets/widgets.dart';
import 'package:enchiladasapp/src/pages/rating_repartidor.dart';
import 'package:enchiladasapp/src/utils/circle.dart';
import 'package:enchiladasapp/src/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'mapa/mapa_bloc.dart';
import 'mi_ubicacion/mi_ubicacion_bloc.dart';

class MapaPage extends StatefulWidget {
  final idPedido;

  const MapaPage({Key key, @required this.idPedido}) : super(key: key);

  @override
  _MapaPageState createState() => _MapaPageState();
}

class _MapaPageState extends State<MapaPage> {
  @override
  void initState() {
    context.bloc<MiUbicacionBloc>().iniciarSeguimiento(widget.idPedido);

    super.initState();
  }

  @override
  void dispose() {
    print('ctm');
    context.bloc<MiUbicacionBloc>().cancelarSeguimiento();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);

    return Scaffold(
      body: Stack(
        children: [
          BlocBuilder<MiUbicacionBloc, MiUbicacionState>(builder: (_, state) {
            return Stack(
              children: [
                crearMapa(state, responsive),
                (state.llegadaRepartidor)
                    ? Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: responsive.wp(5)),
                        margin: EdgeInsets.symmetric(
                            horizontal: responsive.wp(15),
                            vertical: responsive.hp(40)),
                        height: double.infinity,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'El repartidor ya llegó a su destino. ¡Gracias por su compra!',
                              style: TextStyle(fontSize: responsive.ip(2)),
                              textAlign: TextAlign.center,
                            ),
                            Row(
                              children: [
                                Spacer(),
                                FlatButton(
                                  onPressed: () async {
                                    Navigator.push(
                                        context,
                                        PageRouteBuilder(
                                          transitionDuration:
                                              const Duration(milliseconds: 400),
                                          pageBuilder: (context, animation,
                                              secondaryAnimation) {
                                            return RatingRepartidor(
                                              idPedido: widget.idPedido,
                                            );
                                            //return DetalleProductitos(productosData: productosData);
                                          },
                                          transitionsBuilder: (context,
                                              animation,
                                              secondaryAnimation,
                                              child) {
                                            return FadeTransition(
                                              opacity: animation,
                                              child: child,
                                            );
                                          },
                                        ));
                                  },
                                  textColor: Colors.red,
                                  child: Text(
                                    'Valorar',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      )
                    : Container()
              ],
            );
          }),
          Positioned(
            top: responsive.hp(3),
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
          Positioned(
            bottom: responsive.hp(35),
            right: 10,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                BtnUbicacion(),

                BtnSeguirUbicacion(),

                //BtnMiRuta(),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget crearMapa(MiUbicacionState state, Responsive responsive) {
    if (!state.existeUbicacion)
      return Center(child: Text('Ubicando repartidor...'));

    final mapaBloc = BlocProvider.of<MapaBloc>(context);

    mapaBloc.add(OnNuevaUbicacion(state.ubicacion, state.pedido, context));

    print(' tamare ${state.pedido[0].distancia}');

    final cameraPosition =
        new CameraPosition(target: state.ubicacion, zoom: 18);

    if ('${state.pedido[0].pedidoEstado}' != '3') {
      print('true');
    }

    return BlocBuilder<MapaBloc, MapaState>(
      builder: (context, _) {
        return Stack(
          children: [
            Container(
              height: responsive.hp(65),
              child: GoogleMap(
                initialCameraPosition: cameraPosition,
                myLocationEnabled: true,
                myLocationButtonEnabled: false,
                zoomControlsEnabled: false,
                onMapCreated: mapaBloc.initMapa,
                //polylines: mapaBloc.state.polylines.values.toSet(),
                markers: mapaBloc.state.markers.values.toSet(),
                onCameraMove: (cameraPosition) {
                  // cameraPosition.target = LatLng central del mapa
                  mapaBloc.add(
                    OnMovioMapa(cameraPosition.target),
                  );
                },
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: responsive.hp(35),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                    color: Colors.white),
                child: Column(
                  children: <Widget>[
                    Container(
                      height: responsive.hp(12),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                          color: Colors.red),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: responsive.wp(2),
                          vertical: responsive.hp(2),
                        ),
                        child: Row(
                          children: <Widget>[
                            CircleAvatar(
                              radius: 25,
                              child: ClipOval(
                                child: Image.network(
                                  ('${state.pedido[0].userImage}' != null)
                                      ? '${state.pedido[0].userImage}'
                                      : Container(),
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    ('${state.pedido[0].personName}' != null)
                                        ? '${state.pedido[0].personName}'
                                        : Container(),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: responsive.ip(2),
                                    ),
                                  ),
                                  Text(
                                    ('${state.pedido[0].idRepartidor}' != null)
                                        ? 'Repartidor ${state.pedido[0].idRepartidor}'
                                        : Container(),
                                    style: TextStyle(color: Colors.white),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
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
                                    vertical: responsive.hp(.5),
                                  ),
                                  width: responsive.wp(1),
                                  height: responsive.hp(2),
                                  color: Colors.orange,
                                ),
                                Container(
                                  margin: EdgeInsets.symmetric(
                                    vertical: responsive.hp(.5),
                                  ),
                                  width: responsive.wp(1),
                                  height: responsive.hp(2),
                                  color: Colors.orange,
                                ),
                                Container(
                                  margin: EdgeInsets.symmetric(
                                    vertical: responsive.hp(.5),
                                  ),
                                  width: responsive.wp(1),
                                  height: responsive.hp(2),
                                  color: Colors.orange,
                                ),
                                Container(
                                  margin: EdgeInsets.symmetric(
                                    vertical: responsive.hp(.5),
                                  ),
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
                                  style: TextStyle(
                                    fontSize: responsive.ip(2),
                                  ),
                                ),
                                Text(
                                  '${state.pedido[0].distancia} Km',
                                  style: TextStyle(
                                      fontSize: responsive.ip(2.1),
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: responsive.hp(8),
                                ),
                                Text(
                                  'Dirección de entrega',
                                  style: TextStyle(
                                    fontSize: responsive.ip(2),
                                  ),
                                ),
                                Text(
                                  ('${state.pedido[0].pedidoDireccion}' != null)
                                      ? '${state.pedido[0].pedidoDireccion}'
                                      : Container(),
                                  style: TextStyle(
                                      fontSize: responsive.ip(2.1),
                                      fontWeight: FontWeight.bold),
                                ),
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
          ],
        );
      },
    );
  }
}
