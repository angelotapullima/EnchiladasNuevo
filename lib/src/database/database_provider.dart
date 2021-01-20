import 'dart:io';
 
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseProvider {
  static Database _database;
  static final DatabaseProvider db = DatabaseProvider._();

  DatabaseProvider._();

  Future<Database> get database async {
    if (_database != null) return _database;

    _database = await initDB();


    return _database;
  }
 

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();

    final path = join(documentsDirectory.path, 'enchiladasbd4.db');

    return await openDatabase(path, version: 1, onOpen: (db) {},
        onConfigure: (Database db) async {
      await db.execute('PRAGMA foreign_keys = ON');
    }, onCreate: (Database db, int version) async {


      await db.execute('CREATE TABLE Usuario ('
          'c_u VARCHAR  PRIMARY KEY,'
          'idRel VARCHAR,'
          'nombre VARCHAR,'
          'email VARCHAR,'
          'foto VARCHAR,'
          'dni VARCHAR,' 
          'id_direccion int,' 
          'id_zona VARCHAR,'
          'token VARCHAR,'
          'telefono VARCHAR,'
          'c_p VARCHAR'
          ')');

        await db.execute('CREATE TABLE Direccion ('
          'id_direccion INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,'
          'id_zona int ,'
          'titulo VARCHAR ,'
          'direccion VARCHAR,'
          'latitud VARCHAR,'
          'longitud VARCHAR,'
          'seleccionado VARCHAR,'
          'referencia VARCHAR,' 
          'FOREIGN KEY (id_zona) references Zona(id_zona) ON DELETE NO ACTION ON UPDATE NO ACTION '
          ')');


      await db.execute('CREATE TABLE Categorias ('
          'id_categoria VARCHAR  PRIMARY KEY,'
          'categoria_nombre VARCHAR,'
          'categoria_estado VARCHAR,'
          'categoria_tipo VARCHAR,'
          'categoria_orden VARCHAR,'
          'categoria_promocion VARCHAR,'
          'categoria_sonido VARCHAR,'
          'categoria_foto VARCHAR,'
          'categoria_icono VARCHAR,'
          'categoria_banner VARCHAR,'
          'categoria_mostrar_app VARCHAR'
          ')');


        //producto_destacado =  muestra el estado desde la api
        //0 = cuando no es destacado
        //cualquier número si es destacado y es la posición
        //producto_estado_destacado es 1 si es destacado y 0 si no es destacado
        //producto_estado_destacado es interno

      await db.execute('CREATE TABLE Producto ('
          'id_producto VARCHAR  PRIMARY KEY,'
          'id_categoria VARCHAR,' 
          'producto_nombre VARCHAR,'
          'producto_foto VARCHAR,'
          'producto_orden VARCHAR,'
          'producto_precio VARCHAR,'
          'producto_carta VARCHAR,'
          'producto_delivery VARCHAR,'
          'producto_sonido VARCHAR,'
          'producto_unidad VARCHAR,'
          'producto_destacado VARCHAR,'
          'producto_estado_destacado VARCHAR,'
          'producto_tupper VARCHAR,' 
          'producto_estado VARCHAR,'
          'producto_nuevo VARCHAR,'
          'producto_descripcion VARCHAR,'
          'producto_comentario VARCHAR,' 
          'producto_cantidad_adicional VARCHAR,' 
          'producto_favorito int'
          ')');


          await db.execute('CREATE TABLE Adicionales ('
          'id_adicional  INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,'
          'id_producto VARCHAR,' 
          'id_producto_adicional VARCHAR,'
          'adicional_item VARCHAR,'
          'titulo VARCHAR,'
          'adicional_seleccionado VARCHAR'
          ')');

      await db.execute('CREATE TABLE DetallePedido ('
          'id_detalle_pedido VARCHAR  PRIMARY KEY,'
          'id_pedido VARCHAR,'
          'id_producto VARCHAR,'
          'detalle_cantidad VARCHAR,'
          'detalle_precio_unit VARCHAR,'
          'detalle_precio_total VARCHAR,'
          'detalle_observacion VARCHAR,' 
          'producto_nombre VARCHAR' 
          ')');

      await db.execute('CREATE TABLE Pedido ('
          'id_pedido VARCHAR  PRIMARY KEY,'
          'pedido_tipo_comprobante VARCHAR,'
          'pedido_cod_persona VARCHAR,'
          'pedido_total VARCHAR,'
          'pedido_dni VARCHAR,'
          'pedido_nombre VARCHAR,'
          'pedido_telefono VARCHAR,'
          'pedido_direccion VARCHAR,'
          'pedido_referencia VARCHAR,'
          'pedido_forma_pago VARCHAR,'
          'pedido_monto_pago VARCHAR,'
          'pedido_vuelto_pago VARCHAR,'
          'pedido_estado_pago VARCHAR,'
          'pedido_estado VARCHAR,'
          'pedido_codigo VARCHAR,'
          'pedido_fecha VARCHAR,'
          'pedido_pago_link VARCHAR,'
          'pedido_hora VARCHAR'
          ')');

      await db.execute('CREATE TABLE PedidoAsignado ('
          'id_pedido VARCHAR  PRIMARY KEY,'
          'id_entrega VARCHAR ,'
          'pedido_tipo_comprobante VARCHAR,'
          'pedido_cod_persona VARCHAR,'
          'pedido_fecha VARCHAR,'
          'pedido_hora VARCHAR,'
          'pedido_total VARCHAR,'
          'pedido_telefono VARCHAR,'
          'pedido_dni VARCHAR,'
          'pedido_nombre VARCHAR,'
          'pedido_direccion VARCHAR,'
          'pedido_referencia VARCHAR,'
          'pedido_forma_pago VARCHAR,'
          'pedido_monto_pago VARCHAR,'
          'pedido_vuelto_pago VARCHAR,'
          'pedido_estado_pago VARCHAR,'
          'pedido_estado VARCHAR,'
          'pedido_codigo VARCHAR'
          ')'); 


      await db.execute('CREATE TABLE DetallePedidoAsignado ('
          'id_detalle_pedido VARCHAR  PRIMARY KEY,'
          'id_pedido VARCHAR,'
          'id_producto VARCHAR,'
          'detalle_cantidad VARCHAR,'
          'detalle_precio_unit VARCHAR,'
          'detalle_precio_total VARCHAR,'
          'detalle_observacion VARCHAR,' 
          'producto_nombre VARCHAR' 
          ')');

      

      await db.execute('CREATE TABLE DeliveryRapido ('
          'idDelivery VARCHAR PRIMARY KEY,'
          'estado VARCHAR' 
          ')');
      //producto producto_tipo => 0 = productos normales || 
      //producto_tipo => 1= DeliveryRapido
      //producto_tipo => 2= zonaPedido
      //esto pasa por que el delivery rapido y las zonas tambien son productos y no debo mostrarlos
      await db.execute('CREATE TABLE Carrito ('
          'id_producto INTEGER PRIMARY KEY,'
          'producto_nombre VARCHAR,'
          'producto_foto VARCHAR,'
          'producto_cantidad VARCHAR,'
          'producto_precio VARCHAR,'
          'producto_tipo VARCHAR,'
          'producto_tupper VARCHAR,'
          'idCategoria VARCHAR,'
          'producto_observacion VARCHAR'
          ')');

           await db.execute('CREATE TABLE Ranking ('
          'id_puzzle VARCHAR PRIMARY KEY,'
          'nombre VARCHAR,' 
          'tiempo VARCHAR,'
          'foto VARCHAR,' 
          'fecha VARCHAR'
          ')');

      await db.execute('CREATE TABLE Zona ('
          'id_zona VARCHAR PRIMARY KEY,'
          'zona_nombre VARCHAR,'
          'zona_pedido_minimo VARCHAR,'
          'zona_imagen VARCHAR,'
          'zona_tiempo VARCHAR,'
          'recargo_producto_nombre VARCHAR,'
          'recargo_producto_precio VARCHAR,'
          'delivery_producto_nombre VARCHAR,'
          'delivery_producto_precio VARCHAR,'
          'zona_descripcion VARCHAR'
          ')');

           await db.execute('CREATE TABLE Puzzle ('
          'id_imagen VARCHAR PRIMARY KEY,'
          'imagen_ruta VARCHAR,' 
          'imagen_titulo VARCHAR,'
          'imagen_subida VARCHAR,'
          'imagen_inicio VARCHAR,'
          'imagen_fin VARCHAR,'
          'imagen_estado VARCHAR'
          ')'); 

          await db.execute('CREATE TABLE Temporizador ('
          'idTemporizador VARCHAR PRIMARY KEY,'
          'temporizador_tipo VARCHAR,' 
          'temporizador_fechainicio VARCHAR,'
          'temporizador_fechafin VARCHAR,'
          'temporizador_horainicio VARCHAR,'
          'temporizador_horafin VARCHAR,'
          'temporizador_mensaje VARCHAR,'
          'temporizador_lunes VARCHAR,'
          'temporizador_martes VARCHAR,'
          'temporizador_miercoles VARCHAR,'
          'temporizador_jueves VARCHAR,'
          'temporizador_viernes VARCHAR,'
          'temporizador_sabado VARCHAR,'
          'temporizador_domingo VARCHAR'
          ')'); 


          await db.execute('CREATE TABLE Pantalla ('
          'id_pantalla VARCHAR PRIMARY KEY,'
          'pantalla_nombre VARCHAR,' 
          'pantalla_orden VARCHAR,'
          'pantalla_foto VARCHAR,'
          'pantalla_estado VARCHAR,'
          'pantalla_categorias VARCHAR'
          ')'); 



           await db.execute('CREATE TABLE ObservacionesFijas ('
          'idObservacionesFijas INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,'
          'idProducto VARCHAR,' 
          'mostrar VARCHAR'
          ')'); 

          await db.execute('CREATE TABLE ProductosFijos ('
          'idProductosFijos INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,'
          'idProducto VARCHAR,' 
          'nombreProducto VARCHAR,' 
          'idRelacionado VARCHAR'
          ')');


          await db.execute('CREATE TABLE Sabores ('
          'idTextosFijos INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,'
          'idProducto VARCHAR,' 
          'maximo VARCHAR,' 
          'tituloTextos VARCHAR'
          ')'); 

           await db.execute('CREATE TABLE OpcionesSabores ('
          'idOpcionesTextosFijos INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,'
          'idProducto VARCHAR,' 
          'tituloTextos VARCHAR,'
          'nombreTexto VARCHAR'
          ')'); 


          
           await db.execute('CREATE TABLE Acompanhamientos ('
          'idTextosFijos INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,'
          'idProducto VARCHAR,' 
          'tituloTextos VARCHAR'
          ')'); 

           await db.execute('CREATE TABLE OpcionesAcompanhamientos ('
          'idOpcionesTextosFijos INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,'
          'idProducto VARCHAR,' 
          'tituloTextos VARCHAR,'
          'nombreTexto VARCHAR'
          ')'); 



          await db.execute('CREATE TABLE ObservacionesVariables ('
          'idObservacionesVariables INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,'
          'idProducto VARCHAR,' 
          'nombreVariable VARCHAR'
          ')'); 


          await db.execute('CREATE TABLE ItemObservacion ('
          'id_producto VARCHAR PRIMARY KEY,'
          'id_categoria VARCHAR,' 
          'producto_nombre VARCHAR,'
          'producto_foto VARCHAR,'
          'producto_precio VARCHAR,'
          'producto_tupper VARCHAR,'
          'producto_tipo VARCHAR,'
          'producto_observacion VARCHAR'
          ')');

          await db.execute('CREATE TABLE Publicidad ('
          'publicidad_id VARCHAR PRIMARY KEY,'
          'publicidad_imagen VARCHAR,' 
          'publicidad_estado VARCHAR,'
          'publicidad_tipo VARCHAR,'
          'id_relacionado VARCHAR'
          ')');




          await db.execute('CREATE TABLE EspecialesA ('
          'idTextosFijosA INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,'
          'idProducto VARCHAR,' 
          'maximo VARCHAR,' 
          'tituloTextos VARCHAR'
          ')'); 

           await db.execute('CREATE TABLE OpcionesEspecialesA ('
          'idOpcionesTextosFijosA INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,'
          'idProducto VARCHAR,' 
          'tituloTextos VARCHAR,'
          'nombreTexto VARCHAR'
          ')'); 


          await db.execute('CREATE TABLE EspecialesB ('
          'idTextosFijosB INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,'
          'idProducto VARCHAR,' 
          'maximo VARCHAR,' 
          'tituloTextos VARCHAR'
          ')'); 

           await db.execute('CREATE TABLE OpcionesEspecialesB ('
          'idOpcionesTextosFijosB INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,'
          'idProducto VARCHAR,' 
          'tituloTextos VARCHAR,'
          'nombreTexto VARCHAR'
          ')'); 


          await db.execute('CREATE TABLE EspecialesC ('
          'idTextosFijosC INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,'
          'idProducto VARCHAR,' 
          'maximo VARCHAR,' 
          'tituloTextos VARCHAR'
          ')'); 

           await db.execute('CREATE TABLE OpcionesEspecialesC ('
          'idOpcionesTextosFijosC INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,'
          'idProducto VARCHAR,' 
          'tituloTextos VARCHAR,'
          'nombreTexto VARCHAR'
          ')'); 



          await db.execute('CREATE TABLE EspecialesD ('
          'idTextosFijosD INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,'
          'idProducto VARCHAR,' 
          'maximo VARCHAR,' 
          'tituloTextos VARCHAR'
          ')'); 

           await db.execute('CREATE TABLE OpcionesEspecialesD ('
          'idOpcionesTextosFijosD INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,'
          'idProducto VARCHAR,' 
          'tituloTextos VARCHAR,'
          'nombreTexto VARCHAR'
          ')'); 
       
       




    });
  }

  

  

  
}
