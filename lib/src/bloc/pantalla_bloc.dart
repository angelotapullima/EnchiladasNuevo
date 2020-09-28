

import 'package:enchiladasapp/src/database/categorias_database.dart';
import 'package:enchiladasapp/src/database/pantalla_database.dart';
import 'package:enchiladasapp/src/database/producto_database.dart';
import 'package:enchiladasapp/src/database/puzzle_database.dart';
import 'package:enchiladasapp/src/models/pantalla_model.dart';
import 'package:rxdart/subjects.dart';

class PantallaBloc{


   final pantallaDatabase =PantallaDatabase();
   final categoriasDatabase  =CategoriasDatabase();
   final puzzleDatabase = PuzzleDatabase();
   final productosDatabase =  ProductoDatabase();

   
  final _pantallasController = new BehaviorSubject<List<PantallaModel>>();

  Stream<List<PantallaModel>> get pantallasStream => _pantallasController.stream; 
 

  dispose() {
    _pantallasController?.close(); 
  }

  void obtenerPantallas( )async{ 

    var listFinal = List<PantallaModel>();
    final listPantallas = await pantallaDatabase.obtenerPantallas();

    for(int i  = 0;i<listPantallas.length;i++){
      var listItemPantalla = List<ItemPantalla>();

      PantallaModel pantalla = PantallaModel();

      pantalla.idPantalla = listPantallas[i].idPantalla;  
      pantalla.pantallaNombre = listPantallas[i].pantallaNombre;  
      pantalla.pantallaOrden =  listPantallas[i].pantallaOrden;  
      pantalla.pantallaFoto = listPantallas[i].pantallaFoto;  
      pantalla.pantallaEstado = listPantallas[i].pantallaEstado;  
      pantalla.pantallCategoria = listPantallas[i].pantallCategoria;  

      if(pantalla.idPantalla == '1'){

        //Categorias

        final listaCategorias =  await categoriasDatabase.obtenerCategoriasEnchiladas();

        for(int x = 0 ; x<listaCategorias.length;x++){
          ItemPantalla item = ItemPantalla();

          item.id = listaCategorias[x].idCategoria;
          item.nombreItem = listaCategorias[x].categoriaNombre;
          item.fotoItem = listaCategorias[x].categoriaFoto;

          listItemPantalla.add(item);


        }


      }else if(pantalla.idPantalla == '2'){
        //market

        final listaCategorias =  await categoriasDatabase.obtenerCategoriasMarket();

        for(int x = 0 ; x<listaCategorias.length;x++){
          ItemPantalla item = ItemPantalla();

          item.id = listaCategorias[x].idCategoria;
          item.nombreItem = listaCategorias[x].categoriaNombre;
          item.fotoItem = listaCategorias[x].categoriaFoto;

          listItemPantalla.add(item);


        }


      } else if(pantalla.idPantalla == '3'){
        //puzzle

        final listaPuzzle =  await puzzleDatabase.obtenerPuzzle();//puzzle.obtenerCategoriasTodos();

        for(int x = 0 ; x<listaPuzzle.length;x++){
          ItemPantalla item = ItemPantalla();

          item.nombreItem = listaPuzzle[x].imagenInicio;
          item.fotoItem = listaPuzzle[x].imagenRuta;

          listItemPantalla.add(item);


        }
        
      }else {

        //resto

        final listaProductos =  await productosDatabase.obtenerProductosPorCategoria(pantalla.pantallCategoria);

        for(int x = 0 ; x<listaProductos.length;x++){
          ItemPantalla item = ItemPantalla();

          item.id = listaProductos[x].idProducto;
          item.nombreItem = listaProductos[x].productoNombre;
          item.fotoItem = listaProductos[x].productoFoto;

          listItemPantalla.add(item);


        }
        
      }
      pantalla.items = listItemPantalla;

      listFinal.add(pantalla);

      
    }
   
    _pantallasController.sink.add(listFinal); 
  }

  

}