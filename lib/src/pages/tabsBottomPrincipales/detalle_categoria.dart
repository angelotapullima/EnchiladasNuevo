import 'package:enchiladasapp/src/bloc/provider.dart';
import 'package:enchiladasapp/src/models/productos_model.dart';
import 'package:enchiladasapp/src/pages/detalle_productos.dart';
import 'package:enchiladasapp/src/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class Detallecategoria extends StatefulWidget {
  const Detallecategoria({
    Key key,
    @required this.idCategoria,
    @required this.categoriaNombre,
    @required this.categoriaIcono,
  }) : super(key: key);

  final String idCategoria;
  final String categoriaNombre;
  final String categoriaIcono;

  @override
  _DetallecategoriaState createState() => _DetallecategoriaState();
}

class _DetallecategoriaState extends State<Detallecategoria> {
  @override
  Widget build(BuildContext context) {
    final productoBloc = ProviderBloc.prod(context);
    productoBloc.obtenerProductosdeliveryEnchiladasPorCategoria(widget.idCategoria);

    final responsive = Responsive.of(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          widget.categoriaNombre,
          style: TextStyle(
            fontFamily: 'MADE-TOMMY',
            fontWeight: FontWeight.bold,
            color: Colors.grey[700],
            fontSize: 19,
          ),
        ),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: StreamBuilder(
        stream: productoBloc.productosEnchiladasStream,
        builder: (BuildContext context, AsyncSnapshot<List<ProductosData>> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.length > 0) {
              return ListView.builder(
                padding: EdgeInsets.only(
                  top: responsive.hp(1),
                ),
                itemCount: snapshot.data.length,
                itemBuilder: (context, i) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          transitionDuration: const Duration(milliseconds: 100),
                          pageBuilder: (context, animation, secondaryAnimation) {
                            //return DetalleProductitos(productosData: productosData);
                            return SliderDetalleProductos(
                              numeroItem: snapshot.data[i].numeroitem,
                              idCategoria: snapshot.data[i].idCategoria,
                              cantidadItems: snapshot.data.length.toString(),
                            );
                          },
                          transitionsBuilder: (context, animation, secondaryAnimation, child) {
                            return FadeTransition(
                              opacity: animation,
                              child: child,
                            );
                          },
                        ),
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: responsive.wp(2),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                height: responsive.ip(4),
                                width: responsive.ip(4),
                                child: SvgPicture.network(
                                  widget.categoriaIcono,
                                  semanticsLabel: 'A shark?!',
                                  placeholderBuilder: (BuildContext context) => Container(
                                    padding: const EdgeInsets.all(30.0),
                                    child: const CircularProgressIndicator(),
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              SizedBox(
                                width: responsive.wp(3),
                              ),
                              Expanded(
                                child: Text('${snapshot.data[i].productoNombre}'),
                              ),
                              /* Container(
                                width: responsive.wp(20),
                                child: Text(
                                  'S/. ${snapshot.data[i].productoPrecio}',
                                  style: TextStyle(
                                    fontSize: responsive.ip(1.8),
                                  ),
                                ),
                              ) */
                            ],
                          ),
                          Divider()
                        ],
                      ),
                    ),
                  );
                  /* return Transform.translate(
                    offset: Offset(00, i.isOdd ? 100 : 0),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                      ),
                      margin: EdgeInsets.only(
                        right: responsive.wp(1.5),
                        left: responsive.wp(1.5),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Stack(
                            children: <Widget>[
                              Container(
                                height: responsive.hp(14),
                                width: double.infinity,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: CachedNetworkImage(
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
                                                valueColor: new AlwaysStoppedAnimation<Color>(Colors.red),
                                              ),
                                            ),
                                            Center(
                                              child: (downloadProgress.progress != null)
                                                  ? Text('${(downloadProgress.progress * 100).toInt().toString()}%')
                                                  : Container(),
                                            )
                                          ],
                                        ),
                                      );
                                    },
                                    errorWidget: (context, url, error) => Image(image: AssetImage('assets/carga_fallida.jpg'), fit: BoxFit.cover),
                                    imageUrl: '${snapshot.data[i].productoFoto}',
                                    imageBuilder: (context, imageProvider) => Container(
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: imageProvider,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 5,
                                left: 0,
                                right: 0,
                                /*  left: responsive.wp(1),
                                          top: responsive.hp(.5), */
                                child: Row(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: responsive.wp(3),
                                        vertical: responsive.hp(.5),
                                      ),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                            bottomRight: Radius.circular(10),
                                          ),
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
                                    Spacer(),
                                    Container(
                                      padding: EdgeInsets.all(5),
                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(100), color: Colors.white),
                                      child: Center(
                                        child: Icon(
                                          Ionicons.md_heart,
                                          color: Colors.red,
                                          size: 15,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: responsive.wp(2),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                          Container(
                            padding: EdgeInsets.only(
                              right: responsive.wp(1.5),
                              left: responsive.wp(1.5),
                            ),
                            height: responsive.hp(3),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'S/ ${snapshot.data[i].productoPrecio}',
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontFamily: 'Aeonik',
                                    fontSize: 17,
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: responsive.wp(2),
                                    vertical: responsive.hp(.5),
                                  ),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      /* borderRadius: BorderRadius.only(
                                                bottomRight: Radius.circular(10),
                                              ), */
                                      color: Colors.orange),
                                  child: Text(
                                    'Destacado',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: responsive.ip(1.3),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              right: responsive.wp(1.5),
                              left: responsive.wp(1.5),
                            ),
                            child: Text(
                              '${snapshot.data[i].productoNombre}',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'Aeonik',
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                */
                },
              );
            } else {
              return Container(
                child: Center(
                  child: Text('No hay datos'),
                ),
              );
            }
          } else {
            return Container();
          }
        },
      ),
    );
  }
}
