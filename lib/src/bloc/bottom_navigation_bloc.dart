

import 'package:rxdart/rxdart.dart';

class BottomNaviBloc { 

  final _selectPageController = BehaviorSubject<int>();

  Stream<int> get selectPageStream    => _selectPageController.stream;

  Function(int) get changePage    => _selectPageController.sink.add; 


  // Obtener el último valor ingresado a los streams
  int get page   => _selectPageController.value; 

  dispose() {
    _selectPageController?.close(); 
  }
}