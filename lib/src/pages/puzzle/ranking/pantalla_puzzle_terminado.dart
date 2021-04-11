import 'package:cached_network_image/cached_network_image.dart';
import 'package:enchiladasapp/src/api/puzzle_api.dart';
import 'package:enchiladasapp/src/utils/preferencias_usuario.dart';
import 'package:enchiladasapp/src/utils/responsive.dart';
import 'package:enchiladasapp/src/utils/utilidades.dart';
import 'package:enchiladasapp/src/widgets/customCacheManager.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class PuzzleTerminado extends StatefulWidget {
  const PuzzleTerminado({Key key, this.tiempo = '00:00:4', this.idImagen = '2'})
      : super(key: key);

  final String tiempo;
  final String idImagen;

  @override
  _PuzzleTerminadoState createState() => _PuzzleTerminadoState();
}

class _PuzzleTerminadoState extends State<PuzzleTerminado> {
  final _cargando = ValueNotifier<bool>(false);
  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);
    final preferences = Preferences();

    return Scaffold(
      body: Stack(
        children: [
          _background(context),
          AppBar(
            backgroundColor: Colors.transparent,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: responsive.wp(3)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      preferences.personName,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: responsive.ip(2.5),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: responsive.hp(2),
                ),
                //Text('list[0].personName',style: TextStyle(color:Colors.white,fontSize: responsive.ip(2)),),
                Container(
                  height: responsive.ip(18),
                  width: responsive.ip(18),
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
                        imageUrl: '${preferences.foto}',
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
                SizedBox(
                  height: responsive.hp(2),
                ),
                Text(
                  '${widget.tiempo}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: responsive.ip(2.5),
                  ),
                ),
                SizedBox(
                  height: responsive.hp(4),
                ),

                RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  color: Colors.red,
                  textColor: Colors.white,
                  onPressed: () async {
                    _cargando.value = true;
                    final puzzleApi = PuzzleApi();
                    //showProcessingDialog();

                    final res = await puzzleApi.subirTiempo(
                        '${widget.tiempo}', widget.idImagen);

                    if (res) {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          'ranking', ModalRoute.withName('HomePuzzle'),
                          arguments: '${widget.tiempo}');
                    } else {
                      showToast(
                          'Error al subir lo datos', 3, ToastGravity.CENTER);
                    }
                    _cargando.value = false;
                  },
                  child: Text(
                    "Registrar Tiempo!".toUpperCase(),
                    style: TextStyle(
                      fontSize: responsive.ip(1.8),
                    ),
                  ),
                ),
                //Text('list[0].puzzleTiempo',style: TextStyle(color:Colors.white,fontSize: responsive.ip(2)),),
              ],
            ),
          ),
          ValueListenableBuilder(
              valueListenable: _cargando,
              builder: (BuildContext context, bool data, Widget child) {
                return (data)
                    ? Positioned(
                        top: responsive.hp(35),
                        left: responsive.wp(10),
                        child: Container(
                          color: Colors.white,
                          width: responsive.wp(80),
                          height: responsive.hp(20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                "Validando...",
                                style: TextStyle(
                                  color: Color(0xFF5B6978),
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                    : Container();
              })
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
