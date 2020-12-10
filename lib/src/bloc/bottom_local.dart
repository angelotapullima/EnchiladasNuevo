


import 'package:rxdart/rxdart.dart';

class BottomLocalBloc { 

  final _selectPageLocalController = BehaviorSubject<int>();

  Stream<int> get selectPageLocalStream    => _selectPageLocalController.stream;

  Function(int) get changePageLocal    => _selectPageLocalController.sink.add; 


  // Obtener el último valor ingresado a los streams
  int get pageLocal   => _selectPageLocalController.value; 

  dispose() {
    _selectPageLocalController?.close(); 
  }
}