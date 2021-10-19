import 'package:enchiladasapp/src/api/categorias_api.dart';
import 'package:enchiladasapp/src/database/categorias_database.dart';
import 'package:enchiladasapp/src/models/categoria_model.dart';
import 'package:enchiladasapp/src/models/tipo_model.dart';
import 'package:rxdart/rxdart.dart';

class CategoriasBloc {
  final categoriasApi = CategoriasApi();
  final categoriasDatabase = CategoriasDatabase();

  final _categoriasTipoController = new BehaviorSubject<List<TipoModel>>();
  final _categoriasEnchiladasController = new BehaviorSubject<List<CategoriaData>>();
  final _categoriasPorTipoController = new BehaviorSubject<List<CategoriaData>>();
  final _categoriasPromocionesController = new BehaviorSubject<List<CategoriaData>>();
  final _cargandoCategoriasController = BehaviorSubject<bool>();

  Stream<List<CategoriaData>> get categoriasEnchiladasStream => _categoriasEnchiladasController.stream;
  Stream<List<TipoModel>> get categoriaTipo => _categoriasTipoController.stream;
  Stream<List<CategoriaData>> get categoriasPorTipoStream => _categoriasPorTipoController.stream;
  Stream<List<CategoriaData>> get categoriasPromociionesStream => _categoriasPromocionesController.stream;
  Stream<bool> get cargandoCategoriasStream => _cargandoCategoriasController.stream;

  dispose() {
    _categoriasEnchiladasController?.close();
    _categoriasPorTipoController?.close();
    _cargandoCategoriasController?.close();
    _categoriasPromocionesController?.close();
    _categoriasTipoController?.close();
  }

  void cargandoCategoriasFalse() {
    _cargandoCategoriasController.sink.add(false);
  }

  void obtenerCategoriasEnchiladas2() async {
    _cargandoCategoriasController.sink.add(true);
    _categoriasEnchiladasController.sink.add(await categoriasDatabase.obtenerCategoriasEnchiladas());
    /* await categoriasApi.obtenerAmbos();

     
   
    _categoriasEnchiladasController.sink.add(await categoriasDatabase.obtenerCategoriasEnchiladas()); 
     */
    _cargandoCategoriasController.sink.add(false);
  }

  void obtenerCategoriasEnchiladas() async {
    _cargandoCategoriasController.sink.add(true);
    _categoriasEnchiladasController.sink.add(await categoriasDatabase.obtenerCategoriasLocalEnchiladas());
    /* await categoriasApi.obtenerAmbos();

     
   
    _categoriasEnchiladasController.sink.add(await categoriasDatabase.obtenerCategoriasEnchiladas()); 
     */
    _cargandoCategoriasController.sink.add(false);
  }

  void obtenerCategoriasPorTipo2(String tipo) async {
    //tipo ==2 market
    //tipo ==3 cafe

    _cargandoCategoriasController.sink.add(true);
    _categoriasPorTipoController.sink.add(await categoriasDatabase.obtenerCategoriasLocalEnchiladas());

    /* _categoriasMarketController.sink.add(await categoriasApi.cargarCategorias());

    _categoriasMarketController.sink.add(await categoriasDatabase.obtenerCategoriasMarket()); */
    _cargandoCategoriasController.sink.add(false);
  }

  void obtenerCategoriasPromociones() async {
    _categoriasPromocionesController.sink.add(await categoriasDatabase.obtenerCategoriasPromociones());
  }

  void obtenerCatOrdenado() async {
    final List<TipoModel> tipis = [];
    final List<String> listString = [];
    _cargandoCategoriasController.sink.add(true);
    //_categoriasEnchiladasController.sink.add(await categoriasDatabase.obtenerCategoriasLocalEnchiladas());
    final listGen = await categoriasDatabase.obtenerCategoriasLocalEnchiladas();

    if (listGen.length > 0) {
      for (var i = 0; i < listGen.length; i++) {
        listString.add(listGen[i].categoriaTipo);
      }

      List<String> algo = listString.toSet().toList();

      for (var x = 0; x < algo.length; x++) {
        final List<CategoriaData> listCate = [];

        TipoModel tipoModel = TipoModel();
        tipoModel.tipo = (algo[x] == '1')
            ? 'Restaurant'
            : (algo[x] == '3')
                ? 'Cafe 24/7'
                : 'Var 24/7';
        tipoModel.nombre = algo[x];
        for (var i = 0; i < listGen.length; i++) {
          if (algo[x] == listGen[i].categoriaTipo) {
            CategoriaData categoriaData = CategoriaData();

            categoriaData.idCategoria = listGen[i].idCategoria;
            categoriaData.categoriaNombre = listGen[i].categoriaNombre;
            categoriaData.categoriaIcono = listGen[i].categoriaIcono;
            categoriaData.categoriaTipo = listGen[i].categoriaTipo;
            categoriaData.categoriaFoto = listGen[i].categoriaFoto;
            categoriaData.categoriaBanner = listGen[i].categoriaBanner;
            categoriaData.categoriaPromocion = listGen[i].categoriaPromocion;
            categoriaData.categoriaSonido = listGen[i].categoriaSonido;
            categoriaData.categoriaEstado = listGen[i].categoriaEstado;
            categoriaData.categoriaMostrarApp = listGen[i].categoriaMostrarApp;
            categoriaData.categoriaOrden = listGen[i].categoriaOrden;

            listCate.add(categoriaData);
          }
        }
        tipoModel.cate = listCate;
        tipis.add(tipoModel);
      }
    }

    _categoriasTipoController.sink.add(tipis);
  }
}
