import 'package:cached_network_image/cached_network_image.dart';
import 'package:enchiladasapp/src/bloc/provider.dart';
import 'package:enchiladasapp/src/models/puzzle_model.dart';
import 'package:enchiladasapp/src/pages/puzzle/ranking/ranking_dos.dart';
import 'package:enchiladasapp/src/pages/puzzle/ranking/ranking_tres.dart';
import 'package:enchiladasapp/src/pages/puzzle/ranking/ranking_uno.dart';
import 'package:enchiladasapp/src/utils/responsive.dart';
import 'package:enchiladasapp/src/widgets/customCacheManager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:horizontal_calendar_widget/date_helper.dart';

class RankingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final String time = ModalRoute.of(context).settings.arguments;
    DateTime today = toDateMonthYear(DateTime.now());
    final puzzleBloc = ProviderBloc.puzzle(context);
    var horafotmat = today.toString().split(' ');
    var horaformat1 = horafotmat[0];
    puzzleBloc.obtenerTiempos(horaformat1);

    return Scaffold(
      body: StreamBuilder(
          stream: puzzleBloc.puzzleTiempoStream,
          builder: (BuildContext context,
              AsyncSnapshot<List<RankingPuzzle>> snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data.length > 0) {
                if (snapshot.data.length == 1) {
                  return RankingUno(list: snapshot.data);
                  //return Container();
                } else if (snapshot.data.length == 2) {
                  return RankingDos(list: snapshot.data);
                  //return Container();
                } else if (snapshot.data.length == 3) {
                  return RankingTres(list: snapshot.data);
                  //return Container();
                } else {
                  return Mayor3(time: time, list: snapshot.data);
                  //return Container();
                }
              } else {
                return Center(child: Text('No hay datos'));
              }
            } else {
              return Center(child: CupertinoActivityIndicator());
            }
          }),
    );
  }
}

class Mayor3 extends StatelessWidget {
  final String time;
  final List<RankingPuzzle> list;
  const Mayor3({Key key, this.time, this.list}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);
    return Scaffold(
        body: contenidoRankingMayora3(context, 'time', responsive, list));
  }

  Widget contenidoRankingMayora3(BuildContext context, String time,
      Responsive responsive, List<RankingPuzzle> data) {
    final list3primeros = List<RankingPuzzle>();
    final listrestantes = List<RankingPuzzle>();

    for (int i = 0; i < data.length; i++) {
      if (i > 2) {
        RankingPuzzle rankingPuzzle = RankingPuzzle();
        rankingPuzzle.idPuzzle = data[i].idPuzzle;
        rankingPuzzle.personName = data[i].personName;
        rankingPuzzle.puzzleFecha = data[i].puzzleFecha;
        rankingPuzzle.userImage = data[i].userImage;
        rankingPuzzle.puzzleTiempo = data[i].puzzleTiempo;
        listrestantes.add(rankingPuzzle);
      } else {
        RankingPuzzle rankingPuzzle = RankingPuzzle();
        rankingPuzzle.idPuzzle = data[i].idPuzzle;
        rankingPuzzle.personName = data[i].personName;
        rankingPuzzle.puzzleFecha = data[i].puzzleFecha;
        rankingPuzzle.userImage = data[i].userImage;
        rankingPuzzle.puzzleTiempo = data[i].puzzleTiempo;
        list3primeros.add(rankingPuzzle);
      }
    }
    return CustomScrollView(slivers: <Widget>[
      _crearAppbar(context, time, list3primeros),
      SliverList(
        delegate: SliverChildBuilderDelegate((BuildContext context, int i) {
          return _cardRanking(responsive, listrestantes[i], i + 4);
        }, childCount: listrestantes.length),
      )
    ]);
  }

  Widget _circulo(Size size, String foto) {
    return Container(
      height: size.width * 0.28,
      width: size.width * 0.28,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(100.0),
        child: CachedNetworkImage(
          cacheManager: CustomCacheManager(),
         progressIndicatorBuilder: (_, url, downloadProgress) {
                          return Stack(
                            children: [
                              Center(
                                child: CircularProgressIndicator(
                                  value: downloadProgress.progress,
                                  backgroundColor: Colors.green,
                                  valueColor: new AlwaysStoppedAnimation<Color>(
                                      Colors.red),
                                ),
                              ),
                              Center(
                                child: (downloadProgress.progress != null)
                                    ? Text(
                                        '${(downloadProgress.progress * 100).toInt().toString()}%')
                                    : Container(),
                              )
                            ],
                          );
                        },
              errorWidget: (context, url, error) => Image(
                  image: AssetImage('assets/carga_fallida.jpg'),
                  fit: BoxFit.cover),
          imageUrl: '$foto',
          imageBuilder: (context, imageProvider) => Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: imageProvider,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _crearFondo(BuildContext context, List<RankingPuzzle> list) {
    final size = MediaQuery.of(context).size;

    return Stack(
      children: <Widget>[
        Container(
          width: double.infinity,
          height: double.infinity,
          child: CachedNetworkImage(
            cacheManager: CustomCacheManager(),
           progressIndicatorBuilder: (_, url, downloadProgress) {
                          return Stack(
                            children: [
                              Center(
                                child: CircularProgressIndicator(
                                  value: downloadProgress.progress,
                                  backgroundColor: Colors.green,
                                  valueColor: new AlwaysStoppedAnimation<Color>(
                                      Colors.red),
                                ),
                              ),
                              Center(
                                child: (downloadProgress.progress != null)
                                    ? Text(
                                        '${(downloadProgress.progress * 100).toInt().toString()}%')
                                    : Container(),
                              )
                            ],
                          );
                        },
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
                        _circulo(size, '${list[0].userImage}'),
                        Text(
                          '${list[0].puzzleTiempo}',

                          textAlign: TextAlign.center,
                          //overflow:TextOverflow.ellipsis,
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '${list[0].personName}',

                          textAlign: TextAlign.center,
                          //overflow:TextOverflow.ellipsis,
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                  Container(
                    width: size.width * 0.28,
                    padding: EdgeInsets.only(top: size.height * 0.05),
                    child: Column(
                      children: <Widget>[
                        _circulo(size, '${list[1].userImage}'),
                        Text(
                          '${list[0].puzzleTiempo}',

                          textAlign: TextAlign.center,
                          //overflow:TextOverflow.ellipsis,
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '${list[1].personName}',
                          textAlign: TextAlign.center,
                          //overflow:TextOverflow.ellipsis,
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                  Container(
                    width: size.width * 0.28,
                    padding: EdgeInsets.only(top: size.height * 0.15),
                    child: Column(
                      children: <Widget>[
                        _circulo(size, '${list[2].userImage}'),
                        Text(
                          '${list[0].puzzleTiempo}',

                          textAlign: TextAlign.center,
                          //overflow:TextOverflow.ellipsis,
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '${list[2].personName}',
                          textAlign: TextAlign.center,
                          //overflow:TextOverflow.ellipsis,
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
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

  Widget _crearAppbar(
      BuildContext context, String time, List<RankingPuzzle> list) {
    final size = MediaQuery.of(context).size;
    return SliverAppBar(
      shape: ContinuousRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
      ),
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
        background: _crearFondo(context, list),
      ),
    );
  }

  Widget _cardRanking(Responsive responsive, RankingPuzzle ranking, int index) {
    return Card(
      elevation: 3.0,
      margin: EdgeInsets.symmetric(
        horizontal: responsive.wp(2),
        vertical: responsive.hp(.8),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Container(
        padding: EdgeInsets.all(
          responsive.ip(1),
        ),
        child: Row(children: <Widget>[
          Text(
            '$index',
            style: TextStyle(
                fontSize: responsive.ip(2), fontWeight: FontWeight.bold),
          ),
          SizedBox(
            width: responsive.wp(2),
          ),
          Container(
            height: responsive.wp(10),
            width: responsive.wp(10),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(100.0),
              child: CachedNetworkImage(
                cacheManager: CustomCacheManager(),
                progressIndicatorBuilder: (_, url, downloadProgress) {
                          return Stack(
                            children: [
                              Center(
                                child: CircularProgressIndicator(
                                  value: downloadProgress.progress,
                                  backgroundColor: Colors.green,
                                  valueColor: new AlwaysStoppedAnimation<Color>(
                                      Colors.red),
                                ),
                              ),
                              Center(
                                child: (downloadProgress.progress != null)
                                    ? Text(
                                        '${(downloadProgress.progress * 100).toInt().toString()}%')
                                    : Container(),
                              )
                            ],
                          );
                        },
                    errorWidget: (context, url, error) => Image(
                  image: AssetImage('assets/carga_fallida.jpg'),
                  fit: BoxFit.cover),
                imageUrl: '${ranking.userImage}',
                imageBuilder: (context, imageProvider) => Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            width: responsive.wp(2),
          ),
          Expanded(
            //child: Text('${ranking.personName}'),
            child: Text(
              'Angelo Tapullima Del Aguila',
              style: TextStyle(
                fontSize: responsive.ip(1.8),
              ),
            ),
          ),
          SizedBox(
            width: responsive.wp(2),
          ),
          Text(
            '${ranking.puzzleTiempo}',
            style: TextStyle(
              fontSize: responsive.ip(1.8),
            ),
          ),
          //Text('00:00:00'),
        ]),
      ),
    );
  }
}
