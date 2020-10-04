import 'package:cached_network_image/cached_network_image.dart';
import 'package:enchiladasapp/src/utils/responsive.dart';
import 'package:enchiladasapp/src/widgets/customCacheManager.dart';
import 'package:flutter/material.dart';
import 'package:page_view_indicators/page_view_indicators.dart';

class OnboardingPage extends StatelessWidget {
  final _pageController = PageController();
  final _currentPageNotifier = ValueNotifier<int>(0);

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);
    return Scaffold(
      body: Stack(
        children: <Widget>[
          _buildPageView(responsive),
          _buildCircleIndicator(responsive),
        ],
      ),
    );
  }

  _buildPageView(Responsive responsive) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
        color: Colors.transparent,
      ),
      height: double.infinity,
      child: PageView.builder(
          itemCount: 3,
          controller: _pageController,
          itemBuilder: (BuildContext context, int index) {
            return _contenido(responsive);
          },
          onPageChanged: (int index) {
            _currentPageNotifier.value = index;
          }),
    );
  }

  Widget _contenido(Responsive responsive) {
    return Column(
      children: <Widget>[
        Container(
          height: responsive.hp(50),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: CachedNetworkImage(
              cacheManager: CustomCacheManager(),
              placeholder: (context, url) => Image(
                  image: AssetImage('assets/jar-loading.gif'),
                  fit: BoxFit.cover),
              errorWidget: (context, url, error) => Icon(Icons.error),
              imageUrl:
                  'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTZMIdLgIaSPfiyocXpPCv-NKMO67P1G9gsvg&usqp=CAU',
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
        Padding(
          padding: EdgeInsets.symmetric(horizontal: responsive.wp(5)),
          child: Text(
            'Selecciones pedidos de nuestra carta ',
            style: TextStyle(fontSize: responsive.ip(3)),
          ),
        )
      ],
    );
  }

  _buildCircleIndicator(Responsive responsive) {
    return Positioned(
      left: 0.0,
      right: 0.0,
      bottom: responsive.hp(3.2),
      child: CirclePageIndicator(
        selectedDotColor: Colors.black,
        dotColor: Colors.red,
        itemCount: 3,
        currentPageNotifier: _currentPageNotifier,
      ),
    );
  }
}
