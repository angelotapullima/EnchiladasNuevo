import 'package:cached_network_image/cached_network_image.dart';
import 'package:enchiladasapp/src/bloc/provider.dart';
import 'package:enchiladasapp/src/bloc/puzzle_bloc.dart';
import 'package:enchiladasapp/src/models/puzzle_model.dart';
import 'package:enchiladasapp/src/utils/responsive.dart';
import 'package:enchiladasapp/src/widgets/DowloadPage.dart';
import 'package:enchiladasapp/src/widgets/customCacheManager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class HomePuzzle extends StatelessWidget {
  final CarouselController buttonCarouselController = CarouselController();
  final ScrollController _scrollController = new ScrollController();

  @override
  Widget build(BuildContext context) {
    //final bloc = Provider.of(context);
    final Responsive responsive = new Responsive.of(context);
    final puzzleBloc = ProviderBloc.puzzle(context);
    puzzleBloc.obtenerPuzzle();

    return Scaffold(
      //resizeToAvoidBottomInset:false,

      body: Stack(
        children: <Widget>[
          _carouselTarjetas(responsive, puzzleBloc),
          Container(
            height: responsive.hp(10),
            child: AppBar(
              backgroundColor: Colors.transparent,
              title: Text(''),
              actions: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: responsive.wp(1),
                  ),
                  child: GestureDetector(
                    child: Center(
                      child: Text(
                        'Ver Ranking',
                        style: TextStyle(
                          fontSize: responsive.ip(2),
                        ),
                      ),
                    ),
                    onTap: () {
                      Navigator.pushNamed(context, 'rankingReport',
                          arguments: '0');
                    },
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _carouselTarjetas(Responsive responsive, PuzzleBloc puzzleBloc) {
    return StreamBuilder(
        stream: puzzleBloc.puzzleStream,
        builder:
            (BuildContext context, AsyncSnapshot<List<PuzzleDatum>> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.length > 0) {
              return _stackTarjetas(context, snapshot.data, responsive);
            } else {
              return Center(child: CupertinoActivityIndicator());
              //return Center(child: Text('no hay Fotos'));
            }
          } else {
            return Center(child: CupertinoActivityIndicator());
          }
        });
  }

  Widget _stackTarjetas(
      BuildContext context, List<PuzzleDatum> puzzle, Responsive responsive) {
    return Stack(
      children: <Widget>[
        _backgroundImage(puzzle, responsive),
        _carousel(context, puzzle, responsive),
        
      ],
    );
  }

  /* Widget _button(
      BuildContext context, List<PuzzleDatum> puzzle, Responsive responsive) { 
    final size = MediaQuery.of(context).size;
    return Positioned(
      bottom: responsive.hp(2),
      left: responsive.wp(10),
      right: responsive.wp(10),
      child: ButtonTheme(
        height: responsive.hp(6),
        minWidth: responsive.wp(10),
        child: RaisedButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          color: Colors.red,
          textColor: Colors.white,
          onPressed: () {
            print('${_scrollController.offset / size.width}');
            RankingPuzzle rankingPuzzle = RankingPuzzle();
            rankingPuzzle.idImagen =
                puzzle[(_scrollController.offset ~/ size.width)].idImagen;
            rankingPuzzle.path =
                puzzle[(_scrollController.offset ~/ size.width)].imagenRuta;
            Navigator.pushNamed(context, 'puzzle', arguments: rankingPuzzle);
          },
          child: Text(
            "Empezar ahora!".toUpperCase(),
            style: TextStyle(
              fontSize: responsive.ip(1.8),
            ),
          ),
        ),
      ),
    );
  }

  */ Widget _backgroundImage(List<PuzzleDatum> puzzle, Responsive responsive) {
    //print("${pelicula[0].getPosterImg()}");
    return Container(
      width: double.infinity,
      child: ListView.builder(
          controller: _scrollController,
          reverse: true,
          scrollDirection: Axis.horizontal,
          itemCount: puzzle.length,
          itemBuilder: (BuildContext context, int index) {
            return new Container(
                width: MediaQuery.of(context).size.width,
                decoration: new BoxDecoration(
                  color: Colors.black12,
                ),
                child: new Container(
                  child: CachedNetworkImage(
                    cacheManager: CustomCacheManager(),
                    imageUrl: puzzle[index].imagenRuta,errorWidget: (context, url, error) => Image(
                  image: AssetImage('assets/carga_fallida.jpg'),
                  fit: BoxFit.cover),
                    imageBuilder: (context, imageProvider) => Container(
                      decoration: BoxDecoration(
                          image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      )),
                    ),
                  ),
                  decoration:
                      new BoxDecoration(color: Colors.black.withOpacity(0.6)),
                ));
          }),
    );
  }

  Widget _carousel(
      BuildContext context, List<PuzzleDatum> puzzle, Responsive responsive) {
    final List<Widget> imageSliders = puzzle
        .map(
          (item) => Container(
            child: DowloadImagen(
                idImagen: item.idImagen,
                devolucion: cardSlider(context,puzzle, item.imagenRuta, responsive),
                foto: item.imagenRuta),
          ),
        )
        .toList();

    final size = MediaQuery.of(context).size;
    return CarouselSlider(
      options: CarouselOptions(
        height: size.height,
        aspectRatio: 2,
        carouselController: buttonCarouselController,
        viewportFraction: 0.68,
        enlargeCenterPage: true,
        enableInfiniteScroll: false,
        onScrolled: (data) {
          _scrollController.animateTo(
            data * size.width,
            /* ((data * 125 / imageSliders.length) / 100) *
                _scrollController.position.maxScrollExtent */

            curve: Curves.ease,
            duration: const Duration(milliseconds: 100),
          );
          print(_scrollController.toString());
        },
      ),
      items: imageSliders,
    );
  }

  Widget cardSlider(BuildContext context,  List<PuzzleDatum> puzzle,String imagen, Responsive responsive) {
    return Column(
      children: <Widget>[
        SizedBox(
          height: responsive.hp(10),
        ),
        Container(
            height: responsive.hp(45),
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              child: CachedNetworkImage(
                cacheManager: CustomCacheManager(),
                imageUrl: imagen,errorWidget: (context, url, error) => Image(
                  image: AssetImage('assets/carga_fallida.jpg'),
                  fit: BoxFit.cover),
                imageBuilder: (context, imageProvider) => Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.contain,
                  )),
                ),
              ),
            )),SizedBox(
          height: responsive.hp(20),
        ),
            /*  
            _button(context, puzzle, responsive), */
      ],
    );
  }
}
