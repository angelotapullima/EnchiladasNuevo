import 'dart:io';
import 'dart:typed_data';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:enchiladasapp/src/bloc/provider.dart';
import 'package:enchiladasapp/src/models/productos_model.dart';
import 'package:enchiladasapp/src/utils/circle.dart';
import 'package:enchiladasapp/src/utils/responsive.dart';
import 'package:enchiladasapp/src/widgets/customCacheManager.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_view/photo_view.dart';
import 'package:screenshot/screenshot.dart';

class ProductoFotoLocal extends StatefulWidget {
  final String numeroItem;
  final String idCategoria;
  final String cantidadItems;
  ProductoFotoLocal(
      {Key key,
      @required this.numeroItem,
      @required this.idCategoria,
      @required this.cantidadItems})
      : super(key: key);

  @override
  _ProductoFotoLocalState createState() => _ProductoFotoLocalState();
}

class _ProductoFotoLocalState extends State<ProductoFotoLocal> {
  @override
  Widget build(BuildContext context) {
    final _pageController =
        PageController(initialPage: int.parse(widget.numeroItem));

    final productoBloc = ProviderBloc.prod(context);
    final contadorProductosFotoLocal = ProviderBloc.contadorLocal(context);
    productoBloc
        .obtenerProductosLocalEnchiladasPorCategoria(widget.idCategoria);
    contadorProductosFotoLocal.changeContador(int.parse(widget.numeroItem));

    final responsive = Responsive.of(context);
    return Material(
          child: StreamBuilder(
          stream: contadorProductosFotoLocal.selectContadorStream,
          builder: (context, snapshotContador) {
            if (snapshotContador.hasData) {
              if (snapshotContador.data != null) {
                return Scaffold(
                    appBar: AppBar(
                      backgroundColor: Colors.black,
                      actions: [
                        Container(
                          height: responsive.hp(1),
                          padding: EdgeInsets.symmetric(
                            horizontal: responsive.wp(2),
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.grey[300],
                            border: Border.all(color: Colors.grey[300]),
                          ),
                          margin: EdgeInsets.symmetric(
                            horizontal: responsive.wp(5),
                            vertical: responsive.hp(1.3),
                          ),
                          child: Row(
                            children: [
                              Text(
                                (contadorProductosFotoLocal.pageContador + 1)
                                    .toString(),
                                style: TextStyle(
                                    fontSize: responsive.ip(1.5),
                                    color: Colors.black),
                              ),
                              Text(
                                ' / ',
                                style: TextStyle(
                                    fontSize: responsive.ip(1.5),
                                    color: Colors.black),
                              ),
                              Text(
                                '${widget.cantidadItems}',
                                style: TextStyle(
                                    fontSize: responsive.ip(1.5),
                                    color: Colors.black),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    body: StreamBuilder(
                        stream: productoBloc.productosEnchiladasStream,
                        builder: (context,
                            AsyncSnapshot<List<ProductosData>> snapshot) {
                          if (snapshot.hasData) {
                            if (snapshot.data.length > 0) {
                              return PageView.builder(
                                  itemCount: snapshot.data.length,
                                  controller: _pageController,
                                  itemBuilder: (BuildContext context, int index) {
                                    return DetalleProductoFotoLocal(
                                      mostrarback: false,
                                      productosData: snapshot.data[index],
                                    );
                                  },
                                  onPageChanged: (int index) {
                                    contadorProductosFotoLocal
                                        .changeContador(index);
                                  });
                            } else {
                              return Center(
                                child: CupertinoActivityIndicator(),
                              );
                            }
                          } else {
                            return Center(
                              child: CupertinoActivityIndicator(),
                            );
                          }
                        }));
              } else
                return Center(
                  child: CupertinoActivityIndicator(),
                );
            } else {
              return Center(
                child: CupertinoActivityIndicator(),
              );
            }
          }),
    );
  }
}

class DetalleProductoFotoLocal extends StatefulWidget {
  final ProductosData productosData;
  final bool mostrarback;
  const DetalleProductoFotoLocal(
      {Key key, @required this.productosData, @required this.mostrarback})
      : super(key: key);

  @override
  _DetalleProductoFotoState createState() => _DetalleProductoFotoState();
}

class _DetalleProductoFotoState extends State<DetalleProductoFotoLocal> {
  File _imageFile;
  ScreenshotController screenshotController = ScreenshotController();
  final _toque = ValueNotifier<bool>(false);

  final assetsAudioPlayer = AssetsAudioPlayer();
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    print('dispose');
    assetsAudioPlayer.stop();
    assetsAudioPlayer.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('${widget.productosData.sonido}');
    if ('${widget.productosData.sonido}' != 'sinsonido') {
      assetsAudioPlayer.open(
        Audio("assets/audio/${widget.productosData.sonido}.mp3"),
      );
    }

    final responsive = Responsive.of(context);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: (widget.mostrarback)
          ? AppBar(
              backgroundColor: Colors.black,
              actions: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: responsive.wp(5)),
                  child: GestureDetector(
                    child: CircleContainer(
                        radius: responsive.ip(2.5),
                        color: Colors.transparent,
                        widget: Icon(Icons
                            .share) //Icon(Icons.arrow_back, color: Colors.black),
                        ),
                    onTap: () async {
                      await takeScreenshotandShare(
                          widget.productosData.idProducto);
                      //_logoScreen.value = false;
                    },
                  ),
                ),
              ],
            )
          : AppBar(
              backgroundColor: Colors.black,
              leading: Container(),
              actions: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: responsive.wp(5)),
                  child: GestureDetector(
                    child: CircleContainer(
                        radius: responsive.ip(2.5),
                        color: Colors.transparent,
                        widget: Icon(Icons
                            .share) //Icon(Icons.arrow_back, color: Colors.black),
                        ),
                    onTap: () async {
                      await takeScreenshotandShare(
                          widget.productosData.idProducto);
                      //_logoScreen.value = false;
                    },
                  ),
                ),
              ],
            ),
      body: ValueListenableBuilder(
          valueListenable: _toque,
          builder: (BuildContext context, bool data, Widget child) {
            return InkWell(
              onTap: () {
                if (data) {
                  _toque.value = false;
                } else {
                  _toque.value = true;
                }
              },
              child: Stack(
                children: <Widget>[
                  Screenshot(
                    controller: screenshotController,
                    child: Stack(
                      children: <Widget>[
                        Center(
                          child: PhotoView(
                            imageProvider: CachedNetworkImageProvider(
                              '${widget.productosData.productoFoto}',
                              cacheManager: CustomCacheManager(),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          left: 0,
                          child: Container(
                            color: Colors.black.withOpacity(.6),
                            padding: EdgeInsets.symmetric(
                              horizontal: responsive.wp(5),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: Text(
                                        '${widget.productosData.productoNombre}',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: responsive.ip(3),
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    SizedBox(
                                      width: responsive.wp(4),
                                    ),
                                    Text(
                                      'S/. ${widget.productosData.productoPrecio}',
                                      style: TextStyle(
                                          color: Colors.red,
                                          fontSize: responsive.ip(3),
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: responsive.hp(2),
                                ),
                                Text(
                                  '${widget.productosData.productoDescripcion} ',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: responsive.ip(1.8),
                                  ),
                                ),
                                SizedBox(
                                  height: responsive.hp(5),
                                )
                              ],
                            ),
                          ),
                        ),
                        Container(
                          height: responsive.hp(12),
                          child: Center(
                            child: Image.asset('assets/logo_enchilada.png'),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    color: Colors.black,
                    height: double.infinity,
                    width: double.infinity,
                  ),
                  Center(
                    child: GestureDetector(
                      onVerticalDragUpdate: (drag) {
                        if (drag.primaryDelta > 7) {
                          Navigator.pop(context);
                        }
                      },
                      child: Container(
                        width: double.infinity,
                        child: PhotoView(
                          imageProvider: CachedNetworkImageProvider(
                            '${widget.productosData.productoFoto}',
                            cacheManager: CustomCacheManager(),
                          ),
                        ),
                      ),
                    ),
                  ),
                  (!data)
                      ? Positioned(
                          bottom: 0,
                          right: 0,
                          left: 0,
                          child: Container(
                            color: Colors.black.withOpacity(.6),
                            padding: EdgeInsets.symmetric(
                                horizontal: responsive.wp(5)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: Text(
                                        '${widget.productosData.productoNombre}',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: responsive.ip(3),
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    SizedBox(
                                      width: responsive.wp(4),
                                    ),
                                    Text(
                                      'S/. ${widget.productosData.productoPrecio}',
                                      style: TextStyle(
                                          color: Colors.red,
                                          fontSize: responsive.ip(3),
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: responsive.hp(2),
                                ),
                                Text(
                                  '${widget.productosData.productoDescripcion} ',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: responsive.ip(1.8),
                                  ),
                                ),
                                SizedBox(
                                  height: responsive.hp(5),
                                )
                              ],
                            ),
                          ),
                        )
                      : Container(),
                ],
              ),
            );
          }),
    );
  }

  takeScreenshotandShare(String nombre) async {
    var now = DateTime.now();
    nombre = now.microsecond.toString();
    _imageFile = null;
    screenshotController
        .capture(delay: Duration(milliseconds: 10), pixelRatio: 2.0)
        .then((File image) async {
      setState(() {
        _imageFile = image;
      });

      await ImageGallerySaver.saveImage(image.readAsBytesSync());

      // Save image to gallery,  Needs plugin  https://pub.dev/packages/image_gallery_saver
      print("File Saved to Gallery");

      final directory = (await getApplicationDocumentsDirectory()).path;
      Uint8List pngBytes = _imageFile.readAsBytesSync();
      File imgFile = new File('$directory/Screenshot$nombre.png');
      imgFile.writeAsBytes(pngBytes);
      print("File Saved to Gallery");

      await Share.file(
          'Anupam', 'Screenshot$nombre.png', pngBytes, 'image/png');
    }).catchError((onError) {
      print(onError);
    });
  }
}
