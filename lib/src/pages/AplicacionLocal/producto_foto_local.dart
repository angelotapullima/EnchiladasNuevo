import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:enchiladasapp/src/bloc/provider.dart';
import 'package:enchiladasapp/src/models/productos_model.dart';
import 'package:enchiladasapp/src/utils/responsive.dart';
import 'package:enchiladasapp/src/widgets/customCacheManager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

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
    productoBloc.obtenerProductosLocalEnchiladasPorCategoria(widget.idCategoria);
    contadorProductosFotoLocal.changeContador(int.parse(widget.numeroItem));

    final responsive = Responsive.of(context);
    return StreamBuilder(
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
        });
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

     assetsAudioPlayer.open(
      Audio("assets/audio/${widget.productosData.sonido}.mp3"),
    );
    final responsive = Responsive.of(context);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: (widget.mostrarback)
          ? AppBar(
              backgroundColor: Colors.black,
            )
          : AppBar(
              backgroundColor: Colors.black,
              leading: Container(),
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
                      onVerticalDragUpdate: (drag) {
                        if (drag.primaryDelta > 7) {
                          Navigator.pop(context);
                        }
                      },
                      child: Container(
                        width: double.infinity,
                        child: Hero(
                          tag: '${widget.productosData.idProducto}',
                          child: PhotoView(
                            imageProvider: CachedNetworkImageProvider(
                              '${widget.productosData.productoFoto}',
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
}
