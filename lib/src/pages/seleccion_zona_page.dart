import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:enchiladasapp/src/bloc/provider.dart';
import 'package:enchiladasapp/src/models/zona_model.dart';
import 'package:enchiladasapp/src/utils/responsive.dart';
import 'package:enchiladasapp/src/widgets/widget_direccion.dart';
import 'package:enchiladasapp/src/widgets/zona_direction.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SeleccionZona extends StatelessWidget {
  final CarouselController buttonCarouselController = CarouselController();
  final ScrollController _scrollController = new ScrollController();

  @override
  Widget build(BuildContext context) {
    final Responsive responsive = new Responsive.of(context);
    final zonaBloc = ProviderBloc.zona(context);
    zonaBloc.obtenerZonas();

    return Scaffold(
        //resizeToAvoidBottomInset:false,

        body: StreamBuilder(
            stream: zonaBloc.zonasStream,
            builder: (BuildContext context, AsyncSnapshot<List<Zona>> snapshot) {
              if(snapshot.hasData){
                return Stack(
                children: <Widget>[
                  _stackTarjetas(context, snapshot.data, responsive),
                  Container(
                    height: responsive.hp(10),
                    child: AppBar(
                      backgroundColor: Colors.transparent,
                      title: Text(''),
                    ),
                  ),
                ],
              );
              }else{
                return CupertinoActivityIndicator();
              }
              
            }
        )
    );
  }

  Widget _stackTarjetas(
      BuildContext context, List<Zona> zona, Responsive responsive) {
    return Stack(
      children: <Widget>[
        _backgroundImage(zona, responsive),
        _carousel(context, zona, responsive),
        _button(context, zona, responsive),
      ],
    );
  }

  Widget _button(BuildContext context, List<Zona> zona, Responsive responsive) {
    final size = MediaQuery.of(context).size;
    return Positioned(
      bottom: responsive.hp(2),
      left: responsive.wp(10),
      right: responsive.wp(10),
      child: ButtonTheme(
        height: responsive.hp(6),
        minWidth: responsive.wp(10),
        child: RaisedButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          color: Colors.red,
          textColor: Colors.white,
          onPressed: () {
            Zona zonasss = Zona();
            zonasss.idZona = zona[(_scrollController.offset ~/ size.width)].idZona;
            zonasss.idProducto = zona[(_scrollController.offset ~/ size.width)].idProducto;
            zonasss.zonaNombre = zona[(_scrollController.offset ~/ size.width)].zonaNombre;
            zonasss.zonaDescripcion = zona[(_scrollController.offset ~/ size.width)].zonaDescripcion;
            zonasss.zonaPedidoMinimo = zona[(_scrollController.offset ~/ size.width)].zonaPedidoMinimo;
            zonasss.zonaDescripcion = zona[(_scrollController.offset ~/ size.width)].zonaDescripcion;
            zonasss.zonaImagen = zona[(_scrollController.offset ~/ size.width)].zonaImagen;
            Navigator.pushNamed(context, 'zoomDireccion',
                arguments: zonasss
                    );
          },
          child: Text("Seleccionar ".toUpperCase(),
              style: TextStyle(fontSize: responsive.ip(1.8))),
        ),
      ),
    );
  }

  Widget _backgroundImage(List<Zona> zona, Responsive responsive) {
    return Stack(
      children: <Widget>[
        Container(
          width: double.infinity,
          child: ListView.builder(
              controller: _scrollController,
              reverse: true,
              scrollDirection: Axis.horizontal,
              itemCount: zona.length,
              itemBuilder: (BuildContext context, int index) {
                return new Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: new BoxDecoration(
                      color: Colors.black12,
                    ),
                    child: new Container(
                      child: CachedNetworkImage(
                        cacheManager: CustomCacheManager(),
                        imageUrl: zona[index].zonaImagen,
                        imageBuilder: (context, imageProvider) => Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover,
                          )),
                        ),
                      ),
                      decoration: new BoxDecoration(
                          color: Colors.black.withOpacity(0.7)),
                    ));
              }),
        ),
        Container(
          decoration: new BoxDecoration(color: Colors.black.withOpacity(0.6)),
        )
      ],
    );
  }

  Widget _carousel(
      BuildContext context, List<Zona> zona, Responsive responsive) {
    final List<Widget> imageSliders = zona
        .map((item) => Container(
                child: DownloadZonaPage(
              foto: item.zonaImagen,
              nombre: item.zonaNombre,
              pedidoMinimo: item.zonaPedidoMinimo,
              descripcion: item.zonaDescripcion,
              idZona: item.idZona,
              devolucion: widgetDireccion(item.zonaImagen, item.zonaNombre,
                  item.zonaPedidoMinimo, item.zonaDescripcion, responsive),
            )))
        .toList();

    final size = MediaQuery.of(context).size;
    return CarouselSlider(
      options: CarouselOptions(
        height: size.height,
        aspectRatio: 2,
        carouselController: buttonCarouselController,
        viewportFraction: 0.68,
        enlargeCenterPage: true,
        enableInfiniteScroll: false,
        onScrolled: (data) {
          _scrollController.animateTo(
            data * size.width,
            curve: Curves.ease,
            duration: const Duration(milliseconds: 100),
          );
          //print(_scrollController.toString());
        },
      ),
      items: imageSliders,
    );
  }
}
