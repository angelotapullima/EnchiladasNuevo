

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

  get tracking{
    return _prefs.getString('tracking');
  }

  set tracking(String value){
    _prefs.setString('tracking', value);
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

}