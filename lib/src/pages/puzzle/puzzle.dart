
import 'package:enchiladasapp/src/models/puzzle_model.dart';
import 'package:enchiladasapp/src/pages/puzzle/ranking/pantalla_puzzle_terminado.dart';
import 'package:enchiladasapp/src/widgets/customCacheManager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';

import 'PuzzlePiece.dart';

class PuzzlePage extends StatefulWidget {
  final String title = "Puzzle Enchiladas";
  final int rows = 2;
  final int cols = 2;

  @override
  _PuzzlePageState createState() => _PuzzlePageState();
}

class _PuzzlePageState extends State<PuzzlePage> {
  String pathLlegada;
  String idImagenLlegada;
  String _stopwatchText = '00:00:00';
  final _stopWatch = new Stopwatch();
  final _timeout = const Duration(seconds: 1);
  File _image;
  List<Widget> pieces = [];
  bool retroceso;

  @override
  void dispose() {
    if (_stopWatch.isRunning) {
      _stopWatch.stop();
    }
    super.dispose();
  }

  void initState() {
    retroceso = false;
    /* _stopWatch.start();
        _startTimeout();  */
    _startStopButtonPressed();
    super.initState();
  }

  Future getImage(String path) async {
    var image = await CustomCacheManager().getSingleFile(path);

    print('image: $image');
    if (image != null) {
      setState(() {
        _image = image;
        pieces.clear();
      });

      splitImage(Image.file(image));
    }
  }

  // Necesitamos averiguar el tamaño de la imagen, para ser utilizado en el widget PuzzlePiece
  Future<Size> getImageSize(Image image) async {
    final Completer<Size> completer = Completer<Size>();

    image.image
        .resolve(const ImageConfiguration())
        .addListener(new ImageStreamListener(
      (ImageInfo info, bool synchronousCall) {
        completer.complete(Size(
          info.image.width.toDouble(),
          info.image.height.toDouble(),
        ));
      },
    ));

    final Size imageSize = await completer.future;

    return imageSize;
  }

  // aquí dividiremos la imagen en pedazos pequeños usando las filas y columnas definidas anteriormente; cada pieza se agregará a una pila
  void splitImage(Image image) async {
    Size imageSize = await getImageSize(image);

    for (int x = 0; x < widget.rows; x++) {
      for (int y = 0; y < widget.cols; y++) {
        setState(() {
          pieces.add(PuzzlePiece(
              key: GlobalKey(),
              image: image,
              imageSize: imageSize,
              row: x,
              col: y,
              maxRow: widget.rows,
              maxCol: widget.cols,
              bringToTop: this.bringToTop,
              sendToBack: this.sendToBack));
        });
      }
    }
  }

  // cuando comienza el movimientos de una pieza, debemos llevarla al frente de la pila
  void bringToTop(Widget widget) {
    setState(() {
      pieces.remove(widget);
      pieces.add(widget);
    });
  }

  int completado = 0;
  String completex = '';
  //
  //cuando una pieza alcanza su posición final, se enviará a la parte posterior de la pila para no interponerse en el camino de otras piezas aún móviles
  void sendToBack(Widget widget, BuildContext context) {
    //setState(() {
    pieces.remove(widget);
    pieces.insert(0, widget);
    completado++;
    if (pieces.length == completado) {
      print('finalizado $_stopwatchText');

      //_mostrarAlert(context);

      completex = 'lleno';

      //showProcessingDialog();

      retroceso = true;
      Future.delayed(Duration(milliseconds: 400), () {
      haceralgonoseque();
    });

      //Toast.show("debe ingresar numeros", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
    }

    
    //});
  }

  haceralgonoseque() async {
    _startStopButtonPressed();

    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        pageBuilder: (context, animation, secondaryAnimation) {
          return PuzzleTerminado(tiempo: _stopwatchText,idImagen:idImagenLlegada);
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          var begin = Offset(0.0, 1.0);
          var end = Offset.zero;
          var curve = Curves.ease;

          var tween = Tween(begin: begin, end: end).chain(
            CurveTween(curve: curve),
          );

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      ),
    );

    /* final puzzleApi = PuzzleApi();

    _startStopButtonPressed();
    final res = await puzzleApi.subirTiempo(_stopwatchText, idImagenLlegada);

    if (res) {
      String hora = _stopwatchText;

      _image = null;
      _resetButtonPressed();

      Navigator.pop(context);
      Navigator.of(context).pushNamedAndRemoveUntil(
          'ranking', ModalRoute.withName('HomePuzzle'),
          arguments: hora);
    } else {
      Navigator.pop(context);
      errorSubida();
    } */
  }

  @override
  Widget build(BuildContext context) {
    final RankingPuzzle rankingPuzzle =
        ModalRoute.of(context).settings.arguments;
    pathLlegada = rankingPuzzle.path;
    idImagenLlegada = rankingPuzzle.idImagen;

    if (retroceso) {
      haceralgonoseque();
      retroceso = false;
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: <Widget>[
          SafeArea(
            child: Container(
              padding: EdgeInsets.only(top: 40),
              child: Center(
                child: _generarImagen(rankingPuzzle.path),
              ),
            ),
          ),
          Container(
            height: 80,
            child: AppBar(
              title: Text(widget.title),
              backgroundColor: Colors.transparent,
              actions: <Widget>[
                Center(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    child: Text(
                      _stopwatchText,
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              ],
            ),
          ),
          //_cargandoContenidoPuzzle(context),
        ],
      ),

      //floatingActionButton: _floatingButton(),
    );
  }

  Widget _generarImagen(String path) {
    if (_image == null) {
      if (completex == 'lleno') {
        return Container();
      } else {
        getImage(path);
        return Container();
      }
    } else {
      return Stack(children: pieces);
    }
  }

  
void _startTimeout() {
    new Timer(_timeout, _handleTimeout);
  }

  void _handleTimeout() {
    if (_stopWatch.isRunning) {
      _startTimeout();
    }
    setState(() {
      _setStopwatchText();
    });
  }

  void _startStopButtonPressed() {
    setState(() {
      if (_stopWatch.isRunning) {
        _stopWatch.stop();
      } else {
        _stopWatch.start();
        _startTimeout();
      }
    });
  }

  void _resetButtonPressed() {
    if (_stopWatch.isRunning) {
      _startStopButtonPressed();
    }
    setState(() {
      _stopWatch.reset();
      _setStopwatchText();
    });
  }

  void _setStopwatchText() {
    _stopwatchText = _stopWatch.elapsed.inHours.toString().padLeft(2, '0') +
        ':' +
        (_stopWatch.elapsed.inMinutes % 60).toString().padLeft(2, '0') +
        ':' +
        (_stopWatch.elapsed.inSeconds % 60).toString().padLeft(2, '0');
  }
}
