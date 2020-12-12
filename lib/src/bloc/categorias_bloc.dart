

import 'package:enchiladasapp/src/api/categorias_api.dart';
import 'package:enchiladasapp/src/database/categorias_database.dart';
import 'package:enchiladasapp/src/models/categoria_model.dart'; 
import 'package:rxdart/rxdart.dart';

class CategoriasBloc{
  final categoriasApi = CategoriasApi();
  final categoriasDatabase = CategoriasDatabase();

  final _categoriasEnchiladasController = new BehaviorSubject<List<CategoriaData>>(); 
  final _categoriasMarketController = new BehaviorSubject<List<CategoriaData>>(); 
  final _categoriasPromocionesController = new BehaviorSubject<List<CategoriaData>>(); 
  final _cargandoCategoriasController  = BehaviorSubject<bool>();

  Stream<List<CategoriaData>> get categoriasEnchiladasStream => _categoriasEnchiladasController.stream;
  Stream<List<CategoriaData>> get categoriasMarketStream => _categoriasMarketController.stream;
  Stream<List<CategoriaData>> get categoriasPromociionesStream => _categoriasPromocionesController.stream;
  Stream<bool> get cargandoCategoriasStream => _cargandoCategoriasController.stream;

  dispose(){
    _categoriasEnchiladasController?.close(); 
    _categoriasMarketController?.close();
    _cargandoCategoriasController?.close();
    _categoriasPromocionesController?.close();
  }

  void cargandoCategoriasFalse(){
    _cargandoCategoriasController.sink.add(false);
  }


  void obtenerCategoriasEnchiladas()async{
    _cargandoCategoriasController.sink.add(true);
    _categoriasEnchiladasController.sink.add(await categoriasDatabase.obtenerCategoriasEnchiladas());
    await categoriasApi.obtenerAmbos();

     
   /*  
    _categoriasEnchiladasController.sink.add(await categoriasDatabase.obtenerCategoriasEnchiladas()); */
    _cargandoCategoriasController.sink.add(false);
  }

  void obtenerCategoriasMarket()async{
    _cargandoCategoriasController.sink.add(true);
    _categoriasMarketController.sink.add(await categoriasDatabase.obtenerCategoriasMarket());
     
    /* _categoriasMarketController.sink.add(await categoriasApi.cargarCategorias());

    _categoriasMarketController.sink.add(await categoriasDatabase.obtenerCategoriasMarket()); */
    _cargandoCategoriasController.sink.add(false);
  }

  void obtenerCategoriasPromociones()async{
    _categoriasPromocionesController.sink.add(await categoriasDatabase.obtenerCategoriasPromociones());
  }

  
}