import 'package:enchiladasapp/src/api/categorias_api.dart';
import 'package:enchiladasapp/src/database/categorias_database.dart';
import 'package:enchiladasapp/src/models/categoria_model.dart';
import 'package:rxdart/rxdart.dart';

class CategoriasBloc {
  final categoriasApi = CategoriasApi();
  final categoriasDatabase = CategoriasDatabase();

  final _categoriasPantallaInicialController = new BehaviorSubject<List<CategoriaData>>();
  final _categoriasPromocionesController = new BehaviorSubject<List<CategoriaData>>();
  final _cargandoCategoriasController = BehaviorSubject<bool>();

  // estos controladores se usaran en la vista de categorias
  //En delivery
  //Restaurant  = 5
  //Cafe  = 6
  //var  = 7
  //En el Local
  //Restaurant  = 1
  //Cafe  = 3
  //var  = 4
  final _categoriasRestaurantController = new BehaviorSubject<List<CategoriaData>>();
  final _categoriasCafeController = new BehaviorSubject<List<CategoriaData>>();
  final _categoriasVarController = new BehaviorSubject<List<CategoriaData>>();

  Stream<List<CategoriaData>> get categoriasPantallaInicialStream => _categoriasPantallaInicialController.stream;
  Stream<List<CategoriaData>> get categoriasPromociionesStream => _categoriasPromocionesController.stream;
  Stream<bool> get cargandoCategoriasStream => _cargandoCategoriasController.stream;

  Stream<List<CategoriaData>> get categoriasRestaurantStream => _categoriasRestaurantController.stream;
  Stream<List<CategoriaData>> get categoriasCafeStream => _categoriasCafeController.stream;
  Stream<List<CategoriaData>> get categoriasVarStream => _categoriasVarController.stream;

  dispose() {
    _categoriasPantallaInicialController?.close();
    _categoriasRestaurantController?.close();
    _categoriasCafeController?.close();
    _categoriasVarController?.close();
    _cargandoCategoriasController?.close();
    _categoriasPromocionesController?.close();
  }

  void cargandoCategoriasFalse() {
    _cargandoCategoriasController.sink.add(false);
  }

  //Se usara para los categorias con tipo desplegadas
  void obtenerCategoriasPorTipo(String tipo) async {
    print('$tipo');
    _cargandoCategoriasController.sink.add(true);
    _categoriasPantallaInicialController.sink.add(await categoriasDatabase.obtenerCategoriasPorTipo(tipo));

    _cargandoCategoriasController.sink.add(false);
  }

  void obtenerCategoriasPorTipoUnidos(String tipo) async {
    print('$tipo');
    _cargandoCategoriasController.sink.add(true);
    _categoriasPantallaInicialController.sink.add(await categoriasDatabase.obtenerCategoriasPorTipoUnidos(tipo));

    _cargandoCategoriasController.sink.add(false);
  }
  //////////////////////////////////

  //Se usara para los categorias con tipo desplegadas
  void obtenerCategoriasPromociones(String tipo) async {
    _categoriasPromocionesController.sink.add(await categoriasDatabase.obtenerCategoriasPromociones(tipo));
  }

  //Se usara para los categorias con tipo desplegadas
  void obtenerCategoriasPromocionesUnidas(String tipo) async {
    _categoriasPromocionesController.sink.add(await categoriasDatabase.obtenerCategoriasPromocionesUnidas(tipo));
  }

  void obtenerCategoriasRestaurant(String tipo) async {
    print('$tipo');
    _cargandoCategoriasController.sink.add(true);
    _categoriasRestaurantController.sink.add(await categoriasDatabase.obtenerCategoriasPorTipo(tipo));

    _cargandoCategoriasController.sink.add(false);
  }

  void obtenerCategoriasCafe(String tipo) async {
    print('$tipo');
    _cargandoCategoriasController.sink.add(true);
    _categoriasCafeController.sink.add(await categoriasDatabase.obtenerCategoriasPorTipo(tipo));

    _cargandoCategoriasController.sink.add(false);
  }

  void obtenerCategoriasVar(String tipo) async {
    print('$tipo');
    _cargandoCategoriasController.sink.add(true);
    _categoriasVarController.sink.add(await categoriasDatabase.obtenerCategoriasPorTipo(tipo));

    _cargandoCategoriasController.sink.add(false);
  }
}
