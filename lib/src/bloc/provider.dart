

import 'package:enchiladasapp/src/bloc/carrito_completo.dart';
import 'package:enchiladasapp/src/bloc/categoria_enchiladas_navi_bloc.dart';
import 'package:enchiladasapp/src/bloc/nuevo_metodo_pago.dart';
import 'package:enchiladasapp/src/bloc/pantalla_bloc.dart';
import 'package:enchiladasapp/src/bloc/zona_bloc.dart';
import 'package:flutter/material.dart';

import 'package:enchiladasapp/src/bloc/market_navigation_bloc.dart';
export 'package:enchiladasapp/src/bloc/market_navigation_bloc.dart';

import 'package:enchiladasapp/src/bloc/pedidos_asignados_bloc.dart';
export 'package:enchiladasapp/src/bloc/pedidos_asignados_bloc.dart';

import 'package:enchiladasapp/src/bloc/puzzle_bloc.dart';
export 'package:enchiladasapp/src/bloc/puzzle_bloc.dart';


import 'package:enchiladasapp/src/bloc/bottom_navigation_bloc.dart';
export 'package:enchiladasapp/src/bloc/bottom_navigation_bloc.dart';

import 'package:enchiladasapp/src/bloc/usuario_bloc.dart';
export 'package:enchiladasapp/src/bloc/usuario_bloc.dart';

import 'package:enchiladasapp/src/bloc/favoritos_bloc.dart';
export 'package:enchiladasapp/src/bloc/favoritos_bloc.dart';

import 'package:enchiladasapp/src/bloc/carrito_bloc.dart';
export 'package:enchiladasapp/src/bloc/carrito_bloc.dart';

import 'package:enchiladasapp/src/bloc/categorias_bloc.dart';
export 'package:enchiladasapp/src/bloc/categorias_bloc.dart';

import 'package:enchiladasapp/src/bloc/productos_id_bloc.dart';
export 'package:enchiladasapp/src/bloc/productos_id_bloc.dart';

import 'package:enchiladasapp/src/bloc/direccion_bloc.dart';
export 'package:enchiladasapp/src/bloc/direccion_bloc.dart';

import 'package:enchiladasapp/src/bloc/pedidos_bloc.dart';
export 'package:enchiladasapp/src/bloc/pedidos_bloc.dart';

import 'login_bloc.dart';
export 'login_bloc.dart';

class ProviderBloc extends InheritedWidget {
  final loginBloc = new LoginBloc();
  final categoriasBloc = new CategoriasBloc();
  final productosId = new ProductosBloc();
  final carritoBloc = new CarritoBloc();
  final favoritosBloc = new FavoritosBloc();
  final usuarioBloc = new UsuarioBloc();
  final direccionBloc = DireccionBloc();
  final bottomNaviBloc = BottomNaviBloc();
  final marketNaviBloc = MarketNaviBloc();
  final pedidosBloc = PedidoBloc();
  final pedidosAsignadosBloc = PedidosAsignadosBloc();
  final puzzleBloc = PuzzleBloc();
  final zonaBloc = ZonaBloc();
  final nuevoMetodoPagoBloc = NuevoMetodoPagoBloc();
  final carritoCompletoBloc = CarritoCompletoBloc();
  final pantallaBloc = PantallaBloc();
  final enchiladasNaviBloc =EnchiladasNaviBloc();

  static ProviderBloc _instancia;

  //generamos un Singleton de Provider para toda la aplicacion
  factory ProviderBloc({Key key, Widget child}) {
    if (_instancia == null) {
      _instancia = new ProviderBloc._internal(key: key, child: child);
    }

    return _instancia;
  }

  ProviderBloc._internal({Key key, Widget child})
      : super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  //Instanciamos LoginBloc para usarla en el provider del Bloc
  static LoginBloc of(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<ProviderBloc>())
        .loginBloc;
  }

  static CategoriasBloc cat(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<ProviderBloc>())
        .categoriasBloc;
  }

  static ProductosBloc prod(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<ProviderBloc>())
        .productosId;
  }

  static CarritoBloc carrito(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<ProviderBloc>())
        .carritoBloc;
  }

  static FavoritosBloc fav(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<ProviderBloc>())
        .favoritosBloc;
  }

  static UsuarioBloc user(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<ProviderBloc>())
        .usuarioBloc;
  }

  static DireccionBloc dire(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<ProviderBloc>())
        .direccionBloc;
  } 

   static BottomNaviBloc bottom(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<ProviderBloc>())
        .bottomNaviBloc;
  }

  static PedidoBloc pedido(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<ProviderBloc>())
        .pedidosBloc;
  }
  static PedidosAsignadosBloc asignados(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<ProviderBloc>())
        .pedidosAsignadosBloc;
  }
  static PuzzleBloc puzzle(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<ProviderBloc>())
        .puzzleBloc;
  }
  static ZonaBloc zona(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<ProviderBloc>())
        .zonaBloc;
  }
  static MarketNaviBloc market(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<ProviderBloc>())
        .marketNaviBloc;
  } 

  static NuevoMetodoPagoBloc npago(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<ProviderBloc>())
        .nuevoMetodoPagoBloc;
  }

  static CarritoCompletoBloc carritoCompleto(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<ProviderBloc>())
        .carritoCompletoBloc;
  }

  static PantallaBloc pantalla(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<ProviderBloc>())
        .pantallaBloc;
  }

  static EnchiladasNaviBloc enchiNavi(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<ProviderBloc>())
        .enchiladasNaviBloc;
  }
    
}
