import 'package:cached_network_image/cached_network_image.dart';
import 'package:enchiladasapp/src/models/zona_model.dart';
import 'package:enchiladasapp/src/utils/responsive.dart';
import 'package:enchiladasapp/src/widgets/zona_direction.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:enchiladasapp/src/utils/utilidades.dart' as utils;

class ZoomFotoDireccion extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Zona zona = ModalRoute.of(context).settings.arguments;
    final responsive = Responsive.of(context);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        actions: <Widget>[
          Center(
              child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: FlatButton(
                onPressed: () async {
                  final res = await utils.agregarZona(context, zona.idZona);
                  if (res) {
                    pedidoCorrecto(context);
                  } else {}
                },
                child: Text(
                  'Aceptar Imágen',
                  style: TextStyle(
                      color: Colors.white, fontSize: responsive.ip(1.5)),
                )),
          ))
        ],
      ),
      body: Center(
        child: PhotoView(
          imageProvider: CachedNetworkImageProvider(zona.zonaImagen,
              cacheManager: CustomCacheManager()),
        ),
      ),
    );
  }

  void pedidoCorrecto(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (contextd) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            title: Text('Su zona fue ingresada correctamente'),
            actions: <Widget>[
              FlatButton(
                  onPressed: () async {
                    Navigator.popUntil(context, ModalRoute.withName('/'));
                  },
                  child: Text('Continuar')),
            ],
          );
        });
  }
}
