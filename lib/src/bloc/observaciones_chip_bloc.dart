




import 'package:rxdart/rxdart.dart';

class ObservacionesChipBloc { 

  final _chipController = BehaviorSubject<int>();

  Stream<int> get chipStream    => _chipController.stream;

  Function(int) get changeChip   => _chipController.sink.add; 


  // Obtener el último valor ingresado a los streams
  int get chip   => _chipController.value; 

  dispose() {
    _chipController?.close(); 
  }
}