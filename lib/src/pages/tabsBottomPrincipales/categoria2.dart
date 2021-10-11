import 'package:enchiladasapp/src/bloc/provider.dart';
import 'package:enchiladasapp/src/models/tipo_model.dart';
import 'package:enchiladasapp/src/pages/search.dart';
import 'package:enchiladasapp/src/pages/tabsBottomPrincipales/detalle_categoria.dart';
import 'package:enchiladasapp/src/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_svg/flutter_svg.dart';


class Categoria2 extends StatelessWidget {
  const Categoria2({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final categoriasBloc = ProviderBloc.cat(context);
    categoriasBloc.obtenerCatOrdenado();

    final responsive = Responsive.of(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Categorías',
          style: TextStyle(
            fontFamily: 'MADE-TOMMY',
            fontWeight: FontWeight.bold,
            color: Colors.grey[700],
            fontSize: responsive.ip(2.6),
          ),
        ),
        bottom: PreferredSize(
          child: InkWell(
            onTap: () {
              Navigator.of(context).push(
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) {
                    return SearchPage();
                  },
                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                    var begin = Offset(0.0, 1.0);
                    var end = Offset.zero;
                    var curve = Curves.ease;

                    var tween = Tween(begin: begin, end: end).chain(
                      CurveTween(curve: curve),
                    );

                    return SlideTransition(
                      position: animation.drive(tween),
                      child: child,
                    );
                  },
                ),
              );
            },
            child: Container(
              margin: EdgeInsets.symmetric(
                horizontal: responsive.wp(4),
              ),
              padding: EdgeInsets.symmetric(
                horizontal: responsive.wp(4),
              ),
              height: responsive.hp(5),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Text(
                    '¿Qué esta buscando?',
                    style: TextStyle(
                      fontFamily: 'MADE-TOMMY',
                      color: Color(0xffB0BED1),
                      fontWeight: FontWeight.w600,
                      fontSize: responsive.ip(1.8),
                    ),
                  ),
                  Spacer(),
                  Icon(
                    Icons.search,
                    size: responsive.ip(2.6),
                    color: Colors.black,
                  ),
                ],
              ),
            ),
          ),
          preferredSize: Size.fromHeight(50),
        ),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Column(
        children: [
          SizedBox(
            height: responsive.hp(1),
          ),
          Expanded(
            child: StreamBuilder(
              stream: categoriasBloc.categoriaTipo,
              builder: (context, AsyncSnapshot<List<TipoModel>> snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data.length > 0) {
                    return ListView.builder(
                        itemCount: snapshot.data.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          
                          return ListView.builder(
                            itemCount: snapshot.data[index].cate.length + 1,
                            shrinkWrap: true,
                            physics: ClampingScrollPhysics(),
                            itemBuilder: (context, i) {
                              if (i == 0) {
                                return Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: responsive.wp(2),
                                    vertical: responsive.hp(2),
                                  ),
                                  child: Text(
                                    '${snapshot.data[index].tipo}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: responsive.ip(2.5),
                                    ),
                                  ),
                                );
                              }

                              i = i - 1;
                              return InkWell(
                                onTap: () {
                                  Navigator.of(context).push(PageRouteBuilder(
                                    pageBuilder: (context, animation, secondaryAnimation) {
                                      return Detallecategoria(
                                        idCategoria: '${snapshot.data[index].cate[i].idCategoria}',
                                        categoriaNombre: '${snapshot.data[index].cate[i].categoriaNombre}',
                                        categoriaIcono: '${snapshot.data[index].cate[i].categoriaIcono}',
                                      );
                                    },
                                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                      var begin = Offset(0.0, 1.0);
                                      var end = Offset.zero;
                                      var curve = Curves.ease;

                                      var tween = Tween(begin: begin, end: end).chain(
                                        CurveTween(curve: curve),
                                      );

                                      return SlideTransition(
                                        position: animation.drive(tween),
                                        child: child,
                                      );
                                    },
                                  ));
                                },
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: responsive.wp(5),
                                      ),
                                      child: Row(
                                        children: [
                                          Container(
                                            height: responsive.ip(4),
                                            width: responsive.ip(4),
                                            child: SvgPicture.network(
                                              '${snapshot.data[index].cate[i].categoriaIcono}',
                                              semanticsLabel: 'A shark?!',
                                              placeholderBuilder: (BuildContext context) =>
                                                  Container(padding: const EdgeInsets.all(30.0), child: const CircularProgressIndicator()),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          Expanded(
                                            child: Text(
                                              '${snapshot.data[index].cate[i].categoriaNombre}',
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w600,
                                                fontSize: responsive.ip(1.5),
                                              ),
                                            ),
                                          ),
                                          Icon(Ionicons.ios_arrow_forward, color: Colors.black, size: responsive.hp(3)),
                                        ],
                                      ),
                                    ),
                                    Divider()
                                  ],
                                ),
                              );
                            },
                          );
                        });
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
          ),
        ],
      ),
    );
  }
}
