

import 'package:enchiladasapp/src/api/categorias_api.dart';
import 'package:enchiladasapp/src/database/categorias_database.dart';
import 'package:enchiladasapp/src/models/categoria_model.dart'; 
import 'package:rxdart/rxdart.dart';

class CategoriasBloc{
  final categoriasApi = CategoriasApi();
  final categoriasDatabase = CategoriasDatabase();

  final _categoriasEnchiladasController = new BehaviorSubject<List<CategoriaData>>(); 
  final _categoriasPorTipoController = new BehaviorSubject<List<CategoriaData>>(); 
  final _categoriasPromocionesController = new BehaviorSubject<List<CategoriaData>>(); 
  final _cargandoCategoriasController  = BehaviorSubject<bool>();

  Stream<List<CategoriaData>> get categoriasEnchiladasStream => _categoriasEnchiladasController.stream;
  Stream<List<CategoriaData>> get categoriasPorTipoStream => _categoriasPorTipoController.stream;
  Stream<List<CategoriaData>> get categoriasPromociionesStream => _categoriasPromocionesController.stream;
  Stream<bool> get cargandoCategoriasStream => _cargandoCategoriasController.stream;

  dispose(){
    _categoriasEnchiladasController?.close(); 
    _categoriasPorTipoController?.close();
    _cargandoCategoriasController?.close();
    _categoriasPromocionesController?.close();
  }

  void cargandoCategoriasFalse(){
    _cargandoCategoriasController.sink.add(false);
  }


  void obtenerCategoriasEnchiladas()async{
    _cargandoCategoriasController.sink.add(true);
    _categoriasEnchiladasController.sink.add(await categoriasDatabase.obtenerCategoriasEnchiladas());
    /* await categoriasApi.obtenerAmbos();

     
   
    _categoriasEnchiladasController.sink.add(await categoriasDatabase.obtenerCategoriasEnchiladas()); 
     */_cargandoCategoriasController.sink.add(false);
  }



  void obtenerCategoriasLocalEnchiladas()async{
    _cargandoCategoriasController.sink.add(true);
    _categoriasEnchiladasController.sink.add(await categoriasDatabase.obtenerCategoriasLocalEnchiladas());
    /* await categoriasApi.obtenerAmbos();

     
   
    _categoriasEnchiladasController.sink.add(await categoriasDatabase.obtenerCategoriasEnchiladas()); 
     */_cargandoCategoriasController.sink.add(false);
  }

  void obtenerCategoriasPorTipo(String tipo)async{

    //tipo ==2 market
    //tipo ==3 cafe
    
    _cargandoCategoriasController.sink.add(true);
    _categoriasPorTipoController.sink.add(await categoriasDatabase.obtenerCategoriasPorTipo(tipo));
     
    /* _categoriasMarketController.sink.add(await categoriasApi.cargarCategorias());

    _categoriasMarketController.sink.add(await categoriasDatabase.obtenerCategoriasMarket()); */
    _cargandoCategoriasController.sink.add(false);
  }

  void obtenerCategoriasPromociones()async{
    _categoriasPromocionesController.sink.add(await categoriasDatabase.obtenerCategoriasPromociones());
  }

  
}