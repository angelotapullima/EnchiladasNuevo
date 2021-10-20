import 'package:chips_choice/chips_choice.dart';
import 'package:enchiladasapp/src/bloc/provider.dart';
import 'package:enchiladasapp/src/models/productos_model.dart';
import 'package:enchiladasapp/src/utils/utilidades.dart' as utils;
import 'package:flutter/material.dart';

class PropinaPage extends StatefulWidget {
  const PropinaPage({Key key}) : super(key: key);

  @override
  _PropinaPageState createState() => _PropinaPageState();
}

class _PropinaPageState extends State<PropinaPage> {
  int tagFijos;
  int cantidad = 0;
  @override
  Widget build(BuildContext context) {
    final propinasBloc = ProviderBloc.propina(context);
    propinasBloc.obtenerPropinas();

    if(cantidad==0){

    utils.deletePropinas(context);
    }
    return Container(
      //height: responsive.hp(15),
      child: StreamBuilder(
        stream: propinasBloc.propinasStream,
        builder: (BuildContext context,
            AsyncSnapshot<List<ProductosData>> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.length > 0) {
              final List<String> algo = [];
              algo.add('Sin propina');

              for (var i = 0; i < snapshot.data.length; i++) {
                var item = snapshot.data[i].productoPrecio;
                algo.add(item);
              }

              return ChipsChoice<int>.single(
                value: tagFijos,
                onChanged: (val) async {
                  setState(() {
                    tagFijos = val;

                    if (val == 0) {
                      ProductosData productos = ProductosData();

                      utils.agregarPropinaCarrito(productos, context, '0');
                      print(' me llegan al chopin');
                    } else {
                      print('hjbugbtug ${snapshot.data[val - 1].idProducto}   - ${snapshot.data[val - 1].productoNombre}');

                      ProductosData productos = ProductosData();
                      productos.idProducto = snapshot.data[val - 1].idProducto;
                      productos.idCategoria =
                          snapshot.data[val - 1].idCategoria;
                      productos.productoNombre =
                          snapshot.data[val - 1].productoNombre;
                      productos.productoPrecio =
                          snapshot.data[val - 1].productoPrecio;

                      utils.agregarPropinaCarrito(productos, context, '1');
                    }

                    cantidad++;
                  });
                },
                choiceItems: C2Choice.listFrom<int, String>(
                  source: algo,
                  value: (i, v) {
                    return i;
                  },
                  label: (i, v) {
                    return v;
                  },
                  tooltip: (i, v) {
                    return v;
                  },
                ),
                choiceStyle: C2ChoiceStyle(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(5),
                  ),
                ),
                wrapped: true,
              );
            } else {
              return Container();
            }
          } else {
            return Container();
          }
        },
      ),
    );
  }
}
