
import 'package:rxdart/rxdart.dart';

class MarketNaviBloc {

  final _indexPageController = BehaviorSubject<String>();

  Stream<String> get indexStream    => _indexPageController.stream;

  Function(String) get changeIndexPage    => _indexPageController.sink.add;


  // Obtener el último valor ingresado a los streams
  String get index   => _indexPageController.value;

  dispose() {
    _indexPageController?.close();
  }
}