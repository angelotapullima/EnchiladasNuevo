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
      body: Stack(
        children: <Widget>[
          Center(
            child: Container(
              width: double.infinity,
              child: Hero(
                tag: '${productosData.idProducto}',
                child: 
                PhotoView(
          imageProvider: CachedNetworkImageProvider(
           '${productosData.productoFoto}',
            cacheManager: CustomCacheManager(),
          ),
        ),
                
                /* CachedNetworkImage(
                    cacheManager: CustomCacheManager(),
                    placeholder: (context, url) => Image(
                        image: AssetImage('assets/jar-loading.gif'),
                        fit: BoxFit.cover),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                    imageUrl: '${productosData.productoFoto}',
                    imageBuilder: (context, imageProvider) => Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                    ),
                  
                ), */
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            left: 0,
            child: Container(
              color: Colors.black.withOpacity(.6),
              padding: EdgeInsets.symmetric(horizontal: responsive.wp(5)),
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
                    style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(
                    height: responsive.hp(5),
                  )
                ],
              ),
            ),
          ),
          /* Positioned(
            top: 0,
            right: 0,
            left: 0,
            child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: responsive.wp(5)
                ),
                height: responsive.hp(7),
                width: double.infinity,
                child: Row(
                  children: <Widget>[
                    Container(
                      width: responsive.wp(20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.transparent),
                      ),
                      child: Center(
                        child: (productosData.productoFavorito == 1)
                            ? IconButton(
                                onPressed: () {
                                  setState(() {
                                    print('quitar');
                                    utils.quitarFavoritos(
                                        context, productosData);
                                  });
                                },
                                icon: Icon(
                                  FontAwesomeIcons.solidHeart,
                                  color: Colors.red,
                                  size: responsive.ip(2.5),
                                ),
                              )
                            : IconButton(
                                onPressed: () {
                                  setState(() {
                                    print('agregar');
                                    utils.agregarFavoritos(
                                        context, productosData);
                                  });
                                },
                                icon: Icon(
                                  FontAwesomeIcons.heart,
                                  color: Colors.red,
                                  size: responsive.ip(2.5),
                                ),
                              ),
                      ),
                    ),
                    SizedBox(
                      width: responsive.wp(5),
                    ),
                    GestureDetector(
                      child: Container(
                        width: responsive.wp(65),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.red,
                          border: Border.all(color: Colors.red),
                        ),
                        child: Center(
                          child: Text(
                            'Agregar al Carrito',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: responsive.ip(2.5),
                            ),
                          ),
                        ),
                      ),
                      onTap: () {
                        utils.agregarCarrito(productosData, context, "1");
                      },
                    )
                  ],
                ),
              
            ),
          )
         */],
      ),
    );
  }
}
