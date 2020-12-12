 
import 'package:enchiladasapp/src/database/producto_database.dart';
import 'package:enchiladasapp/src/models/productos_model.dart';
import 'package:rxdart/rxdart.dart';

class FavoritosBloc { 

  final productoDatabase = ProductoDatabase(); 
  final _productosFavoritosController = new BehaviorSubject<List<ProductosData>>(); 

  Stream<List<ProductosData>> get productosFavoritosStream => _productosFavoritosController.stream; 

  dispose(){
    _productosFavoritosController?.close(); 
  }


  void obtenerProductosFavoritos()async{
    _productosFavoritosController.sink.add(await productoDatabase.obtenerFavoritos()); 
  }
}