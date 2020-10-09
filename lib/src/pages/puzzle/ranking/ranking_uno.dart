import 'package:cached_network_image/cached_network_image.dart';
import 'package:enchiladasapp/src/models/puzzle_model.dart';
import 'package:enchiladasapp/src/utils/responsive.dart';
import 'package:enchiladasapp/src/widgets/customCacheManager.dart';
import 'package:flutter/material.dart';

class RankingUno extends StatelessWidget {
  final List<RankingPuzzle> list;
  const RankingUno({Key key, this.list}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String imagen1 = list[0].userImage;
    final responsive = Responsive.of(context);
    return Scaffold(
      body: Stack(
        children: <Widget>[
          _background(context),
          AppBar(
            backgroundColor: Colors.transparent,
          ),
          Center(
            child: Container(
              height: responsive.ip(28),
              child: Column(
                children: <Widget>[
                  Text(
                    list[0].personName,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: responsive.ip(2.5),
                    ),
                  ),
                  SizedBox(height: responsive.hp(2),),
                  //Text('list[0].personName',style: TextStyle(color:Colors.white,fontSize: responsive.ip(2)),),
                  Container(
                    height: responsive.ip(18),
                    width: responsive.ip(18),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(100.0),
                        child: CachedNetworkImage(
                          cacheManager: CustomCacheManager(),
                          placeholder: (context, url) => Image(
                              image: AssetImage('assets/jar-loading.gif'),
                              fit: BoxFit.cover),errorWidget: (context, url, error) => Image(
                  image: AssetImage('assets/carga_fallida.jpg'),
                  fit: BoxFit.cover),
                          imageUrl: '$imagen1',
                          //imageUrl: 'https://bolavip.com/__export/1595979644143/sites/bolavip/img/2020/07/28/chavo_crop1595979643620.jpg_1902800913.jpg',
                          imageBuilder: (context, imageProvider) => Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        )),
                  ),
                  SizedBox(height: responsive.hp(2),),
                  Text(
                    list[0].puzzleTiempo,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: responsive.ip(2.5),
                    ),
                  ),
                  //Text('list[0].puzzleTiempo',style: TextStyle(color:Colors.white,fontSize: responsive.ip(2)),),
                ],
              ),
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
