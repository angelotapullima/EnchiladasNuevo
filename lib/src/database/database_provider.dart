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

    final path = join(documentsDirectory.path, 'enchilada.db');

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
          'id_direccion int  PRIMARY KEY,'
          'direccion VARCHAR,'
          'latitud VARCHAR,'
          'longitud VARCHAR,'
          'referencia VARCHAR' 
          ')');


      await db.execute('CREATE TABLE Categorias ('
          'id_categoria VARCHAR  PRIMARY KEY,'
          'categoria_nombre VARCHAR,'
          'categoria_cod VARCHAR,'
          'id_almacen VARCHAR,'
          'categoria_estado VARCHAR,'
          'categoria_tipo VARCHAR,'
          'categoria_mostrar_app VARCHAR'
          ')');

      await db.execute('CREATE TABLE Producto ('
          'id_producto VARCHAR  PRIMARY KEY,'
          'id_categoria VARCHAR,' 
          'producto_nombre VARCHAR,'
          'producto_foto VARCHAR,'
          'producto_precio VARCHAR,'
          'producto_unidad VARCHAR,'
          'producto_estado VARCHAR,'
          'producto_favorito int'
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
          'pedido_hora VARCHAR'
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
          'id_producto VARCHAR,'
          'zona_descripcion VARCHAR'
          ')');

          await db.execute('CREATE TABLE DeliveryRapido ('
          'id_delivery VARCHAR PRIMARY KEY,'
          'id_producto VARCHAR'
          ')');

           
    });
  }

  

  

  
}
