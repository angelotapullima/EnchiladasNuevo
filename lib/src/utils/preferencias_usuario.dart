import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  static final Preferences _instancia = new Preferences._internal();

  factory Preferences() {
    return _instancia;
  }

  SharedPreferences _prefs;

  Preferences._internal();

  initPrefs() async {
    this._prefs = await SharedPreferences.getInstance();
  }

  clearPreferences() async {
    await _prefs.clear();
  }

//sirve para obtener el id producto de la bolsa
  get idBolsa {
    return _prefs.getString('idBolsa');
  }

  set idBolsa(String value) {
    _prefs.setString('idBolsa', value);
  }

//sirve para obtener el id producto de la bolsa
  get idTupper {
    return _prefs.getString('idTupper');
  }

  set idTupper(String value) {
    _prefs.setString('idTupper', value);
  }

  //sirve para verificar el estado de la primera carga
  get estadoCargaInicial {
    return _prefs.getString('estadoCarga');
  }

  set estadoCargaInicial(String value) {
    _prefs.setString('estadoCarga', value);
  }

  get personName {
    return _prefs.getString('personName');
  }

  set personName(String value) {
    _prefs.setString('personName', value);
  }

  get foto {
    return _prefs.getString('foto');
  }

  set foto(String value) {
    _prefs.setString('foto', value);
  }

  get email {
    return _prefs.getString('email');
  }

  set email(String value) {
    _prefs.setString('email', value);
  }

  get token {
    return _prefs.getString('token');
  }

  set token(String value) {
    _prefs.setString('token', value);
  }

  get idUser {
    return _prefs.getString('idUser');
  }

  set idUser(String value) {
    _prefs.setString('idUser', value);
  }

  get rol {
    return _prefs.getString('rol');
  }

  set rol(String value) {
    _prefs.setString('rol', value);
  }

  get propinaRepartidor {
    return _prefs.getString('propinaRepartidor');
  }

  set propinaRepartidor(String value) {
    _prefs.setString('propinaRepartidor', value);
  }

//sirve para obtener si las categorias estan desplegadas o unidas
//Categorias  desplegadas = 1:
//Salon = 1
//Cafe = 3
//VAR  = 4
//
//Categorias Unidas = 2:
//Salon = 5
//Cafe = 6
//VAR  = 7
  get tipoCategoria {
    return _prefs.getString('tipoCategoria');
  }

  set tipoCategoria(String value) {
    _prefs.setString('tipoCategoria', value);
  }


//Categorias  Numeros:
//Salon = 1
//Cafe = 3
//VAR  = 4
//Salon(delivery) = 5
//Cafe (delivery) = 6
//VAR  (delivery) = 7
  get tipoCategoriaNumero {
    return _prefs.getString('tipoCategoriaNumero');
  }

  set tipoCategoriaNumero(String value) {
    _prefs.setString('tipoCategoriaNumero', value);
  }
}