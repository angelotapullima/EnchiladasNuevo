





import 'package:rxdart/subjects.dart';

class PorcentajesBloc {
  final _porcentajesController = BehaviorSubject<double>();

  Stream<double> get procentajeStream => _porcentajesController.stream;

  Function(double) get changePorcentaje => _porcentajesController.sink.add;

  // Obtener el último valor ingresado a los streams
  double get procentaje => _porcentajesController.value;

  dispose() {
    _porcentajesController?.close();
  }
}
