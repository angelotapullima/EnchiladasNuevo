import 'package:cached_network_image/cached_network_image.dart';
import 'package:enchiladasapp/src/models/productos._model.dart';
import 'package:enchiladasapp/src/utils/responsive.dart';
import 'package:enchiladasapp/src/widgets/customCacheManager.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class DetalleProductoFoto extends StatefulWidget {
  const DetalleProductoFoto({Key key}) : super(key: key);

  @override
  _DetalleProductoFotoState createState() => _DetalleProductoFotoState();
}

class _DetalleProductoFotoState extends State<DetalleProductoFoto> {
  final _toque = ValueNotifier<bool>(false);

  @override
  Widget build(BuildContext context) {
    final ProductosData productosData =
        ModalRoute.of(context).settings.arguments;

    final responsive = Responsive.of(context);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
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
                  Center(
                    child: GestureDetector(
                      onVerticalDragUpdate: (algo) {
                        if (algo.primaryDelta > 7) {
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
                              cacheManager: CustomCacheManager(),
                            ),
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
                                        '${productosData.productoNombre}',
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
                                      'S/. ${productosData.productoPrecio}',
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
                                  '${productosData.productoDescripcion} ',
                                  style: TextStyle(color: Colors.white ,fontSize: responsive.ip(1.8),),
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
}
