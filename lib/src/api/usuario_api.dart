import 'dart:convert';
import 'package:enchiladasapp/src/database/usuario_database.dart';
import 'package:enchiladasapp/src/models/ruc_model.dart';
import 'package:enchiladasapp/src/models/user.dart';
import 'package:enchiladasapp/src/utils/preferencias_usuario.dart';
import 'package:fluttertoast/fluttertoast.dart'; 
import 'package:http/http.dart' as http;
import 'package:enchiladasapp/src/utils/utilidades.dart' as utils;

//clase para hacer peticiones http con el Modelo User
class UsuarioApi {
  final String _url = 'https://delivery.lacasadelasenchiladas.pe';

  final prefs = new Preferences();

  Future<List<Ruc>> consultarRuc( String numero) async {
    try {
      final list = List<Ruc>();
      Ruc rucs = new Ruc();

      final url = 'https://api.sunat.cloud/ruc/$numero';
      final resp = await http.get(url);
      if (resp.body != "") {
        final decodedData = json.decode(resp.body);

        rucs.ruc = decodedData['ruc'];
        rucs.razonSocial = decodedData['razon_social'];
        rucs.contribuyenteEstado = decodedData['contribuyente_estado'];

        list.add(rucs);
        return list;
      } else {
        return [];
      }
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      utils.showToast(  "Problemas con la conexión a internet",2,ToastGravity.TOP);
      return [];
    }
  }

  Future<bool> login( User user) async {
    try {
      final url = '$_url/api/Login/singInApp';
      String idRel, pName, uEmail, foto;

      if (user.idRel == null) {
        idRel = "";
      } else {
        idRel = user.idRel;
      }

      if (user.personName == null) {
        pName = "";
      } else {
        pName = user.personName;
      }

      if (user.userEmail == null) {
        uEmail = "";
      } else {
        uEmail = user.userEmail;
      }

      if (user.foto == null) {
        foto = "";
      } else {
        foto = user.foto;
      }
      final resp = await http.post(url, body: {
        'id_rel': idRel,
        'person_name': pName,
        'app': 'true',
        'user_image': foto,
        'user_email': uEmail
      });
      

      final decodedData = json.decode(resp.body);
      final code = decodedData['result']['code'];

      print('peticion usuario: ${decodedData['data']}');
      if (code == 1) {
        final usuarioDatabase = UsuarioDatabase();

        final idUser = decodedData['data']['c_u'];
        final idPerson = decodedData['data']['c_p'];
        final token = decodedData['data']['tn'];
        final rol = decodedData['data']['ru'];

        prefs.personName = pName;
        prefs.foto = foto;
        prefs.email = uEmail;
        prefs.token = token;
        prefs.idUser = idUser;
        prefs.rol = rol;

        String dni = "";
        String telefono = "";
        int direccion = 0;
        String idZona='';
        User user = new User();

        user.cU = idUser;
        user.idRel = idRel;
        user.personName = pName;
        user.userEmail = uEmail;
        user.foto = foto;
        user.userEmail = uEmail;
        user.dni = dni;
        user.idDireccion = direccion;
        user.idZona=idZona;
        user.token = token;
        user.telefono = telefono;
        user.cP = idPerson;

        final res = await usuarioDatabase.insertarUsuariosDb(user);

        if (res > 0) {
          return true;
        } else {
          return false;
        }
      } else {
        if (code) {
          return true;
        }
        return false;
      }
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      utils.showToast(  "problemas con la conexión a internet",2,ToastGravity.TOP);
      return false;
    }
    //return true;
  }
}
