import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:enchiladasapp/src/bloc/provider.dart';
import 'package:enchiladasapp/src/models/productos_model.dart';
import 'package:enchiladasapp/src/pages/detalle_producto2.dart';
import 'package:enchiladasapp/src/utils/preferencias_usuario.dart';
import 'package:enchiladasapp/src/utils/responsive.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> with TickerProviderStateMixin {
  TabController _controller;

  TextEditingController _controllerBusquedaProducto = TextEditingController();
  final _currentPageNotifier = ValueNotifier<bool>(false);
  int igual = 0;
  int csmare = 0;

  @override
  void dispose() {
    _controllerBusquedaProducto.dispose();
    _controller.dispose();
    super.dispose();
  }


  @override
  void initState() {
    _controller = new TabController(vsync: this, length: 6);
    _controller.addListener(() {
      csmare = _controller.index;
      print('dentro ${_controller.index}');
      setState(() {});
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final productosBloc = ProviderBloc.busquedaAngelo(context);
      productosBloc.queryEnchiladas('', '');
      productosBloc.queryCafe('', '');
      productosBloc.queryVar('', '');
      productosBloc.queryEnchiladasDelivery('', '');
      productosBloc.queryCafeDelivery('', '');
      productosBloc.queryVarDelivery('', '');
    });
    print('initState');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);
    final preferences = Preferences();
    final productosBloc = ProviderBloc.busquedaAngelo(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,
        toolbarHeight: responsive.hp(8),
        centerTitle: false,
        backgroundColor: Color(0xFFF0EFEF),
        flexibleSpace: SafeArea(
          child: Container(
            margin: EdgeInsets.only(
              left: responsive.wp(10),
              bottom: responsive.hp(1),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                      toolbarOptions: ToolbarOptions(paste: true, cut: true, copy: true, selectAll: true),
                      controller: _controllerBusquedaProducto,
                      keyboardType: TextInputType.text,
                      textAlign: TextAlign.start,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        labelStyle: TextStyle(color: Colors.white),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        hintText: '¿Qué esta buscando?',
                        hintStyle: TextStyle(color: Colors.black45),
                      ),
                      /*  decoration: InputDecoration(
                      hintText: '¿Qué esta buscando?',
                      border: InputBorder.none,
                      hintStyle: TextStyle(color: Colors.black45),
                      contentPadding: EdgeInsets.symmetric(
                        vertical: responsive.hp(.2),
                      ),
                    ), */
                      onChanged: (value) {
                        print('valor de tal coaa $value');
                        if (value.length >= 0 && value != ' ' && value != '') {
                          igual++;
                          _currentPageNotifier.value = true;
                          productosBloc.queryEnchiladas('$value', '1');
                          productosBloc.queryCafe('$value', '3');
                          productosBloc.queryVar('$value', '4');
                          productosBloc.queryEnchiladasDelivery('$value', '5');
                          productosBloc.queryCafeDelivery('$value', '6');
                          productosBloc.queryVarDelivery('$value', '7');
                          //agregarHistorial(context, value, 'pro');
                        } else {
                          productosBloc.resetearCantidades();
                        }
                      },
                      onSubmitted: (value) {
                        if (value.length >= 0 && value != ' ' && value != '') {
                          igual++;
                          _currentPageNotifier.value = true;
                          productosBloc.queryEnchiladas('$value', '1');
                          productosBloc.queryCafe('$value', '3');
                          productosBloc.queryVar('$value', '4');
                          productosBloc.queryEnchiladasDelivery('$value', '5');
                          productosBloc.queryCafeDelivery('$value', '6');
                          productosBloc.queryVarDelivery('$value', '7');
                          //agregarHistorial(context, value, 'pro');
                        } else {
                          productosBloc.resetearCantidades();
                        }
                      }),
                ),
                SizedBox(
                  width: responsive.wp(1),
                ),
                ValueListenableBuilder(
                  valueListenable: _currentPageNotifier,
                  builder: (BuildContext context, bool data, Widget child) {
                    return (data)
                        ? InkWell(
                            onTap: () {
                              igual++;

                              productosBloc.resetearCantidades();
                              _controllerBusquedaProducto.text = '';
                              //setState(() {});
                            },
                            child: CircleAvatar(
                              backgroundColor: Colors.grey,
                              radius: responsive.ip(1.5),
                              child: Icon(
                                Icons.close,
                                color: Colors.white,
                                size: responsive.ip(2),
                              ),
                            ),
                          )
                        : Container();
                  },
                ),
                SizedBox(
                  width: responsive.wp(1),
                ),
              ],
            ),
          ),
        ),
      ),
      body: DefaultTabController(
        length: 6,
        child: Column(
          children: [
            SizedBox(
              height: responsive.hp(1),
            ),
            (preferences.tipoCategoriaNumero == '3')
                ? ButtonsTabBar(
                    controller: _controller,
                    height: responsive.hp(8),
                    physics: BouncingScrollPhysics(),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.red,
                          width: 1.5,
                        ),
                      ),
                    ),
                    onTap: (valor) {
                      _controller.index = valor;
                      //setState(() {_controller.index = valor;});
                    },
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: responsive.wp(3),
                    ),
                    unselectedBackgroundColor: Colors.transparent,
                    unselectedLabelStyle: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'MADE-TOMMY',
                      fontSize: responsive.ip(1.6),
                    ),
                    labelStyle: TextStyle(
                      color: Colors.red,
                      fontFamily: 'MADE-TOMMY',
                      fontWeight: FontWeight.bold,
                      fontSize: responsive.ip(1.6),
                    ),
                    tabs: [
                      // Cafe 24/7
                      Tab(
                        child: StreamBuilder(
                            stream: productosBloc.cantidadCafeStream,
                            builder: (context, AsyncSnapshot<int> snapshot) {
                              if (snapshot.hasData) {
                                if (snapshot.data == 20000) {
                                  return (csmare == 0)
                                      ? Text(
                                          'Cafe 24/7',
                                          style: TextStyle(color: Colors.red),
                                        )
                                      : Text('Cafe 24/7', style: TextStyle(color: Colors.black));
                                } else {
                                  return Row(
                                    children: [
                                      (csmare == 0)
                                          ? Text(
                                              'Cafe 24/7',
                                              style: TextStyle(color: Colors.red),
                                            )
                                          : Text('Cafe 24/7', style: TextStyle(color: Colors.black)),
                                      SizedBox(width: responsive.wp(2)),
                                      CircleAvatar(
                                        radius: responsive.ip(1.23),
                                        backgroundColor: Colors.red,
                                        child: Text(
                                          '${snapshot.data}',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: responsive.ip(1.1),
                                          ),
                                        ),
                                      )
                                    ],
                                  );
                                }
                              } else {
                                return (csmare == 0)
                                    ? Text(
                                        'Cafe 24/7',
                                        style: TextStyle(color: Colors.red),
                                      )
                                    : Text('Cafe 24/7', style: TextStyle(color: Colors.black));
                              }
                            }),
                      ),

                      //Cafe 24/7 \n Delivery
                      Tab(
                        child: StreamBuilder(
                            stream: productosBloc.cantidadCafeDeliveryStream,
                            builder: (context, AsyncSnapshot<int> snapshot) {
                              if (snapshot.hasData) {
                                if (snapshot.data == 20000) {
                                  return (csmare == 1)
                                      ? Text(
                                          'Cafe 24/7 \n Delivery',
                                          style: TextStyle(color: Colors.red),
                                        )
                                      : Text('Cafe 24/7 \n Delivery', style: TextStyle(color: Colors.black));
                                } else {
                                  return Row(
                                    children: [
                                      (csmare == 1)
                                          ? Text(
                                              'Cafe 24/7 \n Delivery',
                                              style: TextStyle(color: Colors.red),
                                            )
                                          : Text('Cafe 24/7 \n Delivery', style: TextStyle(color: Colors.black)),
                                      SizedBox(width: responsive.wp(2)),
                                      CircleAvatar(
                                        radius: responsive.ip(1.23),
                                        backgroundColor: Colors.red,
                                        child: Text(
                                          '${snapshot.data}',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: responsive.ip(1.1),
                                          ),
                                        ),
                                      )
                                    ],
                                  );
                                }
                              } else {
                                return (csmare == 1)
                                    ? Text(
                                        'Cafe 24/7 \n Delivery',
                                        style: TextStyle(color: Colors.red),
                                      )
                                    : Text('Cafe 24/7 \n Delivery', style: TextStyle(color: Colors.black));
                              }
                            }),
                      ),

                      //Restaurant
                      Tab(
                        child: StreamBuilder(
                            stream: productosBloc.cantidadEnchiladasStream,
                            builder: (context, AsyncSnapshot<int> snapshot) {
                              if (snapshot.hasData) {
                                if (snapshot.data == 20000) {
                                  return (csmare == 2)
                                      ? Text(
                                          'Restaurant',
                                          style: TextStyle(color: Colors.red),
                                        )
                                      : Text('Restaurant', style: TextStyle(color: Colors.black));
                                } else {
                                  return Row(
                                    children: [
                                      (csmare == 2)
                                          ? Text('Restaurant',
                                              style: TextStyle(
                                                color: Colors.red,
                                              ))
                                          : Text('Restaurant', style: TextStyle(color: Colors.black)),
                                      SizedBox(width: responsive.wp(2)),
                                      CircleAvatar(
                                        radius: responsive.ip(1.23),
                                        backgroundColor: Colors.red,
                                        child: Text(
                                          '${snapshot.data}',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: responsive.ip(1.1),
                                          ),
                                        ),
                                      )
                                    ],
                                  );
                                }
                              } else {
                                return (csmare == 2)
                                    ? Text(
                                        'Restaurant',
                                        style: TextStyle(color: Colors.red),
                                      )
                                    : Text('Restaurant', style: TextStyle(color: Colors.black));
                              }
                            }),
                      ),
                      //Restaurant \n Delivery
                      Tab(
                        child: StreamBuilder(
                            stream: productosBloc.cantidadEnchiladasDeliveryStream,
                            builder: (context, AsyncSnapshot<int> snapshot) {
                              if (snapshot.hasData) {
                                if (snapshot.data == 20000) {
                                  return (csmare == 3)
                                      ? Text(
                                          'Restaurant \n Delivery',
                                          style: TextStyle(color: Colors.red),
                                        )
                                      : Text('Restaurant \n Delivery', style: TextStyle(color: Colors.black));
                                } else {
                                  return Row(
                                    children: [
                                      (csmare == 3)
                                          ? Text(
                                              'Restaurant \n Delivery',
                                              style: TextStyle(color: Colors.red),
                                            )
                                          : Text('Restaurant \n Delivery', style: TextStyle(color: Colors.black)),
                                      SizedBox(width: responsive.wp(2)),
                                      CircleAvatar(
                                        radius: responsive.ip(1.23),
                                        backgroundColor: Colors.red,
                                        child: Text(
                                          '${snapshot.data}',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: responsive.ip(1.1),
                                          ),
                                        ),
                                      )
                                    ],
                                  );
                                }
                              } else {
                                return (csmare == 3)
                                    ? Text(
                                        'Restaurant \n Delivery',
                                        style: TextStyle(color: Colors.red),
                                      )
                                    : Text('Restaurant \n Delivery', style: TextStyle(color: Colors.black));
                              }
                            }),
                      ),

                      //Var 24/7
                      Tab(
                        child: StreamBuilder(
                            stream: productosBloc.cantidadVarStream,
                            builder: (context, AsyncSnapshot<int> snapshot) {
                              if (snapshot.hasData) {
                                if (snapshot.data == 20000) {
                                  return (csmare == 4)
                                      ? Text(
                                          'Var 24/7',
                                          style: TextStyle(color: Colors.red),
                                        )
                                      : Text('Var 24/7', style: TextStyle(color: Colors.black));
                                } else {
                                  return Row(
                                    children: [
                                      (csmare == 4)
                                          ? Text(
                                              'Var 24/7',
                                              style: TextStyle(color: Colors.red),
                                            )
                                          : Text('Var 24/7', style: TextStyle(color: Colors.black)),
                                      SizedBox(width: responsive.wp(2)),
                                      CircleAvatar(
                                        radius: responsive.ip(1.23),
                                        backgroundColor: Colors.red,
                                        child: Text(
                                          '${snapshot.data}',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: responsive.ip(1.1),
                                          ),
                                        ),
                                      )
                                    ],
                                  );
                                }
                              } else {
                                return (csmare == 4)
                                    ? Text(
                                        'Var 24/7',
                                        style: TextStyle(color: Colors.red),
                                      )
                                    : Text('Var 24/7', style: TextStyle(color: Colors.black));
                              }
                            }),
                      ),

                      //Var 24/7 \n Delivery
                      Tab(
                        child: StreamBuilder(
                            stream: productosBloc.cantidadVarDeliveryStream,
                            builder: (context, AsyncSnapshot<int> snapshot) {
                              if (snapshot.hasData) {
                                if (snapshot.data == 20000) {
                                  return (csmare == 5)
                                      ? Text(
                                          'Var 24/7 \n Delivery',
                                          style: TextStyle(color: Colors.red),
                                        )
                                      : Text('Var 24/7 \n Delivery', style: TextStyle(color: Colors.black));
                                } else {
                                  return Row(
                                    children: [
                                      (csmare == 5)
                                          ? Text(
                                              'Var 24/7 \n Delivery',
                                              style: TextStyle(color: Colors.red),
                                            )
                                          : Text('Var 24/7 \n Delivery', style: TextStyle(color: Colors.black)),
                                      SizedBox(width: responsive.wp(2)),
                                      CircleAvatar(
                                        radius: responsive.ip(1.23),
                                        backgroundColor: Colors.red,
                                        child: Text(
                                          '${snapshot.data}',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: responsive.ip(1.1),
                                          ),
                                        ),
                                      )
                                    ],
                                  );
                                }
                              } else {
                                return (csmare == 5)
                                    ? Text(
                                        'Var 24/7 \n Delivery',
                                        style: TextStyle(color: Colors.red),
                                      )
                                    : Text('Var 24/7 \n Delivery', style: TextStyle(color: Colors.black));
                              }
                            }),
                      ),
                    ],
                  )
                : (preferences.tipoCategoriaNumero == '4')
                    ? ButtonsTabBar(
                        height: responsive.hp(8),
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          border: Border(
                            bottom: BorderSide(
                              color: Colors.red,
                              width: 1.5,
                            ),
                          ),
                        ),
                        onTap: (valor) {
                          _controller.index = valor;
                          //setState(() {_controller.index = valor;});
                        },
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: responsive.wp(3),
                        ),
                        unselectedBackgroundColor: Colors.transparent,
                        unselectedLabelStyle: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'MADE-TOMMY',
                          fontSize: responsive.ip(1.6),
                        ),
                        labelStyle: TextStyle(
                          color: Colors.red,
                          fontFamily: 'MADE-TOMMY',
                          fontWeight: FontWeight.bold,
                          fontSize: responsive.ip(1.6),
                        ),
                        tabs: [
                          //Var 24/7
                          Tab(
                            child: StreamBuilder(
                                stream: productosBloc.cantidadVarStream,
                                builder: (context, AsyncSnapshot<int> snapshot) {
                                  if (snapshot.hasData) {
                                    if (snapshot.data == 20000) {
                                      return (csmare == 0)
                                          ? Text(
                                              'Var 24/7',
                                              style: TextStyle(color: Colors.red),
                                            )
                                          : Text('Var 24/7', style: TextStyle(color: Colors.black));
                                    } else {
                                      return Row(
                                        children: [
                                          (csmare == 0)
                                              ? Text(
                                                  'Var 24/7',
                                                  style: TextStyle(color: Colors.red),
                                                )
                                              : Text('Var 24/7', style: TextStyle(color: Colors.black)),
                                          SizedBox(width: responsive.wp(2)),
                                          CircleAvatar(
                                            radius: responsive.ip(1.23),
                                            backgroundColor: Colors.red,
                                            child: Text(
                                              '${snapshot.data}',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: responsive.ip(1.1),
                                              ),
                                            ),
                                          )
                                        ],
                                      );
                                    }
                                  } else {
                                    return (csmare == 0)
                                        ? Text(
                                            'Var 24/7',
                                            style: TextStyle(color: Colors.red),
                                          )
                                        : Text('Var 24/7', style: TextStyle(color: Colors.black));
                                  }
                                }),
                          ),

                          //Var 24/7 \n Delivery
                          Tab(
                            child: StreamBuilder(
                                stream: productosBloc.cantidadVarDeliveryStream,
                                builder: (context, AsyncSnapshot<int> snapshot) {
                                  if (snapshot.hasData) {
                                    if (snapshot.data == 20000) {
                                      return (csmare == 1)
                                          ? Text(
                                              'Var 24/7 \n Delivery',
                                              style: TextStyle(color: Colors.red),
                                            )
                                          : Text('Var 24/7 \n Delivery', style: TextStyle(color: Colors.black));
                                    } else {
                                      return Row(
                                        children: [
                                          (csmare == 1)
                                              ? Text(
                                                  'Var 24/7 \n Delivery',
                                                  style: TextStyle(color: Colors.red),
                                                )
                                              : Text('Var 24/7 \n Delivery', style: TextStyle(color: Colors.black)),
                                          SizedBox(width: responsive.wp(2)),
                                          CircleAvatar(
                                            radius: responsive.ip(1.23),
                                            backgroundColor: Colors.red,
                                            child: Text(
                                              '${snapshot.data}',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: responsive.ip(1.1),
                                              ),
                                            ),
                                          )
                                        ],
                                      );
                                    }
                                  } else {
                                    return (csmare == 1)
                                        ? Text(
                                            'Var 24/7 \n Delivery',
                                            style: TextStyle(color: Colors.red),
                                          )
                                        : Text('Var 24/7 \n Delivery', style: TextStyle(color: Colors.black));
                                  }
                                }),
                          ),

                          //Restaurant
                          Tab(
                            child: StreamBuilder(
                                stream: productosBloc.cantidadEnchiladasStream,
                                builder: (context, AsyncSnapshot<int> snapshot) {
                                  if (snapshot.hasData) {
                                    if (snapshot.data == 20000) {
                                      return (csmare == 2)
                                          ? Text(
                                              'Restaurant',
                                              style: TextStyle(color: Colors.red),
                                            )
                                          : Text('Restaurant', style: TextStyle(color: Colors.black));
                                    } else {
                                      return Row(
                                        children: [
                                          (csmare == 2)
                                              ? Text('Restaurant',
                                                  style: TextStyle(
                                                    color: Colors.red,
                                                  ))
                                              : Text('Restaurant', style: TextStyle(color: Colors.black)),
                                          SizedBox(width: responsive.wp(2)),
                                          CircleAvatar(
                                            radius: responsive.ip(1.23),
                                            backgroundColor: Colors.red,
                                            child: Text(
                                              '${snapshot.data}',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: responsive.ip(1.1),
                                              ),
                                            ),
                                          )
                                        ],
                                      );
                                    }
                                  } else {
                                    return (csmare == 2)
                                        ? Text(
                                            'Restaurant',
                                            style: TextStyle(color: Colors.red),
                                          )
                                        : Text('Restaurant', style: TextStyle(color: Colors.black));
                                  }
                                }),
                          ),
                          //Restaurant \n Delivery
                          Tab(
                            child: StreamBuilder(
                                stream: productosBloc.cantidadEnchiladasDeliveryStream,
                                builder: (context, AsyncSnapshot<int> snapshot) {
                                  if (snapshot.hasData) {
                                    if (snapshot.data == 20000) {
                                      return (csmare == 3)
                                          ? Text(
                                              'Restaurant \n Delivery',
                                              style: TextStyle(color: Colors.red),
                                            )
                                          : Text('Restaurant \n Delivery', style: TextStyle(color: Colors.black));
                                    } else {
                                      return Row(
                                        children: [
                                          (csmare == 3)
                                              ? Text(
                                                  'Restaurant \n Delivery',
                                                  style: TextStyle(color: Colors.red),
                                                )
                                              : Text('Restaurant \n Delivery', style: TextStyle(color: Colors.black)),
                                          SizedBox(width: responsive.wp(2)),
                                          CircleAvatar(
                                            radius: responsive.ip(1.23),
                                            backgroundColor: Colors.red,
                                            child: Text(
                                              '${snapshot.data}',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: responsive.ip(1.1),
                                              ),
                                            ),
                                          )
                                        ],
                                      );
                                    }
                                  } else {
                                    return (csmare == 3)
                                        ? Text(
                                            'Restaurant \n Delivery',
                                            style: TextStyle(color: Colors.red),
                                          )
                                        : Text('Restaurant \n Delivery', style: TextStyle(color: Colors.black));
                                  }
                                }),
                          ),

                          // Cafe 24/7
                          Tab(
                            child: StreamBuilder(
                                stream: productosBloc.cantidadCafeStream,
                                builder: (context, AsyncSnapshot<int> snapshot) {
                                  if (snapshot.hasData) {
                                    if (snapshot.data == 20000) {
                                      return (csmare == 4)
                                          ? Text(
                                              'Cafe 24/7',
                                              style: TextStyle(color: Colors.red),
                                            )
                                          : Text('Cafe 24/7', style: TextStyle(color: Colors.black));
                                    } else {
                                      return Row(
                                        children: [
                                          (csmare == 4)
                                              ? Text(
                                                  'Cafe 24/7',
                                                  style: TextStyle(color: Colors.red),
                                                )
                                              : Text('Cafe 24/7', style: TextStyle(color: Colors.black)),
                                          SizedBox(width: responsive.wp(2)),
                                          CircleAvatar(
                                            radius: responsive.ip(1.23),
                                            backgroundColor: Colors.red,
                                            child: Text(
                                              '${snapshot.data}',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: responsive.ip(1.1),
                                              ),
                                            ),
                                          )
                                        ],
                                      );
                                    }
                                  } else {
                                    return (csmare == 4)
                                        ? Text(
                                            'Cafe 24/7',
                                            style: TextStyle(color: Colors.red),
                                          )
                                        : Text('Cafe 24/7', style: TextStyle(color: Colors.black));
                                  }
                                }),
                          ),

                          //Cafe 24/7 \n Delivery
                          Tab(
                            child: StreamBuilder(
                                stream: productosBloc.cantidadCafeDeliveryStream,
                                builder: (context, AsyncSnapshot<int> snapshot) {
                                  if (snapshot.hasData) {
                                    if (snapshot.data == 20000) {
                                      return (csmare == 5)
                                          ? Text(
                                              'Cafe 24/7 \n Delivery',
                                              style: TextStyle(color: Colors.red),
                                            )
                                          : Text('Cafe 24/7 \n Delivery', style: TextStyle(color: Colors.black));
                                    } else {
                                      return Row(
                                        children: [
                                          (csmare == 5)
                                              ? Text(
                                                  'Cafe 24/7 \n Delivery',
                                                  style: TextStyle(color: Colors.red),
                                                )
                                              : Text('Cafe 24/7 \n Delivery', style: TextStyle(color: Colors.black)),
                                          SizedBox(width: responsive.wp(2)),
                                          CircleAvatar(
                                            radius: responsive.ip(1.23),
                                            backgroundColor: Colors.red,
                                            child: Text(
                                              '${snapshot.data}',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: responsive.ip(1.1),
                                              ),
                                            ),
                                          )
                                        ],
                                      );
                                    }
                                  } else {
                                    return (csmare == 5)
                                        ? Text(
                                            'Cafe 24/7 \n Delivery',
                                            style: TextStyle(color: Colors.red),
                                          )
                                        : Text('Cafe 24/7 \n Delivery', style: TextStyle(color: Colors.black));
                                  }
                                }),
                          ),
                        ],
                      )
                    : ButtonsTabBar(
                        height: responsive.hp(8),
                        controller: _controller,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          border: Border(
                            bottom: BorderSide(
                              color: Colors.red,
                              width: 1.5,
                            ),
                          ),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: responsive.wp(3),
                        ),
                        onTap: (valor) {
                          _controller.index = valor;
                          //setState(() {_controller.index = valor;});
                        },
                        unselectedBackgroundColor: Colors.transparent,
                        unselectedLabelStyle: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'MADE-TOMMY',
                          fontSize: responsive.ip(1.6),
                        ),
                        labelStyle: TextStyle(
                          color: Colors.red,
                          fontFamily: 'MADE-TOMMY',
                          fontWeight: FontWeight.bold,
                          fontSize: responsive.ip(1.6),
                        ),
                        tabs: [
                          //Restaurant
                          Tab(
                            child: StreamBuilder(
                                stream: productosBloc.cantidadEnchiladasStream,
                                builder: (context, AsyncSnapshot<int> snapshot) {
                                  if (snapshot.hasData) {
                                    if (snapshot.data == 20000) {
                                      return (csmare == 0)
                                          ? Text(
                                              'Restaurant',
                                              style: TextStyle(color: Colors.red),
                                            )
                                          : Text('Restaurant', style: TextStyle(color: Colors.black));
                                    } else {
                                      return Row(
                                        children: [
                                          (csmare == 0)
                                              ? Text('Restaurant',
                                                  style: TextStyle(
                                                    color: Colors.red,
                                                  ))
                                              : Text('Restaurant', style: TextStyle(color: Colors.black)),
                                          SizedBox(width: responsive.wp(2)),
                                          CircleAvatar(
                                            radius: responsive.ip(1.23),
                                            backgroundColor: Colors.red,
                                            child: Text(
                                              '${snapshot.data}',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: responsive.ip(1.1),
                                              ),
                                            ),
                                          )
                                        ],
                                      );
                                    }
                                  } else {
                                    return (csmare == 0)
                                        ? Text(
                                            'Restaurant',
                                            style: TextStyle(color: Colors.red),
                                          )
                                        : Text('Restaurant', style: TextStyle(color: Colors.black));
                                  }
                                }),
                          ),
                          //Restaurant \n Delivery
                          Tab(
                            child: StreamBuilder(
                                stream: productosBloc.cantidadEnchiladasDeliveryStream,
                                builder: (context, AsyncSnapshot<int> snapshot) {
                                  if (snapshot.hasData) {
                                    if (snapshot.data == 20000) {
                                      return (csmare == 1)
                                          ? Text(
                                              'Restaurant \n Delivery',
                                              style: TextStyle(color: Colors.red),
                                            )
                                          : Text('Restaurant \n Delivery', style: TextStyle(color: Colors.black));
                                    } else {
                                      return Row(
                                        children: [
                                          (csmare == 1)
                                              ? Text(
                                                  'Restaurant \n Delivery',
                                                  style: TextStyle(color: Colors.red),
                                                )
                                              : Text('Restaurant \n Delivery', style: TextStyle(color: Colors.black)),
                                          SizedBox(width: responsive.wp(2)),
                                          CircleAvatar(
                                            radius: responsive.ip(1.23),
                                            backgroundColor: Colors.red,
                                            child: Text(
                                              '${snapshot.data}',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: responsive.ip(1.1),
                                              ),
                                            ),
                                          )
                                        ],
                                      );
                                    }
                                  } else {
                                    return (csmare == 1)
                                        ? Text(
                                            'Restaurant \n Delivery',
                                            style: TextStyle(color: Colors.red),
                                          )
                                        : Text('Restaurant \n Delivery', style: TextStyle(color: Colors.black));
                                  }
                                }),
                          ),

                          // Cafe 24/7
                          Tab(
                            child: StreamBuilder(
                                stream: productosBloc.cantidadCafeStream,
                                builder: (context, AsyncSnapshot<int> snapshot) {
                                  if (snapshot.hasData) {
                                    if (snapshot.data == 20000) {
                                      return (csmare == 2)
                                          ? Text(
                                              'Cafe 24/7',
                                              style: TextStyle(color: Colors.red),
                                            )
                                          : Text('Cafe 24/7', style: TextStyle(color: Colors.black));
                                    } else {
                                      return Row(
                                        children: [
                                          (csmare == 2)
                                              ? Text(
                                                  'Cafe 24/7',
                                                  style: TextStyle(color: Colors.red),
                                                )
                                              : Text('Cafe 24/7', style: TextStyle(color: Colors.black)),
                                          SizedBox(width: responsive.wp(2)),
                                          CircleAvatar(
                                            radius: responsive.ip(1.23),
                                            backgroundColor: Colors.red,
                                            child: Text(
                                              '${snapshot.data}',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: responsive.ip(1.1),
                                              ),
                                            ),
                                          )
                                        ],
                                      );
                                    }
                                  } else {
                                    return (csmare == 2)
                                        ? Text(
                                            'Cafe 24/7',
                                            style: TextStyle(color: Colors.red),
                                          )
                                        : Text('Cafe 24/7', style: TextStyle(color: Colors.black));
                                  }
                                }),
                          ),

                          //Cafe 24/7 \n Delivery
                          Tab(
                            child: StreamBuilder(
                                stream: productosBloc.cantidadCafeDeliveryStream,
                                builder: (context, AsyncSnapshot<int> snapshot) {
                                  if (snapshot.hasData) {
                                    if (snapshot.data == 20000) {
                                      return (csmare == 3)
                                          ? Text(
                                              'Cafe 24/7 \n Delivery',
                                              style: TextStyle(color: Colors.red),
                                            )
                                          : Text('Cafe 24/7 \n Delivery', style: TextStyle(color: Colors.black));
                                    } else {
                                      return Row(
                                        children: [
                                          (csmare == 3)
                                              ? Text(
                                                  'Cafe 24/7 \n Delivery',
                                                  style: TextStyle(color: Colors.red),
                                                )
                                              : Text('Cafe 24/7 \n Delivery', style: TextStyle(color: Colors.black)),
                                          SizedBox(width: responsive.wp(2)),
                                          CircleAvatar(
                                            radius: responsive.ip(1.23),
                                            backgroundColor: Colors.red,
                                            child: Text(
                                              '${snapshot.data}',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: responsive.ip(1.1),
                                              ),
                                            ),
                                          )
                                        ],
                                      );
                                    }
                                  } else {
                                    return (csmare == 3)
                                        ? Text(
                                            'Cafe 24/7 \n Delivery',
                                            style: TextStyle(color: Colors.red),
                                          )
                                        : Text('Cafe 24/7 \n Delivery', style: TextStyle(color: Colors.black));
                                  }
                                }),
                          ),

                          //Var 24/7
                          Tab(
                            child: StreamBuilder(
                                stream: productosBloc.cantidadVarStream,
                                builder: (context, AsyncSnapshot<int> snapshot) {
                                  if (snapshot.hasData) {
                                    if (snapshot.data == 20000) {
                                      return (csmare == 4)
                                          ? Text(
                                              'Var 24/7',
                                              style: TextStyle(color: Colors.red),
                                            )
                                          : Text('Var 24/7', style: TextStyle(color: Colors.black));
                                    } else {
                                      return Row(
                                        children: [
                                          (csmare == 4)
                                              ? Text(
                                                  'Var 24/7',
                                                  style: TextStyle(color: Colors.red),
                                                )
                                              : Text('Var 24/7', style: TextStyle(color: Colors.black)),
                                          SizedBox(width: responsive.wp(2)),
                                          CircleAvatar(
                                            radius: responsive.ip(1.23),
                                            backgroundColor: Colors.red,
                                            child: Text(
                                              '${snapshot.data}',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: responsive.ip(1.1),
                                              ),
                                            ),
                                          )
                                        ],
                                      );
                                    }
                                  } else {
                                    return (csmare == 4)
                                        ? Text(
                                            'Var 24/7',
                                            style: TextStyle(color: Colors.red),
                                          )
                                        : Text('Var 24/7', style: TextStyle(color: Colors.black));
                                  }
                                }),
                          ),

                          //Var 24/7 \n Delivery
                          Tab(
                            child: StreamBuilder(
                                stream: productosBloc.cantidadVarDeliveryStream,
                                builder: (context, AsyncSnapshot<int> snapshot) {
                                  if (snapshot.hasData) {
                                    if (snapshot.data == 20000) {
                                      return (csmare == 5)
                                          ? Text(
                                              'Var 24/7 \n Delivery',
                                              style: TextStyle(color: Colors.red),
                                            )
                                          : Text('Var 24/7 \n Delivery', style: TextStyle(color: Colors.black));
                                    } else {
                                      return Row(
                                        children: [
                                          (csmare == 5)
                                              ? Text(
                                                  'Var 24/7 \n Delivery',
                                                  style: TextStyle(color: Colors.red),
                                                )
                                              : Text('Var 24/7 \n Delivery', style: TextStyle(color: Colors.black)),
                                          SizedBox(width: responsive.wp(2)),
                                          CircleAvatar(
                                            radius: responsive.ip(1.23),
                                            backgroundColor: Colors.red,
                                            child: Text(
                                              '${snapshot.data}',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: responsive.ip(1.1),
                                              ),
                                            ),
                                          )
                                        ],
                                      );
                                    }
                                  } else {
                                    return (csmare == 5)
                                        ? Text(
                                            'Var 24/7 \n Delivery',
                                            style: TextStyle(color: Colors.red),
                                          )
                                        : Text('Var 24/7 \n Delivery', style: TextStyle(color: Colors.black));
                                  }
                                }),
                          ),
                        ],
                      ),
            Expanded(
              child: TabBarView(
                controller: _controller,
                children: (preferences.tipoCategoriaNumero == '3')
                    ? <Widget>[
                        CafeWidget(responsive: responsive),
                        CafeDeliveryWidget(responsive: responsive),
                        RestaurantWidget(responsive: responsive),
                        RestaurantDeliveryWidget(responsive: responsive),
                        VarWidget(responsive: responsive),
                        VarDeliveryWidget(responsive: responsive),
                      ]
                    : (preferences.tipoCategoriaNumero == '4')
                        ? <Widget>[
                            VarWidget(responsive: responsive),
                            VarDeliveryWidget(responsive: responsive),
                            RestaurantWidget(responsive: responsive),
                            RestaurantDeliveryWidget(responsive: responsive),
                            CafeWidget(responsive: responsive),
                            CafeDeliveryWidget(responsive: responsive),
                          ]
                        : <Widget>[
                            RestaurantWidget(responsive: responsive),
                            RestaurantDeliveryWidget(responsive: responsive),
                            CafeWidget(responsive: responsive),
                            CafeDeliveryWidget(responsive: responsive),
                            VarWidget(responsive: responsive),
                            VarDeliveryWidget(responsive: responsive),
                          ],
              ),
            )
          ],
        ),
      ),
      /* SafeArea(
        child: StreamBuilder(
          stream: productosBloc.productosQueryStream,
          builder: (BuildContext context, AsyncSnapshot<List<ProductosData>> snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data.length > 0) {
                return ListView.builder(
                  padding: EdgeInsets.only(top: responsive.hp(1)),
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, i) {
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            transitionDuration: const Duration(milliseconds: 400),
                            pageBuilder: (context, animation, secondaryAnimation) {
                              return DetalleProductitoss2(
                                productosData: snapshot.data[i],
                                mostrarback: true,
                              );
                            },
                            transitionsBuilder: (context, animation, secondaryAnimation, child) {
                              return FadeTransition(
                                opacity: animation,
                                child: child,
                              );
                            },
                          ),
                        );
                      },
                      child: Container(
                        child: Column(
                          children: [
                            Row(
                              children: [
                                SizedBox(
                                  width: responsive.wp(3),
                                ),
                                Expanded(
                                  child: Text(
                                    '${snapshot.data[i].productoNombre}',
                                    style: TextStyle(
                                      fontSize: responsive.ip(1.6),
                                    ),
                                  ),
                                ),
                                Container(
                                  width: responsive.wp(20),
                                  child: Text(
                                    '${snapshot.data[i].idCategoria}',
                                    style: TextStyle(
                                      fontSize: responsive.ip(1.8),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            Divider()
                          ],
                        ),
                      ),
                    );
                  },
                );
              } else {
                return (igual == 0)
                    ? Center(
                        child: Text('Empezamos'),
                      )
                    : Column(
                        children: [
                          CircleAvatar(
                            radius: responsive.ip(5),
                            backgroundColor: Colors.grey,
                            child: Icon(
                              Icons.search,
                              color: Colors.yellow,
                              size: responsive.ip(4),
                            ),
                          ),
                          Center(
                            child: Text(
                              'Producto no encontrado',
                              style: TextStyle(
                                fontSize: responsive.ip(2),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          Center(
                            child: Text(
                              'Intente búscar otro producto',
                              style: TextStyle(
                                fontSize: responsive.ip(1.8),
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          SizedBox(height: responsive.hp(5)),
                        ],
                      );
              }
            } else {
              return Center(child: CupertinoActivityIndicator());
            }
          },
        ),
      ),
     */
    );
  }
}

class RestaurantWidget extends StatelessWidget {
  const RestaurantWidget({
    Key key,
    @required this.responsive,
  }) : super(key: key);

  final Responsive responsive;

  @override
  Widget build(BuildContext context) {
    final productosBloc = ProviderBloc.busquedaAngelo(context);
    return StreamBuilder(
      stream: productosBloc.productosQueryEnchiladasStream,
      builder: (BuildContext context, AsyncSnapshot<List<ProductosData>> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.length > 0) {
            return ListView.builder(
              padding: EdgeInsets.only(top: responsive.hp(1)),
              itemCount: snapshot.data.length,
              itemBuilder: (context, i) {
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        transitionDuration: const Duration(milliseconds: 400),
                        pageBuilder: (context, animation, secondaryAnimation) {
                          return DetalleProductitoss2(
                            productosData: snapshot.data[i],
                            mostrarback: true,
                          );
                        },
                        transitionsBuilder: (context, animation, secondaryAnimation, child) {
                          return FadeTransition(
                            opacity: animation,
                            child: child,
                          );
                        },
                      ),
                    );
                  },
                  child: Container(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              width: responsive.wp(3),
                            ),
                            Expanded(
                              child: Text(
                                '${snapshot.data[i].productoNombre}',
                                style: TextStyle(
                                  fontSize: responsive.ip(1.6),
                                ),
                              ),
                            ),
                            
                          ],
                        ),
                        Divider()
                      ],
                    ),
                  ),
                );
              },
            );
          } else {
            return Column(
              children: [
                CircleAvatar(
                  radius: responsive.ip(5),
                  backgroundColor: Colors.grey,
                  child: Icon(
                    Icons.search,
                    color: Colors.yellow,
                    size: responsive.ip(4),
                  ),
                ),
                Center(
                  child: Text(
                    'Producto no encontrado',
                    style: TextStyle(
                      fontSize: responsive.ip(2),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    'Intente búscar otro producto',
                    style: TextStyle(
                      fontSize: responsive.ip(1.8),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                SizedBox(height: responsive.hp(5)),
              ],
            );
          }
        } else {
          return Container();
        }
      },
    );
  }
}

class CafeWidget extends StatelessWidget {
  const CafeWidget({
    Key key,
    @required this.responsive,
  }) : super(key: key);

  final Responsive responsive;

  @override
  Widget build(BuildContext context) {
    final productosBloc = ProviderBloc.busquedaAngelo(context);
    return StreamBuilder(
      stream: productosBloc.productosQueryCafeStream,
      builder: (BuildContext context, AsyncSnapshot<List<ProductosData>> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.length > 0) {
            return ListView.builder(
              padding: EdgeInsets.only(top: responsive.hp(1)),
              itemCount: snapshot.data.length,
              itemBuilder: (context, i) {
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        transitionDuration: const Duration(milliseconds: 400),
                        pageBuilder: (context, animation, secondaryAnimation) {
                          return DetalleProductitoss2(
                            productosData: snapshot.data[i],
                            mostrarback: true,
                          );
                        },
                        transitionsBuilder: (context, animation, secondaryAnimation, child) {
                          return FadeTransition(
                            opacity: animation,
                            child: child,
                          );
                        },
                      ),
                    );
                  },
                  child: Container(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              width: responsive.wp(3),
                            ),
                            Expanded(
                              child: Text(
                                '${snapshot.data[i].productoNombre}',
                                style: TextStyle(
                                  fontSize: responsive.ip(1.6),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Divider()
                      ],
                    ),
                  ),
                );
              },
            );
          } else {
            return Column(
              children: [
                CircleAvatar(
                  radius: responsive.ip(5),
                  backgroundColor: Colors.grey,
                  child: Icon(
                    Icons.search,
                    color: Colors.yellow,
                    size: responsive.ip(4),
                  ),
                ),
                Center(
                  child: Text(
                    'Producto no encontrado',
                    style: TextStyle(
                      fontSize: responsive.ip(2),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    'Intente búscar otro producto',
                    style: TextStyle(
                      fontSize: responsive.ip(1.8),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                SizedBox(height: responsive.hp(5)),
              ],
            );
          }
        } else {
          return Container();
        }
      },
    );
  }
}

class VarWidget extends StatelessWidget {
  const VarWidget({
    Key key,
    @required this.responsive,
  }) : super(key: key);

  final Responsive responsive;

  @override
  Widget build(BuildContext context) {
    final productosBloc = ProviderBloc.busquedaAngelo(context);
    return StreamBuilder(
      stream: productosBloc.productosQueryVarStream,
      builder: (BuildContext context, AsyncSnapshot<List<ProductosData>> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.length > 0) {
            return ListView.builder(
              padding: EdgeInsets.only(top: responsive.hp(1)),
              itemCount: snapshot.data.length,
              itemBuilder: (context, i) {
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        transitionDuration: const Duration(milliseconds: 400),
                        pageBuilder: (context, animation, secondaryAnimation) {
                          return DetalleProductitoss2(
                            productosData: snapshot.data[i],
                            mostrarback: true,
                          );
                        },
                        transitionsBuilder: (context, animation, secondaryAnimation, child) {
                          return FadeTransition(
                            opacity: animation,
                            child: child,
                          );
                        },
                      ),
                    );
                  },
                  child: Container(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              width: responsive.wp(3),
                            ),
                            Expanded(
                              child: Text(
                                '${snapshot.data[i].productoNombre}',
                                style: TextStyle(
                                  fontSize: responsive.ip(1.6),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Divider()
                      ],
                    ),
                  ),
                );
              },
            );
          } else {
            return Column(
              children: [
                CircleAvatar(
                  radius: responsive.ip(5),
                  backgroundColor: Colors.grey,
                  child: Icon(
                    Icons.search,
                    color: Colors.yellow,
                    size: responsive.ip(4),
                  ),
                ),
                Center(
                  child: Text(
                    'Producto no encontrado',
                    style: TextStyle(
                      fontSize: responsive.ip(2),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    'Intente búscar otro producto',
                    style: TextStyle(
                      fontSize: responsive.ip(1.8),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                SizedBox(height: responsive.hp(5)),
              ],
            );
          }
        } else {
          return Container();
        }
      },
    );
  }
}

class RestaurantDeliveryWidget extends StatelessWidget {
  const RestaurantDeliveryWidget({
    Key key,
    @required this.responsive,
  }) : super(key: key);

  final Responsive responsive;

  @override
  Widget build(BuildContext context) {
    final productosBloc = ProviderBloc.busquedaAngelo(context);

    return StreamBuilder(
      stream: productosBloc.productosQueryEnchiladasDeliveryStream,
      builder: (BuildContext context, AsyncSnapshot<List<ProductosData>> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.length > 0) {
            return ListView.builder(
              padding: EdgeInsets.only(top: responsive.hp(1)),
              itemCount: snapshot.data.length,
              itemBuilder: (context, i) {
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        transitionDuration: const Duration(milliseconds: 400),
                        pageBuilder: (context, animation, secondaryAnimation) {
                          return DetalleProductitoss2(
                            productosData: snapshot.data[i],
                            mostrarback: true,
                          );
                        },
                        transitionsBuilder: (context, animation, secondaryAnimation, child) {
                          return FadeTransition(
                            opacity: animation,
                            child: child,
                          );
                        },
                      ),
                    );
                  },
                  child: Container(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              width: responsive.wp(3),
                            ),
                            Expanded(
                              child: Text(
                                '${snapshot.data[i].productoNombre}',
                                style: TextStyle(
                                  fontSize: responsive.ip(1.6),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Divider()
                      ],
                    ),
                  ),
                );
              },
            );
          } else {
            return Column(
              children: [
                CircleAvatar(
                  radius: responsive.ip(5),
                  backgroundColor: Colors.grey,
                  child: Icon(
                    Icons.search,
                    color: Colors.yellow,
                    size: responsive.ip(4),
                  ),
                ),
                Center(
                  child: Text(
                    'Producto no encontrado',
                    style: TextStyle(
                      fontSize: responsive.ip(2),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    'Intente búscar otro producto',
                    style: TextStyle(
                      fontSize: responsive.ip(1.8),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                SizedBox(height: responsive.hp(5)),
              ],
            );
          }
        } else {
          return Container();
        }
      },
    );
  }
}

class CafeDeliveryWidget extends StatelessWidget {
  const CafeDeliveryWidget({
    Key key,
    @required this.responsive,
  }) : super(key: key);

  final Responsive responsive;

  @override
  Widget build(BuildContext context) {
    final productosBloc = ProviderBloc.busquedaAngelo(context);

    return StreamBuilder(
      stream: productosBloc.productosQueryCafeDeliveryStream,
      builder: (BuildContext context, AsyncSnapshot<List<ProductosData>> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.length > 0) {
            return ListView.builder(
              padding: EdgeInsets.only(top: responsive.hp(1)),
              itemCount: snapshot.data.length,
              itemBuilder: (context, i) {
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        transitionDuration: const Duration(milliseconds: 400),
                        pageBuilder: (context, animation, secondaryAnimation) {
                          return DetalleProductitoss2(
                            productosData: snapshot.data[i],
                            mostrarback: true,
                          );
                        },
                        transitionsBuilder: (context, animation, secondaryAnimation, child) {
                          return FadeTransition(
                            opacity: animation,
                            child: child,
                          );
                        },
                      ),
                    );
                  },
                  child: Container(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              width: responsive.wp(3),
                            ),
                            Expanded(
                              child: Text(
                                '${snapshot.data[i].productoNombre}',
                                style: TextStyle(
                                  fontSize: responsive.ip(1.6),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Divider()
                      ],
                    ),
                  ),
                );
              },
            );
          } else {
            return Column(
              children: [
                CircleAvatar(
                  radius: responsive.ip(5),
                  backgroundColor: Colors.grey,
                  child: Icon(
                    Icons.search,
                    color: Colors.yellow,
                    size: responsive.ip(4),
                  ),
                ),
                Center(
                  child: Text(
                    'Producto no encontrado',
                    style: TextStyle(
                      fontSize: responsive.ip(2),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    'Intente búscar otro producto',
                    style: TextStyle(
                      fontSize: responsive.ip(1.8),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                SizedBox(height: responsive.hp(5)),
              ],
            );
          }
        } else {
          return Container();
        }
      },
    );
  }
}

class VarDeliveryWidget extends StatelessWidget {
  const VarDeliveryWidget({
    Key key,
    @required this.responsive,
  }) : super(key: key);

  final Responsive responsive;

  @override
  Widget build(BuildContext context) {
    final productosBloc = ProviderBloc.busquedaAngelo(context);

    return StreamBuilder(
      stream: productosBloc.productosQueryVarDeliveryStream,
      builder: (BuildContext context, AsyncSnapshot<List<ProductosData>> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.length > 0) {
            return ListView.builder(
              padding: EdgeInsets.only(top: responsive.hp(1)),
              itemCount: snapshot.data.length,
              itemBuilder: (context, i) {
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        transitionDuration: const Duration(milliseconds: 400),
                        pageBuilder: (context, animation, secondaryAnimation) {
                          return DetalleProductitoss2(
                            productosData: snapshot.data[i],
                            mostrarback: true,
                          );
                        },
                        transitionsBuilder: (context, animation, secondaryAnimation, child) {
                          return FadeTransition(
                            opacity: animation,
                            child: child,
                          );
                        },
                      ),
                    );
                  },
                  child: Container(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              width: responsive.wp(3),
                            ),
                            Expanded(
                              child: Text(
                                '${snapshot.data[i].productoNombre}',
                                style: TextStyle(
                                  fontSize: responsive.ip(1.6),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Divider()
                      ],
                    ),
                  ),
                );
              },
            );
          } else {
            return Column(
              children: [
                CircleAvatar(
                  radius: responsive.ip(5),
                  backgroundColor: Colors.grey,
                  child: Icon(
                    Icons.search,
                    color: Colors.yellow,
                    size: responsive.ip(4),
                  ),
                ),
                Center(
                  child: Text(
                    'Producto no encontrado',
                    style: TextStyle(
                      fontSize: responsive.ip(2),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    'Intente búscar otro producto',
                    style: TextStyle(
                      fontSize: responsive.ip(1.8),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                SizedBox(height: responsive.hp(5)),
              ],
            );
          }
        } else {
          return Container();
        }
      },
    );
  }
}
