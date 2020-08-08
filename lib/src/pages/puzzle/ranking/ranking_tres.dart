import 'package:enchiladasapp/src/models/puzzle_model.dart';
import 'package:enchiladasapp/src/utils/responsive.dart';
import 'package:flutter/material.dart';

class RankingTres extends StatelessWidget {
  final List<RankingPuzzle> list;
  const RankingTres({Key key, this.list}) : super(key: key);
  @override
  Widget build(BuildContext context) {


    String imagen1 = list[0].userImage;
    String imagen2 = list[1].userImage;
    String imagen3 = list[2].userImage;
    final responsive = Responsive.of(context);

    return Scaffold(
      body: Stack(
        children: <Widget>[
          _background(context),
          AppBar(
            backgroundColor: Colors.transparent,
          ),
          Positioned(
            top: responsive.hp(28),
            right: responsive.wp(30),
            child: CirculoItenRanking(
              nombre: list[0].personName,
              tiempo: list[0].puzzleTiempo,
              foto: 'https://delivery.lacasadelasenchiladas.pe/$imagen1',
            ),
          ),
          Positioned(
            top: responsive.hp(50),
            left: responsive.wp(4),
            child: CirculoItenRanking(
              nombre: list[1].personName,
              tiempo: list[1].puzzleTiempo,
              foto: 'https://delivery.lacasadelasenchiladas.pe/$imagen2',
            ),
          ),
          Positioned(
            top: responsive.hp(50),
            right: responsive.wp(4),
            child: CirculoItenRanking(
               nombre: list[2].personName,
              tiempo: list[2].puzzleTiempo,
              foto: 'https://delivery.lacasadelasenchiladas.pe/$imagen3',
            ),
          ),
        ],
      ),
    );
  }

  Widget _background(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: new BoxDecoration(
        color: Colors.black12,
        image: new DecorationImage(
          image: new ExactAssetImage('assets/ladrillos.png'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class CirculoItenRanking extends StatelessWidget {
  final String foto;
  final String nombre;
  final String tiempo;
  CirculoItenRanking({Key key, this.foto, this.nombre, this.tiempo})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);
    return Container(
        height: responsive.ip(24),
        width: responsive.ip(16),
        child: Column(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(100.0),
              child: FadeInImage(
                  height: responsive.ip(15),
                  width: responsive.ip(15),
                  fit: BoxFit.cover,
                  placeholder: AssetImage('assets/ladrillos.png'),
                  image: NetworkImage(foto)),
            ),
            Text(
              nombre,
              style: TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
            ),
            Text(tiempo, style: TextStyle(color: Colors.white))
          ],
        ));
  }
}
