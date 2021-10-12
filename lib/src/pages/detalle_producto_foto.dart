import 'dart:io';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:enchiladasapp/src/models/productos_model.dart';
import 'package:enchiladasapp/src/utils/circle.dart';
import 'package:enchiladasapp/src/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_view/photo_view.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_extend/share_extend.dart';

class DetalleProductoFoto extends StatefulWidget {
  const DetalleProductoFoto({Key key}) : super(key: key);

  @override
  _DetalleProductoFotoState createState() => _DetalleProductoFotoState();
}

class _DetalleProductoFotoState extends State<DetalleProductoFoto> {
  final _toque = ValueNotifier<bool>(false);
  Uint8List _imageFile;
  List<String> imagePaths = [];
  ScreenshotController screenshotController = ScreenshotController();

  @override
  Widget build(BuildContext context) {
    final ProductosData productosData = ModalRoute.of(context).settings.arguments;

    final responsive = Responsive.of(context);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        actions: [
          GestureDetector(
            child: CircleContainer(radius: responsive.ip(2.5), color: Colors.transparent, widget: Icon(Icons.share) //Icon(Icons.arrow_back, color: Colors.black),
                ),
            onTap: () async {
              await takeScreenshotandShare();
              //_logoScreen.value = false;
            },
          ),
        ],
      ),
      body: ValueListenableBuilder(
          valueListenable: _toque,
          builder: (BuildContext context, bool dataToque, Widget child) {
            print(dataToque);
            return InkWell(
              onTap: () {
                if (dataToque) {
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
                              '${productosData.productoFoto}',
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
                                        '${productosData.productoNombre}',
                                        style: TextStyle(color: Colors.white, fontSize: responsive.ip(3), fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    SizedBox(
                                      width: responsive.wp(4),
                                    ),
                                    Text(
                                      'S/. ${productosData.productoPrecio}',
                                      style: TextStyle(color: Colors.red, fontSize: responsive.ip(3), fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: responsive.hp(2),
                                ),
                                Text(
                                  '${productosData.productoDescripcion} ',
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
                        child: Hero(
                          tag: '${productosData.idProducto}',
                          child: PhotoView(
                            imageProvider: CachedNetworkImageProvider(
                              '${productosData.productoFoto}',
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  (!dataToque)
                      ? Positioned(
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
                                        '${productosData.productoNombre}',
                                        style: TextStyle(color: Colors.white, fontSize: responsive.ip(3), fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    SizedBox(
                                      width: responsive.wp(4),
                                    ),
                                    Text(
                                      'S/. ${productosData.productoPrecio}',
                                      style: TextStyle(color: Colors.red, fontSize: responsive.ip(3), fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: responsive.hp(1),
                                ),
                                SizedBox(
                                  height: responsive.hp(2),
                                ),
                                Text(
                                  '${productosData.productoDescripcion} ',
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
                  (!dataToque)
                      ? ('${productosData.productoNuevo}' == '1')
                          ? Positioned(
                              top: 0,
                              left: 0,
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: responsive.wp(3),
                                  vertical: responsive.wp(.5),
                                ),
                                decoration: BoxDecoration(
                                    //borderRadius: BorderRadius.circular(10),
                                    color: Colors.red),
                                child: Text(
                                  'Producto Nuevo',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: responsive.ip(2),
                                  ),
                                ),
                              ),
                            )
                          : Container()
                      : Container()
                ],
              ),
            );
          }),
    );
  }

  takeScreenshotandShare() async {
    var now = DateTime.now();
    var nombre = now.microsecond.toString();
    _imageFile = null;
    screenshotController
        .capture(
      delay: Duration(milliseconds: 10),
      pixelRatio: 2.0,
    )
        .then((Uint8List image) async {
      setState(() {
        _imageFile = image;
      });

      await ImageGallerySaver.saveImage(image);

      // Save image to gallery,  Needs plugin  https://pub.dev/packages/image_gallery_saver
      print("File Saved to Gallery");

      final directory = (await getApplicationDocumentsDirectory()).path;
      Uint8List pngBytes = _imageFile;
      File imgFile = new File('$directory/Screenshot$nombre.png');
      imgFile.writeAsBytes(pngBytes);
      print("File Saved to Gallery");

      imagePaths.clear();
      imagePaths.add(imgFile.path);
      if (imagePaths.isNotEmpty) {
        await Future.delayed(
          Duration(seconds: 1),
        );

        ShareExtend.shareMultiple(imagePaths, "image", subject: "carnet");

        /*  await Share.shareFiles(imagePaths,
            text: 'prueba',
            subject: 'prueba',
            sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size); */
      } else {
        /*  await Share.share('prueba',
            subject: 'prueba',
            sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size); */
      }
    }).catchError((onError) {
      print(onError);
    });
  }
}
