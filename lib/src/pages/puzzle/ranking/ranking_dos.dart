import 'package:cached_network_image/cached_network_image.dart';
import 'package:enchiladasapp/src/models/puzzle_model.dart';
import 'package:enchiladasapp/src/utils/responsive.dart';
import 'package:flutter/material.dart';

class RankingDos extends StatelessWidget {
  final List<RankingPuzzle> list;
  const RankingDos({Key key, this.list}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String imagen1 = list[0].userImage;
    String imagen2 = list[1].userImage;
    final responsive = Responsive.of(context);

    return Scaffold(
      body: Stack(
        children: <Widget>[
          _background(context),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  height: responsive.ip(23),
                  child: Column(
                    children: <Widget>[
                      Text(
                        list[0].personName,
                        style: TextStyle(color: Colors.white, fontSize: responsive.ip(2)),
                      ),
                      SizedBox(
                        height: responsive.hp(1),
                      ),
                      Container(
                        height: responsive.ip(15),
                        width: responsive.ip(15),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100.0),
                          child: CachedNetworkImage(
                            progressIndicatorBuilder: (_, url, downloadProgress) {
                              return Container(
                                width: double.infinity,
                                height: double.infinity,
                                child: Stack(
                                  children: [
                                    Center(
                                      child: CircularProgressIndicator(
                                        value: downloadProgress.progress,
                                        backgroundColor: Colors.green,
                                        valueColor: new AlwaysStoppedAnimation<Color>(Colors.red),
                                      ),
                                    ),
                                    Center(
                                      child: (downloadProgress.progress != null)
                                          ? Text('${(downloadProgress.progress * 100).toInt().toString()}%')
                                          : Container(),
                                    )
                                  ],
                                ),
                              );
                            },
                            errorWidget: (context, url, error) => Image(image: AssetImage('assets/carga_fallida.jpg'), fit: BoxFit.cover),
                            imageUrl: '$imagen1',
                            //imageUrl: 'https://bolavip.com/__export/1595979644143/sites/bolavip/img/2020/07/28/chavo_crop1595979643620.jpg_1902800913.jpg',
                            imageBuilder: (context, imageProvider) => Container(
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.cover,
                              )),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: responsive.hp(1),
                      ),
                      Text(
                        list[0].puzzleTiempo,
                        style: TextStyle(color: Colors.white, fontSize: responsive.ip(2)),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: responsive.ip(23),
                  child: Column(
                    children: <Widget>[
                      Text(
                        list[1].personName,
                        style: TextStyle(color: Colors.white, fontSize: responsive.ip(2)),
                      ),
                      SizedBox(
                        height: responsive.hp(1),
                      ),
                      Container(
                        height: responsive.ip(15),
                        width: responsive.ip(15),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100.0),
                          child: CachedNetworkImage(
                            progressIndicatorBuilder: (_, url, downloadProgress) {
                              return Container(
                                width: double.infinity,
                                height: double.infinity,
                                child: Stack(
                                  children: [
                                    Center(
                                      child: CircularProgressIndicator(
                                        value: downloadProgress.progress,
                                        backgroundColor: Colors.green,
                                        valueColor: new AlwaysStoppedAnimation<Color>(Colors.red),
                                      ),
                                    ),
                                    Center(
                                      child: (downloadProgress.progress != null)
                                          ? Text('${(downloadProgress.progress * 100).toInt().toString()}%')
                                          : Container(),
                                    )
                                  ],
                                ),
                              );
                            },
                            errorWidget: (context, url, error) => Image(image: AssetImage('assets/carga_fallida.jpg'), fit: BoxFit.cover),
                            //imageUrl: 'https://bolavip.com/__export/1595979644143/sites/bolavip/img/2020/07/28/chavo_crop1595979643620.jpg_1902800913.jpg',
                            imageUrl: '$imagen2',
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
                        height: responsive.hp(1),
                      ),
                      Text(
                        list[1].puzzleTiempo,
                        style: TextStyle(color: Colors.white, fontSize: responsive.ip(2)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          AppBar(
            backgroundColor: Colors.transparent,
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
