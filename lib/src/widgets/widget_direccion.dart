import 'package:enchiladasapp/src/utils/responsive.dart';
import 'package:enchiladasapp/src/widgets/zona_direction.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

Widget widgetDireccion(String imagen, String titulo, String monto,
    String descripcion, Responsive responsive) {
  return SingleChildScrollView(
      child: Column(
      children: <Widget>[
        SizedBox(
          height: responsive.hp(10),
        ),
        Container(
          height: responsive.hp(45),
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            child: CachedNetworkImage(
              cacheManager: CustomCacheManager(),
              imageUrl: imagen,
              imageBuilder: (context, imageProvider) => Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ),
        ),
        Text(
          titulo,
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white, fontSize: responsive.ip(3)),
        ),
        SizedBox(
          height: responsive.hp(1.5),
        ),
        Text(
          'Monto mínimo S/.$monto',
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: responsive.ip(2)),
        ),
        SizedBox(
          height: responsive.hp(1.5),
        ),
        Text(
          descripcion,
          maxLines: 4,
          overflow: TextOverflow.ellipsis, 
          style: TextStyle(
            color: Colors.white,
            fontSize: responsive.ip(2),
          ),
        ),
        SizedBox(
          height: responsive.wp(1.5),
        ),
      ],
    ),
  );
}
