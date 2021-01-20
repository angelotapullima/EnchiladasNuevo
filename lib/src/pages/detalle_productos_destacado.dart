import 'dart:ui';
import 'package:enchiladasapp/src/bloc/provider.dart';
import 'package:enchiladasapp/src/models/productos_model.dart';
import 'package:enchiladasapp/src/pages/detalle_productos.dart';
import 'package:enchiladasapp/src/utils/responsive.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SliderDetalleProductosDestacados extends StatefulWidget {
  final String numeroItem;
  final String idCategoria;
  final List<ProductosData> items;
  const SliderDetalleProductosDestacados(
      {Key key,
      @required this.numeroItem,
      @required this.idCategoria,
      @required this.items})
      : super(key: key);

  @override
  _SliderDetalleProductosState createState() => _SliderDetalleProductosState();
}

class _SliderDetalleProductosState
    extends State<SliderDetalleProductosDestacados> {
  @override
  Widget build(BuildContext context) {
    final _pageController =
        PageController(initialPage: int.parse(widget.numeroItem));

    final productoBloc = ProviderBloc.prod(context);
    final contadorProductosFotoLocal = ProviderBloc.contadorLocal(context);
    productoBloc
        .obtenerProductosdeliveryEnchiladasPorCategoria(widget.idCategoria);
    contadorProductosFotoLocal.changeContador(int.parse(widget.numeroItem));

    final responsive = Responsive.of(context);

    final List<Widget> imageSliders = widget.items
        .map(
          (item) => Container(
            child: DetalleProductitoss(
              productosData: item,
              mostrarback: false,
            ),
          ),
        )
        .toList();

    return Scaffold(
        body: Stack(
      children: [
        PageView(
            controller: _pageController,
            children: imageSliders,
            onPageChanged: (int index) {
              contadorProductosFotoLocal.changeContador(index);
            }),
        StreamBuilder(
            stream: contadorProductosFotoLocal.selectContadorStream,
            builder: (context, snapshotContador) {
              if (snapshotContador.hasData) {
                if (snapshotContador.data != null) {
                  return Container(
                    height: kToolbarHeight + 50,
                    child: AppBar(
                      backgroundColor: Colors.transparent,
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
                                '${widget.items.length}',
                                style: TextStyle(
                                    fontSize: responsive.ip(1.5),
                                    color: Colors.black),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  );
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
      ],
    ));
  }
}
