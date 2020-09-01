import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:enchiladasapp/src/bloc/provider.dart';
import 'package:enchiladasapp/src/models/user.dart';
import 'package:enchiladasapp/src/utils/dialogs.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:enchiladasapp/src/utils/auth.dart';
import 'package:enchiladasapp/src/utils/responsive.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void initState() {
    super.initState();
    checkLoggedInState();

    AppleSignIn.onCredentialRevoked.listen((_) {
      print("Credentials revoked");
    });
  }

  void checkLoggedInState() async {
    final userId = await FlutterSecureStorage().read(key: "userId");
    if (userId == null) {
      print("No stored user ID");
      return;
    }

    final credentialState = await AppleSignIn.getCredentialState(userId);
    switch (credentialState.status) {
      case CredentialStatus.authorized:
        print("getCredentialState returned authorized");
        break;

      case CredentialStatus.error:
        print(
            "getCredentialState returned an error: ${credentialState.error.localizedDescription}");
        break;

      case CredentialStatus.revoked:
        print("getCredentialState returned revoked");
        break;

      case CredentialStatus.notFound:
        print("getCredentialState returned not found");
        break;

      case CredentialStatus.transferred:
        print("getCredentialState returned not transferred");
        break;
    }
  }

  bool isLoggedIn = false;

  LoginBloc loginBloc;
  User usuario = new User();

  void goto(
      BuildContext context, FirebaseUser user, LoginBloc loginBloc) async {
    ProgressDialog progressDialog = new ProgressDialog(context);
    progressDialog.show();
    String email;
    if (user != null) {
      usuario.personName = user.displayName;
      usuario.idRel = user.uid;
      usuario.foto = user.photoUrl;

      final listaDecuentas = user.providerData.length;

      for (int i = 0; i < listaDecuentas; i++) {
        if (user.providerData[i].email != null) {
          email = user.providerData[i].email;
        }
      }

      usuario.userEmail = email;

      final correcto = await loginBloc.login(usuario);
      if (correcto) {
        progressDialog.dismiss();
        //Navigator.pushReplacementNamed(context, '/');
        Navigator.pushReplacementNamed(context, 'desicion');
      } else {
        print('hubo un error');
        progressDialog.dismiss();
      }
    } else {
      Navigator.pushReplacementNamed(context, 'splash');
      print('login failed');
      progressDialog.dismiss();
    }
  }

  @override
  Widget build(BuildContext context) {
    final Responsive responsive = Responsive.of(context);
    final blocLogin = ProviderBloc.of(context);

    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            decoration: new BoxDecoration(
              color: Colors.black12,
              image: new DecorationImage(
                image: new ExactAssetImage('assets/ladrillos.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          _columDatos(context, responsive, blocLogin),
        ],
      ),
    );
  }

  Widget _columDatos(
      BuildContext context, Responsive responsive, LoginBloc loginBloc) {
    final appleSignInAvailable =
        Provider.of<AppleSignInAvailable>(context, listen: false);
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: responsive.ip(5)),
        child: Column(
          children: <Widget>[
            SizedBox(
              height: responsive.ip(8),
            ),
            Container(
              height: responsive.ip(30),
              decoration: new BoxDecoration(
                color: Colors.black12,
                image: new DecorationImage(
                  image: new ExactAssetImage('assets/logo_enchilada.png'),
                  fit: BoxFit.contain,
                ),
              ),
            ),
            SizedBox(
              height: responsive.ip(1.8),
            ),
            Text('BIENVENIDO A \n LA CASA DE LAS ENCHILADAS',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: responsive.ip(2.7),
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center),
            SizedBox(
              height: responsive.ip(2),
            ),
            Text(
              'Por aquí podrás disfrutar lo mejor de lo nuestro de forma más rápida',
              style: TextStyle(
                color: Colors.white,
                fontSize: responsive.ip(1.6),
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: responsive.ip(2),
            ),
            GestureDetector(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: EdgeInsets.all(
                  responsive.ip(1),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Iniciar con Facebook',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: responsive.ip(2),
                      ),
                    ),
                    SizedBox(
                      width: responsive.ip(1.2),
                    ),
                    Icon(
                      FontAwesomeIcons.facebook,
                      color: Colors.white,
                      size: responsive.ip(2.5),
                    )
                  ],
                ),
              ),
              onTap: () async {
                final user = await Auth.instance.facebook(context);
                goto(context, user, loginBloc);
              },
            ),
            SizedBox(
              height: responsive.ip(1),
            ),
            GestureDetector(
              child: Container(
                padding: EdgeInsets.all(responsive.ip(1)),
                decoration: BoxDecoration(
                    color: Colors.red, borderRadius: BorderRadius.circular(8)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Iniciar con Google',
                      style: TextStyle(
                          color: Colors.white, fontSize: responsive.ip(2)),
                    ),
                    SizedBox(
                      width: responsive.ip(1.2),
                    ),
                    Icon(
                      FontAwesomeIcons.google,
                      color: Colors.white,
                      size: responsive.ip(2.5),
                    )
                  ],
                ),
              ),
              onTap: () async {
                final user = await Auth.instance.signInWithGoogle(context);
                goto(context, user, loginBloc);
              },
            ),
            SizedBox(height: responsive.ip(1)),
            (appleSignInAvailable.isAvailable)
                ? AppleSignInButton(
                    style: ButtonStyle.black, // style as needed
                    type: ButtonType.signIn, // style as needed
                    onPressed: () async {
                      final user = await Auth.instance.signInWithApple(context);
                      goto(context, user, loginBloc);
                    },
                  )
                : Container(),
            Expanded(
              child: Container(),
            ),
            CupertinoButton(
              child: Text('Iniciar sesión luego',
                  style: TextStyle(
                      color: Colors.white, fontSize: responsive.ip(2))),
              onPressed: () {
                Navigator.pushReplacementNamed(context, 'desicion');
              },
            ),
            SizedBox(
              height: responsive.ip(4),
            )
          ],
        ),
      ),
    );
  }
}

class AppleSignInAvailable {
  AppleSignInAvailable(this.isAvailable);
  final bool isAvailable;

  static Future<AppleSignInAvailable> check() async {
    return AppleSignInAvailable(await AppleSignIn.isAvailable());
  }
}
