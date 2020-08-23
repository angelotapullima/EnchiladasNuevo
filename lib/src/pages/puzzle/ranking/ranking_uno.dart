import 'package:cached_network_image/cached_network_image.dart';
import 'package:enchiladasapp/src/models/puzzle_model.dart';
import 'package:enchiladasapp/src/utils/responsive.dart';
import 'package:enchiladasapp/src/widgets/zona_direction.dart';
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
                  Text(list[0].personName,style: TextStyle(color:Colors.white),),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(100.0),
                    child: CachedNetworkImage(
                height: responsive.ip(15),
                width: responsive.ip(15),
                cacheManager: CustomCacheManager(),
                placeholder: (context, url) => Image(
                    image: AssetImage('assets/jar-loading.gif'),
                    fit: BoxFit.cover),
                errorWidget: (context, url, error) => Icon(Icons.error),
                imageUrl: '$imagen1',
                imageBuilder: (context, imageProvider) => Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              )
              
               
                  ),
                  Text(list[0].puzzleTiempo,style: TextStyle(color:Colors.white),),
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
