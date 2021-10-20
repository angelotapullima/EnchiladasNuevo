

import 'package:enchiladasapp/src/bloc/provider.dart';
import 'package:enchiladasapp/src/models/productos_model.dart';
import 'package:enchiladasapp/src/pages/detalle_producto2.dart';
import 'package:enchiladasapp/src/utils/responsive.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController _controllerBusquedaProducto = TextEditingController();
  final _currentPageNotifier = ValueNotifier<bool>(false);
  int igual = 0;

  @override
  void dispose() {
    _controllerBusquedaProducto.dispose();
    super.dispose();
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final productosBloc = ProviderBloc.prod(context);
      productosBloc.obtenerProductoPorQueryDelivery('');
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final productosBloc = ProviderBloc.prod(context);
    //productosBloc.obtenerProductoPorQueryDelivery('$query');
    final responsive = Responsive.of(context);

    final productoBloc = ProviderBloc.prod(context);
    productoBloc.obtenerProductosdeliveryEnchiladasPorCategoria('3');

    return Scaffold(
      backgroundColor: Color(0xFFF0EFEF),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Color(0xFFF0EFEF),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      BackButton(),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: responsive.wp(2),
                          ),
                          width: double.infinity,
                          height: responsive.hp(5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Container(
                                  color: Colors.white,
                                  child: Center(
                                    child: TextField(
                                      controller: _controllerBusquedaProducto,
                                      keyboardType: TextInputType.text,
                                      decoration: InputDecoration(
                                        hintText: '¿Qué esta buscando?',
                                        border: InputBorder.none,
                                        hintStyle: TextStyle(color: Colors.black45),
                                        filled: false,
                                        contentPadding: EdgeInsets.symmetric(
                                          vertical: responsive.hp(.2),
                                        ),
                                      ),
                                      onChanged: (value) {
                                        if (value.length >= 0 && value != ' ') {
                                          igual++;
                                          _currentPageNotifier.value = true;
                                          productosBloc.obtenerProductoPorQueryDelivery('$value');
                                          //agregarHistorial(context, value, 'pro');
                                        }
                                      },
                                      /*  onSubmitted: (value) {
                                        /*  setState(() {
                                                expandFlag = false;
                                              }); */
                                        if (value.length >= 0 && value != ' ') {
                                          igual++;
                                          productosBloc.obtenerProductoPorQueryDelivery('$value');
                                          //agregarHistorial(context, value, 'pro');
                                        }
                                      }, */
                                    ),
                                  ),
                                ),
                              ),
                              ValueListenableBuilder(
                                valueListenable: _currentPageNotifier,
                                builder: (BuildContext context, bool data, Widget child) {
                                  return (data)
                                      ? InkWell(
                                          onTap: () {
                                            igual++;
                                            productosBloc.obtenerProductoPorQueryDelivery('');
                                            _controllerBusquedaProducto.text = '';
                                            setState(() {});
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
                              )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        width: responsive.wp(3),
                      ),
                    ],
                  ),
                  SizedBox(height: responsive.hp(2))
                ],
              ),
            ),
            Expanded(
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
                                /* Expanded(
                                  child: StreamBuilder(
                                    stream: productoBloc.productosEnchiladasStream,
                                    builder: (BuildContext context, AsyncSnapshot<List<ProductosData>> snapshot) {
                                      if (snapshot.hasData) {
                                        if (snapshot.data.length > 0) {
                                          return Container(
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(30),
                                                topRight: Radius.circular(30),
                                              ),
                                            ),
                                            child: GridView.builder(
                                              padding: EdgeInsets.zero,
                                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                                  //childAspectRatio: 1,
                                                  crossAxisCount: 2,
                                                  mainAxisSpacing: responsive.hp(2),
                                                  crossAxisSpacing: responsive.wp(3)),
                                              itemCount: snapshot.data.length,
                                              itemBuilder: (context, i) {
                                                if (i == 0) {
                                                  return Center(
                                                    child: Padding(
                                                      padding: EdgeInsets.all(10.0),
                                                      child: Text(
                                                        'Productos populares',
                                                        textAlign: TextAlign.center,
                                                        style: TextStyle(
                                                          fontSize: 20,
                                                          fontWeight: FontWeight.w700,
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                }

                                                return Transform.translate(
                                                  offset: Offset(00, i.isOdd ? 100 : 0),
                                                  child: Container(
                                                    width: double.infinity,
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(10),
                                                      color: Colors.white,
                                                    ),
                                                    margin: EdgeInsets.only(
                                                      right: responsive.wp(1.5),
                                                      left: responsive.wp(1.5),
                                                    ),
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Stack(
                                                          children: <Widget>[
                                                            Container(
                                                              height: responsive.hp(14),
                                                              width: double.infinity,
                                                              child: ClipRRect(
                                                                borderRadius: BorderRadius.circular(10),
                                                                child: CachedNetworkImage(
                                                                  progressIndicatorBuilder: (_, url, downloadProgress) {
                                                                    return Container(
                                                                      width: double.infinity,
                                                                      height: double.infinity,
                                                                      child: Stack(
                                                                        children: [
                                                                          Center(
                                                                            child: CircularProgressIndicator(
                                                                              value: downloadProgress.progress,
                                                                              backgroundColor: Colors.green,
                                                                              valueColor: new AlwaysStoppedAnimation<Color>(Colors.red),
                                                                            ),
                                                                          ),
                                                                          Center(
                                                                            child: (downloadProgress.progress != null)
                                                                                ? Text('${(downloadProgress.progress * 100).toInt().toString()}%')
                                                                                : Container(),
                                                                          )
                                                                        ],
                                                                      ),
                                                                    );
                                                                  },
                                                                  errorWidget: (context, url, error) => Image(image: AssetImage('assets/carga_fallida.jpg'), fit: BoxFit.cover),
                                                                  imageUrl: '${snapshot.data[i].productoFoto}',
                                                                  imageBuilder: (context, imageProvider) => Container(
                                                                    decoration: BoxDecoration(
                                                                      image: DecorationImage(
                                                                        image: imageProvider,
                                                                        fit: BoxFit.cover,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            Positioned(
                                                              top: 5,
                                                              left: 0,
                                                              right: 0,
                                                              /*  left: responsive.wp(1),
                                        top: responsive.hp(.5), */
                                                              child: Row(
                                                                children: [
                                                                  Container(
                                                                    padding: EdgeInsets.symmetric(
                                                                      horizontal: responsive.wp(3),
                                                                      vertical: responsive.hp(.5),
                                                                    ),
                                                                    decoration: BoxDecoration(
                                                                        borderRadius: BorderRadius.only(
                                                                          bottomRight: Radius.circular(10),
                                                                        ),
                                                                        color: Colors.red),
                                                                    child: Text(
                                                                      'Nuevo',
                                                                      style: TextStyle(
                                                                        color: Colors.white,
                                                                        fontWeight: FontWeight.bold,
                                                                        fontSize: responsive.ip(1.5),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Spacer(),
                                                                  Container(
                                                                    padding: EdgeInsets.all(5),
                                                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(100), color: Colors.white),
                                                                    child: Center(
                                                                      child: Icon(
                                                                        Ionicons.md_heart,
                                                                        color: Colors.red,
                                                                        size: 15,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    width: responsive.wp(2),
                                                                  )
                                                                ],
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                        Container(
                                                          padding: EdgeInsets.only(
                                                            right: responsive.wp(1.5),
                                                            left: responsive.wp(1.5),
                                                          ),
                                                          height: responsive.hp(3),
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                              Text(
                                                                'S/ 23',
                                                                style: TextStyle(
                                                                  color: Colors.red,
                                                                  fontFamily: 'Aeonik',
                                                                  fontSize: 17,
                                                                ),
                                                              ),
                                                              Container(
                                                                padding: EdgeInsets.symmetric(
                                                                  horizontal: responsive.wp(2),
                                                                  vertical: responsive.hp(.5),
                                                                ),
                                                                decoration: BoxDecoration(
                                                                    borderRadius: BorderRadius.circular(15),
                                                                    /* borderRadius: BorderRadius.only(
                                                bottomRight: Radius.circular(10),
                                              ), */
                                                                    color: Colors.orange),
                                                                child: Text(
                                                                  'Destacado',
                                                                  style: TextStyle(
                                                                    color: Colors.white,
                                                                    fontWeight: FontWeight.bold,
                                                                    fontSize: responsive.ip(1.3),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding: EdgeInsets.only(
                                                            right: responsive.wp(1.5),
                                                            left: responsive.wp(1.5),
                                                          ),
                                                          child: Text(
                                                            '${snapshot.data[i].productoNombre}',
                                                            maxLines: 2,
                                                            overflow: TextOverflow.ellipsis,
                                                            style: TextStyle(
                                                              color: Colors.black,
                                                              fontFamily: 'Aeonik',
                                                              fontSize: 14,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          );
                                        } else {
                                          return Container(
                                            child: Center(child: Text('No aye')),
                                          );
                                        }
                                      } else {
                                        return Container();
                                      }
                                    },
                                  ),
                                )
                               */
                              ],
                            );
                    }
                  } else {
                    return Center(child: CupertinoActivityIndicator());
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
