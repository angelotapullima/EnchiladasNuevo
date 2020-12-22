import 'package:enchiladasapp/src/bloc/provider.dart';
import 'package:enchiladasapp/src/models/productos_model.dart';
import 'package:enchiladasapp/src/utils/responsive.dart';
import 'package:enchiladasapp/src/utils/utilidades.dart';
import 'package:flutter/material.dart';

class PropinaPage extends StatelessWidget {
  const PropinaPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final propinasBloc = ProviderBloc.propina(context);
    propinasBloc.obtenerPropinas();

    final responsive = Responsive.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Selecciona Propina'),
      ),
      body: StreamBuilder(
        stream: propinasBloc.propinasStream,
        builder: (BuildContext context,
            AsyncSnapshot<List<ProductosData>> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.length > 0) {
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      GestureDetector(
                        onTap: (){
/* 
                          
                          final carritoBloc = ProviderBloc.carrito(context);
                          final carritoCompletoBloc = ProviderBloc.carritoCompleto(context);
                          */ 
                          ProductosData productos = ProductosData();
                          productos.idProducto = snapshot.data[index].idProducto;
                          productos.idCategoria = snapshot.data[index].idCategoria;
                          productos.productoNombre = snapshot.data[index].productoNombre;
                          productos.productoPrecio = snapshot.data[index].productoPrecio;
                          
                          agregarCarrito(productos,context,'1');
                         /*  carritoBloc.obtenerCarrito();
                          carritoCompletoBloc.obtenerCarritoCpmpleto(); */

                          Navigator.pop(context);
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: responsive.wp(5),
                            vertical: responsive.wp(1),
                          ),
                          child: Row(
                            children: [
                              Text(
                                '${snapshot.data[index].productoNombre}     ',
                                style: TextStyle(
                                    fontSize: responsive.ip(1.8),
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                'S/.${snapshot.data[index].productoPrecio}',
                                style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Divider()
                    ],
                  );
                },
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
