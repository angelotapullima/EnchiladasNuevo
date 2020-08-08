

import 'package:flutter/cupertino.dart';
import 'dart:math' as math;

class Responsive{

  final double width, height, inch;

  //clase para hacer Responsive las Pantallas
  Responsive({
    this.width, 
    this.height, 
    this.inch,
    });

  factory Responsive.of(BuildContext context){
    final MediaQueryData data = MediaQuery.of(context);
    final size = data.size;

    final inch = math.sqrt(math.pow(size.width, 2) + math.pow(size.height, 2) );
    return Responsive(width: size.width,height: size.height ,inch: inch);
  }

  //ancho de la pantalla
  double wp(double percent){
    return this.width*percent/100;
  }

  //alto de la pantalla
  double hp(double percent){
    return this.height*percent/100;
  }

  //inch o diagonal del ratio de pantalla
  double ip(double percent){
    return this.inch*percent/100;
  }
}