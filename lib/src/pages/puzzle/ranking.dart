import 'package:cached_network_image/cached_network_image.dart';
import 'package:enchiladasapp/src/bloc/provider.dart';
import 'package:enchiladasapp/src/models/puzzle_model.dart';
import 'package:enchiladasapp/src/pages/puzzle/ranking/ranking_dos.dart';
import 'package:enchiladasapp/src/pages/puzzle/ranking/ranking_tres.dart';
import 'package:enchiladasapp/src/pages/puzzle/ranking/ranking_uno.dart';
import 'package:enchiladasapp/src/utils/responsive.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:horizontal_calendar_widget/date_helper.dart'; 

class RankingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final String time = ModalRoute.of(context).settings.arguments;
    DateTime today = toDateMonthYear(DateTime.now());
    final puzzleBloc = ProviderBloc.puzzle(context);
    var horafotmat  = today.toString().split(' ');
    var horaformat1 = horafotmat[0];
    puzzleBloc.obtenerTiempos(horaformat1);
    final responsive = Responsive.of(context);

    return Scaffold(
      body: StreamBuilder(
          stream: puzzleBloc.puzzleTiempoStream,
          builder: (BuildContext context,
              AsyncSnapshot<List<RankingPuzzle>> snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data.length > 0) {

                if(snapshot.data.length==1){
                  return RankingUno(list: snapshot.data);
                }else if(snapshot.data.length==2){
                  return RankingDos(list: snapshot.data);
                }else if(snapshot.data.length==3){
                  return RankingTres(list: snapshot.data);
                }else {
                  return contenidoRankingMayora3(context,time,responsive,snapshot.data);
                }
                
                /* return contenidoRankingMayora3(
                    context, time, responsive, snapshot.data); */
              } else {
                return Center(child: Text('no hay datos'));
              }
            } else {
              return Center(child: CupertinoActivityIndicator());
            }
          }),
    );
  }

  Widget contenidoRankingMayora3(BuildContext context, String time,
      Responsive responsive, List<RankingPuzzle> data) {
    return CustomScrollView(slivers: <Widget>[
      _crearAppbar(context, time),
      SliverList(
        delegate: SliverChildBuilderDelegate((BuildContext context, int i) {
          return _cardRanking(responsive, data[i]);
        }, childCount: data.length),
      )
    ]);
  }

  Widget _crearFondo(BuildContext context) {
    final size = MediaQuery.of(context).size;



    final circulo = Container(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(100.0),
        child: FadeInImage(
            height: size.width * 0.28,
            width: size.width * 0.28,
            fit: BoxFit.cover,
            placeholder: AssetImage('assets/ladrillos.png'),
            image: NetworkImage(
                'https://ep01.epimg.net/elpais/imagenes/2019/06/24/icon/1561369019_449523_1561456608_noticia_normal.jpg')),
      ),
    );
    return Stack(
        children: <Widget>[
          Container(
            width: double.infinity,
            height: double.infinity,
            child: CachedNetworkImage(
              placeholder: (context, url) => Image(
                  image: AssetImage('assets/ladrillos.png'),
                  fit: BoxFit.cover),
              errorWidget: (context, url, error) => Image.asset(
                'assets/ladrillos.png',
                fit: BoxFit.cover,
              ),
              imageUrl: 'negocio.getFoto()',
              imageBuilder: (context, imageProvider) => Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.cover,
                    )),
              ),
            ),
          ),
          
          Container(
            color: Colors.transparent,
            padding: EdgeInsets.symmetric(horizontal: size.width * 0.08),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Container(
                      width: size.width * 0.28,
                      padding: EdgeInsets.only(top: size.height * 0.15),
                      child: Column(
                        children: <Widget>[
                          circulo,
                          Text(
                            'Angelo Tapullima Del Aguila',

                            textAlign: TextAlign.center,
                            //overflow:TextOverflow.ellipsis,
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    ),
                    Container(
                      width: size.width * 0.28,
                      padding: EdgeInsets.only(top: size.height * 0.05),
                      child: Column(
                        children: <Widget>[
                          circulo,
                          Text(
                            'Angelo Tapullima Del Aguila',
                            textAlign: TextAlign.center,
                            //overflow:TextOverflow.ellipsis,
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    ),
                    Container(
                      width: size.width * 0.28,
                      padding: EdgeInsets.only(top: size.height * 0.15),
                      child: Column(
                        children: <Widget>[
                          circulo,
                          Text(
                            'Angelo Tapullima Del Aguila',
                            textAlign: TextAlign.center,
                            //overflow:TextOverflow.ellipsis,
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      );
  }

  Widget _crearAppbar(BuildContext context, String time) {
    final size = MediaQuery.of(context).size;
    return SliverAppBar(
      shape: ContinuousRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(40),
              bottomRight: Radius.circular(40))),
      elevation: 2.0,
      expandedHeight: size.height * 0.4,
      floating: true,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        /*centerTitle: true,
        title: Text(
          time,
          style: TextStyle(color: Colors.white, fontSize: 16.0),
        ),*/
        background: _crearFondo(context),
      ),
    );
  }

  Widget _cardRanking(Responsive responsive, RankingPuzzle ranking) {
    return Card(
      elevation: 3.0,
      margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: Container(
        padding: EdgeInsets.all(10.0),
        child: Row(children: <Widget>[
          Text(
            '4',
            style: TextStyle(fontSize: 18.0),
          ),
          SizedBox(
            width: 5.0,
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(100.0),
            child: FadeInImage(
                height: responsive.wp(10),
                width: responsive.wp(10),
                fit: BoxFit.cover,
                placeholder: AssetImage('assets/jar-loading.gif'),
                image: NetworkImage(
                    'https://delivery.lacasadelasenchiladas.pe/${ranking.userImage}')),
          ),
          SizedBox(
            width: 10.0,
          ),
          Expanded(
            child: Text('${ranking.personName}'),
          ),
          Text('${ranking.puzzleTiempo}'),
        ]),
      ),
    );
  }
}
