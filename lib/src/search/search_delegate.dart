import 'package:cached_network_image/cached_network_image.dart';
import 'package:enchiladasapp/src/bloc/provider.dart';
import 'package:enchiladasapp/src/models/productos_model.dart';
import 'package:enchiladasapp/src/pages/detalle_producto2.dart';
import 'package:enchiladasapp/src/utils/responsive.dart';
import 'package:enchiladasapp/src/widgets/customCacheManager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter/material.dart';



class DataSearch extends SearchDelegate {
  DataSearch({
    String hintText,
  }) : super(
          searchFieldLabel: hintText,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.search,
        );

  String seleccion = '';

  @override
  List<Widget> buildActions(BuildContext context) {
    // Las acciones de nuestro Appbar(limpiar o cancelar)
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // Icono a la Izquierda del AppBar
    return IconButton(
      icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow, progress: transitionAnimation),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Crea los resultados que vamos a mostrar
    if (query.isEmpty) {
      return Container(
        child: Center(
          child: Text('Búsqueda de productos'),
        ),
      );
    }

    final productosBloc = ProviderBloc.prod(context);
    productosBloc.obtenerProductoPorQueryDelivery('$query');
    final responsive = Responsive.of(context);
    
    return StreamBuilder(
        stream: productosBloc.productosQueryStream,
        builder: (BuildContext context,
            AsyncSnapshot<List<ProductosData>> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.length > 0) {
              return ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: snapshot.data.length,
                itemBuilder: (context, i) => _itemPedido(
                  context,
                  snapshot.data[i],
                ),
              );
            } else {
              return Center(
                  child: Text(
                'No existen productos con ese nombre',
                style: TextStyle(
                  fontSize: responsive.ip(1.9),
                ),
              ));
            }
          } else {
           return Center(
              child: CupertinoActivityIndicator()
            );
          }
        });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return Container(
        child: Center(
          child: Text('Búsqueda de productos'),
        ),
      );
    }

    final productosBloc = ProviderBloc.prod(context);
    productosBloc.obtenerProductoPorQueryDelivery('$query');
    final responsive = Responsive.of(context);
    
    return StreamBuilder(
        stream: productosBloc.productosQueryStream,
        builder: (BuildContext context,
            AsyncSnapshot<List<ProductosData>> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.length > 0) {
              return ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, i) =>
                      _itemPedido(context, snapshot.data[i]));
            } else {
              return Center(
                child: Text(
                  'No existen productos con ese nombre',
                  style: TextStyle(
                    fontSize: responsive.ip(1.9),
                  ),
                ),
              );
            }
          } else {
            return Center(
              child: CupertinoActivityIndicator()
            );
          }
        });
  }

  Widget _itemPedido(BuildContext context, ProductosData productosData) {
    final responsive = Responsive.of(context);
    return GestureDetector(
      child: Container(
        margin: EdgeInsets.symmetric(
          vertical: responsive.hp(0.5),
          horizontal: responsive.wp(3),
        ),
        padding: EdgeInsets.only(
          right: responsive.wp(3),
        ),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          border: Border.all(color: Colors.white),
          borderRadius: BorderRadius.circular(13),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Container(
              width: responsive.wp(42),
              height: responsive.hp(16),
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(13),
                    child: CachedNetworkImage(
                      cacheManager: CustomCacheManager(),
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
                            ),
                          );
                        },errorWidget: (context, url, error) => Image(
                      image: AssetImage('assets/carga_fallida.jpg'),
                      fit: BoxFit.cover),
                      imageUrl: productosData.productoFoto,
                      imageBuilder: (context, imageProvider) => Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ),
                  ),('${productosData.productoNuevo}' == '1')
                      ? Positioned(
                        bottom: 0,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: responsive.wp(3),
                              vertical: responsive.wp(.5),
                            ),
                            decoration: BoxDecoration(
                                //borderRadius: BorderRadius.circular(10),
                                color: Colors.red),
                            child: Text(
                              'Nuevo',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: responsive.ip(1.5),
                              ),
                            ),
                          ),
                        )
                      : Container(),


                      ('${productosData.productoDestacado}' != '0')
                      ? Positioned(
                          
                          //right: 0,
                          //left: 0,
                          child:  Container(
                            transform: Matrix4.translationValues(
                                -responsive.wp(16), 0, 0),
                            height: responsive.ip(4),
                            child: SvgPicture.asset('assets/medalla.svg'),
                          ), 
                        ):Container()
                ],
              ),
            ),
            SizedBox(width: responsive.wp(2),),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: responsive.wp(.8),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      productosData.productoNombre,
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: responsive.ip(1.8),
                      ),
                    ),
                    Text(
                      productosData.productoPrecio,
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: responsive.ip(2),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      onTap: () {
        Navigator.push(
            context,
            PageRouteBuilder(
              transitionDuration: const Duration(milliseconds: 400),
              pageBuilder: (context, animation, secondaryAnimation) {
                return DetalleProductitoss2(productosData: productosData,mostrarback: true,);
              },
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                return FadeTransition(
                  opacity: animation,
                  child: child,
                );
              },
            ));
        //Navigator.pushNamed(context, 'detalleP', arguments: productosData);
      },
    );
  }
}
