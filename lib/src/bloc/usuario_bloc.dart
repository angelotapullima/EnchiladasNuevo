import 'package:enchiladasapp/src/database/usuario_database.dart';
import 'package:enchiladasapp/src/models/user.dart';
import 'package:rxdart/rxdart.dart';

class UsuarioBloc {
  final usuarioDatabase = UsuarioDatabase();

  final _usuaroController = new BehaviorSubject<List<User>>();

  Stream<List<User>> get usuarioStream => _usuaroController.stream;

  dispose() {
    _usuaroController?.close();
  }

  void obtenerUsuario() async {
    _usuaroController.sink.add(await usuarioDatabase.obtenerUsUario());
  }
}
