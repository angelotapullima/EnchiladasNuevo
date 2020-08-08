
import 'package:flutter/material.dart';

class PaginacionCategoria with ChangeNotifier{

  String _currentIndex = '1';

  String get currentIndex => this._currentIndex;

  set currentIndex (String currentIndex){
    this._currentIndex = currentIndex;
    notifyListeners();
  }


   /* AnimationController _bounceController;

  AnimationController get bounceController =>this._bounceController;

  set bounceController(AnimationController controller){
    this._bounceController = controller;
    notifyListeners();
  } */
}

