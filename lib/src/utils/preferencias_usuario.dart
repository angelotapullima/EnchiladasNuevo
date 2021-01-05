

import 'package:shared_preferences/shared_preferences.dart';

class Preferences {


  static final Preferences _instancia = new Preferences._internal();

  factory Preferences(){
    return _instancia;
  }

  SharedPreferences _prefs ;

  Preferences._internal();

  initPrefs()async {
  this._prefs = await SharedPreferences.getInstance() ;

  }

  clearPreferences()async{
    await  _prefs.clear();
  }


//sirve para obtener el id producto de la bolsa
  get idBolsa{
    return _prefs.getString('idBolsa');
  }

  set idBolsa(String value){

    _prefs.setString('idBolsa', value);
  }



//sirve para obtener el id producto de la bolsa
  get idTupper{
    return _prefs.getString('idTupper');
  }

  set idTupper(String value){

    _prefs.setString('idTupper', value);
  }

  //sirve para verificar el estado de la primera carga
  get estadoCargaInicial{
    return _prefs.getString('estadoCarga');
  }

  set estadoCargaInicial(String value){

    _prefs.setString('estadoCarga', value);
  }





//pantalla para seleccionar si es market o enchiladas
  get pantallaCuenta{
    return _prefs.getString('pantallaCuenta');
  }

  set pantallaCuenta(String value){

    _prefs.setString('pantallaCuenta', value);
  }




//pantalla para seleccionar si es market o enchiladas
  get pantallaDPago{
    return _prefs.getString('pantallaDPago');
  }

  set pantallaDPago(String value){

    _prefs.setString('pantallaDPago', value);
  }



//pantalla para seleccionar si es market o enchiladas
  get pantallaDProducto{
    return _prefs.getString('pantallaDProducto');
  }

  set pantallaDProducto(String value){

    _prefs.setString('pantallaDProducto', value);
  }



  //pantalla para seleccionar si es market o enchiladas
  get pantallaCategoria{
    return _prefs.getString('pantallaCategoria');
  }

  set pantallaCategoria(String value){

    _prefs.setString('pantallaCategoria', value);
  }



  //pantalla para seleccionar si es market o enchiladas
  get pantallaSeleccion{
    return _prefs.getString('pantallaSeleccion');
  }

  set pantallaSeleccion(String value){

    _prefs.setString('pantallaSeleccion', value);
  }

  get personName{
    return _prefs.getString('personName');
  }

  set personName(String value){
    _prefs.setString('personName', value);
  }
  get foto{
    return _prefs.getString('foto');
  }

  set foto(String value){
    _prefs.setString('foto', value);
  }
  get email{
    return _prefs.getString('email');
  }

  set email(String value){
    _prefs.setString('email', value);
  }
  

  get token{
    return _prefs.getString('token');
  }

  set token(String value){
    _prefs.setString('token', value);
  }
  get idUser{
    return _prefs.getString('idUser');
  }

  set idUser(String value){
    _prefs.setString('idUser', value);
  }

  get rol{
    return _prefs.getString('rol');
  }

  set rol(String value){
    _prefs.setString('rol', value);
  }



get propinaRepartidor{
    return _prefs.getString('propinaRepartidor');
  }

  set propinaRepartidor(String value){
    _prefs.setString('propinaRepartidor', value);
  }

}