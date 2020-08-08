 

import 'package:enchiladasapp/src/models/carrito_model.dart';
import 'package:enchiladasapp/src/models/productos._model.dart';
import 'package:enchiladasapp/src/utils/responsive.dart';
import 'package:enchiladasapp/src/utils/utilidades.dart' as utils;
import 'package:flutter/material.dart';


class CantidadTab extends StatefulWidget {
  final Carrito  carrito;
  final Function llamada;

  CantidadTab({Key key,@required this.carrito,@required this.llamada}) : super(key: key);

  @override
  _CantidadTabState createState() => _CantidadTabState();
}

class _CantidadTabState extends State<CantidadTab> {

  int _counter = 1; 
  
  void _increase() {
    setState(() {
      _counter++;
      widget.llamada();
      
    });
  }

  void _decrease() {
    setState(() {
      _counter--;      
      widget.llamada();
    });
  }
  

  
  @override
  Widget build(BuildContext context) {

    final Responsive responsive = new Responsive.of(context);
    ProductosData productosData =ProductosData();
    productosData.idProducto =widget.carrito.idProducto.toString();
    productosData.productoNombre =widget.carrito.productoNombre;
    productosData.productoFoto =widget.carrito.productoFoto;
    productosData.productoPrecio =widget.carrito.productoPrecio;
    _counter =  int.parse(widget.carrito.productoCantidad);

    return _cantidad(responsive,productosData);
  }
  Widget _cantidad(Responsive responsive,ProductosData producto,) {
    final pad = responsive.hp(1);
    return Padding(
      padding: EdgeInsets.symmetric(vertical: pad),
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(color: Colors.red),
            borderRadius: BorderRadius.circular(8)),
        width: responsive.wp(20),
        height: responsive.hp(3.5),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Flexible(
              flex: 3,
              child: GestureDetector(
                onTap: (){
                  _decrease();
                  utils.agregarCarrito(producto, context, _counter.toString());

                },
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(5),
                          bottomLeft: Radius.circular(5))),
                  height: double.infinity,
                  child: Center(
                    child: Text("-",
                        style: TextStyle(
                            color: Colors.white, fontSize: responsive.ip(2.1))),
                  ),
                ),
              ),
            ),
            Flexible(
              flex: 3,
              child: Container(
                color: Colors.white,
                height: double.infinity,
                child: Center(
                  child: Text(_counter.toString(),
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: responsive.ip(2),
                      )),
                ),
              ),
            ),
            Flexible(
              flex: 3,
              child: GestureDetector(
                onTap: (){
                  _increase();
                  utils.agregarCarrito(producto, context, _counter.toString());

                },
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(5),
                          bottomRight: Radius.circular(5))),
                  height: double.infinity,
                  child: Center(
                    child: Text("+",
                        style: TextStyle(
                            color: Colors.white, fontSize: responsive.ip(2.1))),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

 
}