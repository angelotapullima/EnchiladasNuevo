

import 'package:enchiladasapp/src/api/categorias_api.dart';
import 'package:enchiladasapp/src/database/producto_database.dart';
import 'package:enchiladasapp/src/models/productos._model.dart';
import 'package:rxdart/rxdart.dart';

class ProductosBloc {
  final categoriasApi = CategoriasApi();
  final productoDatabase = ProductoDatabase();

  final _productosEnchiladasController = new BehaviorSubject<List<ProductosData>>(); 
  final _productosMarketController = new BehaviorSubject<List<ProductosData>>(); 
  final _productosIDController = new BehaviorSubject<List<ProductosData>>();
  final _productosQueryController = new BehaviorSubject<List<ProductosData>>();
  final _cargandoProductosController  = BehaviorSubject<bool>();

  Stream<List<ProductosData>> get productosEnchiladasStream => _productosEnchiladasController.stream; 
  Stream<List<ProductosData>> get productosMarketStream => _productosMarketController.stream; 
  Stream<List<ProductosData>> get productosIdStream => _productosIDController.stream;
  Stream<List<ProductosData>> get productosQueryStream => _productosQueryController.stream;
  Stream<bool> get cargandoProductosStream => _cargandoProductosController.stream;

  dispose(){
    _productosEnchiladasController?.close(); 
    _productosIDController?.close(); 
    _productosQueryController?.close(); 
    _cargandoProductosController?.close();
    _productosMarketController?.close();
  }

  void cargandoProductosFalse(){
    _cargandoProductosController.sink.add(false);
  }


  void obtenerProductosEnchiladasPorCategoria(String categoria)async{
    _cargandoProductosController.sink.add(true); 
    _productosEnchiladasController.sink.add(await productoDatabase.obtenerProductosPorCategoria('$categoria'));
     
    /* _productosEnchiladasController.sink.add(await categoriasApi.obtenerProductoCategoria('$categoria'));
    _productosEnchiladasController.sink.add(await productoDatabase.obtenerProductosPorCategoria('$categoria')); */
    _cargandoProductosController.sink.add(false);
  }

  void obtenerProductosMarketPorCategoria(String categoria)async{
    _cargandoProductosController.sink.add(true); 
    _productosMarketController.sink.add(await productoDatabase.obtenerProductosPorCategoria('$categoria'));
     
    /* _productosMarketController.sink.add(await categoriasApi.obtenerProductoCategoria('$categoria'));
    _productosMarketController.sink.add(await productoDatabase.obtenerProductosPorCategoria('$categoria')); */
    _cargandoProductosController.sink.add(false);
  }

  void obtenerProductoPorId(String id)async{
    _cargandoProductosController.sink.add(true); 
    _productosIDController.sink.add(await productoDatabase.consultarPorId('$id'));
    _cargandoProductosController.sink.add(false);
  }

  void obtenerProductoPorQuery(String query)async{ 
    _productosQueryController.sink.add(await productoDatabase.consultarPorQuery('$query')); 
  }

}