import 'package:cached_network_image/cached_network_image.dart';
import 'package:enchiladasapp/src/bloc/provider.dart';
import 'package:enchiladasapp/src/models/productos_model.dart';
import 'package:enchiladasapp/src/pages/AplicacionLocal/producto_foto_local.dart';
import 'package:enchiladasapp/src/utils/responsive.dart';
import 'package:enchiladasapp/src/widgets/customCacheManager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchLocal extends SearchDelegate {
  SearchLocal({
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
    productosBloc.obtenerProductoPorQueryLocal('$query');
    final responsive = Responsive.of(context);

    return StreamBuilder(
        stream: productosBloc.productosQueryStream,
        builder: (BuildContext context,
            AsyncSnapshot<List<ProductosData>> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.length > 0) {
              return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
                itemCount: snapshot.data.length,
                itemBuilder: (context, i) => _itemPedido(
                    context, snapshot.data[i], snapshot.data.length.toString()),
              );
              /* return ListView.builder(
                scrollDirection: Axis.vertical, 
                shrinkWrap: true,
                itemCount: snapshot.data.length,
                itemBuilder: (context, i) => _itemPedido(
                  context,
                  snapshot.data[i],
                ),
              ); */
            } else {
              return Center(
                  child: Text(
                'No existen productos con ese nombre buildResults',
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
    productosBloc.obtenerProductoPorQueryLocal('$query');
    final responsive = Responsive.of(context);


  

  

    return StreamBuilder(
        stream: productosBloc.productosQueryStream,
        builder: (BuildContext context,
            AsyncSnapshot<List<ProductosData>> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.length > 0) {
              return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2),
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, i) {
                    return _itemPedido(context, snapshot.data[i],
                        snapshot.data.length.toString());
                  });
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

  Widget _itemPedido(
      BuildContext context, ProductosData productosData, String cantidad) {
    final Responsive responsive = new Responsive.of(context);

    return GestureDetector(
      child: Container(
        width: responsive.ip(20),
        height: responsive.ip(16),
        decoration: BoxDecoration(
            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 3)],
            color: Colors.white,
            border: Border.all(color: Colors.white),
            borderRadius: BorderRadius.circular(8)),
        margin: EdgeInsets.symmetric(
            vertical: responsive.hp(0.5), horizontal: responsive.wp(2.5)),
        //height: responsive.hp(13),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
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
                        },
                errorWidget: (context, url, error) => Image(
                    image: AssetImage('assets/carga_fallida.jpg'),
                    fit: BoxFit.cover),
                imageUrl: '${productosData.productoFoto}',
                imageBuilder: (context, imageProvider) => Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.cover,
                  )),
                ),
              ),
            ),
            Positioned(
              right: 0,
              left: 0,
              bottom: 0,
              child: Container(
                padding: EdgeInsets.symmetric(
                  vertical: responsive.hp(2),
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(.5),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '${productosData.productoNombre}',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: responsive.ip(2),
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
            )
          ],
        ),
      ),
      onTap: () {
        Navigator.push(
            context,
            PageRouteBuilder(
              transitionDuration: const Duration(milliseconds: 400),
              pageBuilder: (context, animation, secondaryAnimation) {
                return DetalleProductoFotoLocal(
                  
                  productosData: productosData,
                  mostrarback: true,
                );
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
