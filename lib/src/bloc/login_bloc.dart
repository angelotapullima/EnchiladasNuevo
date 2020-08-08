

import 'package:enchiladasapp/src/api/usuario_api.dart';
import 'package:enchiladasapp/src/models/user.dart';
import 'package:rxdart/rxdart.dart';

class LoginBloc{

  //inicializamos un Controller con RxDart
  final _loginController = new BehaviorSubject<List<User>>(); 

  //llamamor la Clase UserProvider para usar http
  final _userProvider    = new UsuarioApi();

  //Stream que escucha cambios 
  Stream<List<User>> get loginStream => _loginController.stream; 

  Future<bool> login(User user)async{

    //_userProvider.login se encarga de hacer la peticion http 
    final resul = await _userProvider.login(user);
    return resul;
  }

  //el método dispose es para cerrar la instancia del controlador
  dispose() {
    _loginController?.close(); 
  }
}