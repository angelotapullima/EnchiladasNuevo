import 'package:cached_network_image/cached_network_image.dart';
import 'package:enchiladasapp/src/bloc/provider.dart';
import 'package:enchiladasapp/src/models/productos._model.dart';
import 'package:enchiladasapp/src/utils/responsive.dart';
import 'package:enchiladasapp/src/widgets/zona_direction.dart';
import 'package:flutter/cupertino.dart';
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
    productosBloc.obtenerProductoPorQuery('$query');
    final responsive = Responsive.of(context);
    print('query $query');
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
              child: Text(
                'Hubo un error',
                style: TextStyle(
                  fontSize: responsive.ip(1.9),
                ),
              ),
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
    productosBloc.obtenerProductoPorQuery('$query');
    final responsive = Responsive.of(context);
    print('query $query');
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
              child: Text(
                'Hubo un error',
                style: TextStyle(
                  fontSize: responsive.ip(1.9),
                ),
              ),
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
              width: responsive.wp(35),
              height: responsive.hp(10),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(13),
                child: CachedNetworkImage(
                  cacheManager: CustomCacheManager(),
                  placeholder: (context, url) => Image(
                      image: AssetImage('assets/jar-loading.gif'),
                      fit: BoxFit.cover),
                  errorWidget: (context, url, error) => Icon(Icons.error),
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
              ),
            ),
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
        Navigator.pushNamed(context, 'detalleP', arguments: productosData);
      },
    );
  }
}
