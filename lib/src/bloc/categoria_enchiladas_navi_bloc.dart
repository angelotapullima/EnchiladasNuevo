import 'package:rxdart/subjects.dart';

class EnchiladasNaviBloc{


  final _enchiladasPageController = BehaviorSubject<String>();

  Stream<String> get enchiladasIndexStream    => _enchiladasPageController.stream;

  Function(String) get changeIndexPage    => _enchiladasPageController.sink.add;


  // Obtener el último valor ingresado a los streams
  String get index   => _enchiladasPageController.value;

  dispose() {
    _enchiladasPageController?.close();
  }
}