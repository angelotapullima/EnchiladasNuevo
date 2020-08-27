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
                    pedidoCorrecto(context, zona);
                  } else {}
                },
                child: Text(
                  'Aceptar Imagen',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: responsive.ip(2),
                  ),
                ),
              ),
            ),
          )
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

  void pedidoCorrecto(BuildContext context, Zona zona) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (contextd) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          title: Text('¡Su zona fue ingresada correctamente!'),
          actions: <Widget>[
            FlatButton(
              onPressed: () async {
                if (zona.route == 'carrito') {
                  Navigator.popUntil(
                    context,
                    ModalRoute.withName('/'),
                  );
                } else if (zona.route == 'pago') {
                  Navigator.popUntil(context, ModalRoute.withName('detallePago'));
                }
              },
              child: Text('Continuar'),
            ),
          ],
        );
      },
    );
  }
}
