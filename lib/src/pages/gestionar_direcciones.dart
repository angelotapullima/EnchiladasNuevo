import 'package:enchiladasapp/src/bloc/provider.dart';
import 'package:enchiladasapp/src/database/direccion_database.dart';
import 'package:enchiladasapp/src/models/direccion_model.dart';
import 'package:enchiladasapp/src/utils/circle.dart';
import 'package:enchiladasapp/src/utils/responsive.dart';
import 'package:enchiladasapp/src/utils/utilidades.dart' as utils;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class GestionarDirecciones extends StatelessWidget {
  const GestionarDirecciones({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);
    final direccionesBloc = ProviderBloc.dire(context);
    direccionesBloc.obtenerDirecciones();
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            height: responsive.hp(80),
            width: double.infinity,
            color: Colors.green,
            child: AppBar(
              title: Text('Direcciones Favoritas'),
              elevation: 0,
            ),
          ),
          Container(
            margin: EdgeInsets.only(
              top: kToolbarHeight + responsive.hp(5),
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadiusDirectional.only(
                topStart: Radius.circular(20),
                topEnd: Radius.circular(20),
              ),
              color: Colors.grey[50],
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: responsive.wp(3),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  SizedBox(
                    height: responsive.hp(1),
                  ),
                  Text(
                    'Agrega o escoge una dirección',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: responsive.ip(2.8),
                    ),
                  ),
                  Container(
                    width: responsive.wp(30),
                    height: responsive.hp(4.5),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        IconButton(
                            icon: Icon(
                              Icons.delete,
                              color: Colors.white,
                            ),
                            onPressed: () async {
                              final direccionDatabase = DireccionDatabase();
                              await direccionDatabase.deleteDireccion();
                              direccionesBloc.obtenerDirecciones();
                              direccionesBloc.obtenerDireccionesConZonas();
                            }),
                        Expanded(
                          child: Text(
                            'Eliminar todos',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: responsive.ip(1.2),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      left: responsive.wp(3),
                      right: responsive.wp(3),
                      top: responsive.hp(1),
                    ),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, 'sel_Direccion');
                      },
                      child: Row(
                        children: <Widget>[
                          CircleContainer(
                            color: Colors.grey,
                            radius: responsive.ip(3),
                            widget: Icon(Icons.home, color: Colors.white),
                          ),
                          SizedBox(
                            width: responsive.wp(5),
                          ),
                          Expanded(
                            child: Text(
                              'Agregar Ubicación',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: responsive.ip(2),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: responsive.wp(5),
                          ),
                          IconButton(
                            onPressed: () {
                              Navigator.pushNamed(context, 'sel_Direccion');
                            },
                            icon: Icon(Icons.arrow_forward_ios,
                                size: responsive.ip(3), color: Colors.red),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: responsive.hp(1),
                  ),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: responsive.wp(3),
                      ),
                      height: double.infinity,
                      width: double.infinity,
                      child: StreamBuilder(
                          stream: direccionesBloc.direccionesStream,
                          builder: (BuildContext context,
                              AsyncSnapshot<List<Direccion>> snapshot) {
                            var ubicacionActual = Column(
                              children: <Widget>[
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(
                                        context, 'sel_Direccion');
                                  },
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      CircleContainer(
                                        color: Colors.red,
                                        radius: responsive.ip(3),
                                        widget: Icon(Icons.near_me,
                                            color: Colors.white),
                                      ),
                                      SizedBox(
                                        width: responsive.wp(5),
                                      ),
                                      Expanded(
                                        child: Text(
                                          'Ubicación Actual',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: responsive.ip(2),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: responsive.wp(5),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          Navigator.pushNamed(
                                              context, 'sel_Direccion');
                                        },
                                        icon: Icon(Icons.arrow_forward_ios,
                                            size: responsive.ip(3),
                                            color: Colors.red),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: responsive.hp(1),
                                ),
                                Divider()
                              ],
                            );

                            if (snapshot.hasData) {
                              if (snapshot.data.length > 0) {
                                return ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  itemCount: snapshot.data.length + 1,
                                  itemBuilder: (context, i) {
                                    if (i == 0) {
                                      return ubicacionActual;
                                    }

                                    int index = i - 1;
                                    return _carDirection(context, responsive,
                                        snapshot.data[index]);
                                  },
                                );
                              } else {
                                return ubicacionActual;
                              }
                            } else {
                              return Center(
                                child: CupertinoActivityIndicator(),
                              );
                            }
                          }),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _carDirection(
      BuildContext context, Responsive responsive, Direccion direccion) {
    return GestureDetector(
      onTap: () {
        utils.seleccionarDireccion(context, '${direccion.idDireccion}');
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
        ),
        width: responsive.wp(50),
        padding: EdgeInsets.symmetric(
          horizontal: responsive.ip(1.5),
        ),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Center(
                  child: Container(
                    child:
                        Icon(FontAwesomeIcons.truck, color: Colors.grey[600]),
                  ),
                ),
                SizedBox(
                  width: responsive.wp(5),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        '${direccion.direccion}',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: responsive.ip(2),
                        ),
                      ),
                      Text(
                        '${direccion.referencia}',
                        style: TextStyle(
                          fontSize: responsive.ip(2),
                        ),
                      ),
                      Text(
                        '${direccion.zonaNombre}',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: responsive.ip(2),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: responsive.wp(5),
                ),
                ('${direccion.seleccionado}' != '1')
                    ? IconButton(
                        onPressed: () {
                          utils.deleteDireccion(
                              context, '${direccion.idDireccion}');
                        },
                        icon: Icon(Icons.delete_outline,
                            size: responsive.ip(4), color: Colors.red),
                      )
                    : CircleContainer(
                        radius: responsive.ip(2),
                        color: Colors.blue,
                        widget: Icon(Icons.check, color: Colors.white),
                      ),
              ],
            ),
            Divider()
          ],
        ),
      ),
    );
  }
}
