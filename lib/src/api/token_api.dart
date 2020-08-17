import 'dart:convert';

import 'package:enchiladasapp/src/database/usuario_database.dart';
import 'package:enchiladasapp/src/models/user.dart';
import 'package:http/http.dart' as http;

class TokenApi {
  final usuarioDatabase = UsuarioDatabase();
  final String _url = 'https://delivery.lacasadelasenchiladas.pe';
  Future<bool> enviarToken(String token) async {
    final List<User> user = await usuarioDatabase.obtenerUsUario();
    if (user.length > 0) {
      final url = '$_url/api/login/token';
      final resp =
          await http.post(url, body: {'id_user': user[0].cU, 'token': token});

      final decodedData = json.decode(resp.body);

      print('token $decodedData');
      if (decodedData['result']['code'] == 1) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }
}
