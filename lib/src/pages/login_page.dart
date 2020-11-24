import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:enchiladasapp/src/bloc/provider.dart';
import 'package:enchiladasapp/src/models/user.dart';
import 'package:enchiladasapp/src/utils/dialogs.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:enchiladasapp/src/utils/auth.dart';
import 'package:enchiladasapp/src/utils/responsive.dart';
import 'package:flutter/material.dart';
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
            (appleSignInAvailable.isAvailable)
                ? InkWell(
                    child: Container(
                      padding: EdgeInsets.all(
                        responsive.ip(1),
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                        
                          Padding(
                            padding: const EdgeInsets.only(
                                bottom: 1, left: 6, right: 2),
                            child: SizedBox(
                              height: responsive.ip(2.5),
                              child: AspectRatio(
                                aspectRatio: 25 / 31,
                                child: CustomPaint(
                                  painter:
                                      _AppleLogoPainter(color: Colors.black),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: responsive.ip(1.2),
                          ),
                          Text(
                            'Acceder con Apple',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: responsive.ip(2)),
                          ),
                        ],
                      ),
                    ),
                    onTap: () async {
                      final user =
                          await Auth.instance.signInWithApple(context);
                      goto(context, user, loginBloc);
                    },
                  )
                : Container(),
            SizedBox(
              height: responsive.ip(1),
            ),
            
            
            InkWell(
              child: Container(
                padding: EdgeInsets.all(
                  responsive.ip(1),
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Row(

                        mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                   
                    Image.asset(
                      'assets/google.png',
                      width: responsive.ip(3),
                    ),
                    SizedBox(
                      width: responsive.ip(1.2),
                    ),
                    Text(
                      'Acceder con Google',
                            textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Roboto',fontSize: responsive.ip(2),
                        color: Color.fromRGBO(68, 68, 76, .8),
                      ),
                    ),
                    /* Text(
                      'Acceder con Google',
                      style: TextStyle(
                          color: Colors.black.withOpacity(.54),
                          fontSize: responsive.ip(2)),
                    ), */
                  ],
                ),
              ),
              onTap: () async {
                final user = await Auth.instance.signInWithGoogle(context);
                goto(context, user, loginBloc);
              },
            ),SizedBox(
              height: responsive.ip(1),
            ),
            InkWell(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(5),
                ),
                padding: EdgeInsets.all(
                  responsive.ip(1),
                ),
                child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    
                    Icon(
                      FontAwesomeIcons.facebook,
                      color: Colors.white,
                      size: responsive.ip(2.5),
                    ),
                    SizedBox(
                      width: responsive.ip(1.2),
                    ),
                    Text(
                      'Acceder con Facebook',
                            textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: responsive.ip(2),
                      ),
                    ),
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

  Widget button(title, uri, [color = const Color.fromRGBO(68, 68, 76, .8)]) {
    return Container(
      width: 260.0,
      child: Center(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              uri,
              width: 25.0,
            ),
            Padding(
              child: Text(
                "Sign in with $title",
                style: TextStyle(
                  fontFamily: 'Roboto',
                  color: color,
                ),
              ),
              padding: new EdgeInsets.only(left: 15.0),
            ),
          ],
        ),
      ),
    );
  }
}

class _AppleLogoPainter extends CustomPainter {
  final Color color;

  _AppleLogoPainter({@required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    canvas.drawPath(_getApplePath(size.width, size.height), paint);
  }

  static Path _getApplePath(double w, double h) {
    return Path()
      ..moveTo(w * .50779, h * .28732)
      ..cubicTo(
          w * .4593, h * .28732, w * .38424, h * .24241, w * .30519, h * .24404)
      ..cubicTo(
          w * .2009, h * .24512, w * .10525, h * .29328, w * .05145, h * .36957)
      ..cubicTo(w * -.05683, h * .5227, w * .02355, h * .74888, w * .12916,
          h * .87333)
      ..cubicTo(w * .18097, h * .93394, w * .24209, h * 1.00211, w * .32313,
          h * .99995)
      ..cubicTo(w * .40084, h * .99724, w * .43007, h * .95883, w * .52439,
          h * .95883)
      ..cubicTo(w * .61805, h * .95883, w * .64462, h * .99995, w * .72699,
          h * .99833)
      ..cubicTo(
          w * .81069, h * .99724, w * .86383, h * .93664, w * .91498, h * .8755)
      ..cubicTo(
          w * .97409, h * .80515, w * .99867, h * .73698, w * 1, h * .73319)
      ..cubicTo(w * .99801, h * .73265, w * .83726, h * .68233, w * .83526,
          h * .53082)
      ..cubicTo(
          w * .83394, h * .4042, w * .96214, h * .3436, w * .96812, h * .34089)
      ..cubicTo(
          w * .89505, h * .25378, w * .78279, h * .24404, w * .7436, h * .24187)
      ..cubicTo(
          w * .6413, h * .23538, w * .55561, h * .28732, w * .50779, h * .28732)
      ..close()
      ..moveTo(w * .68049, h * .15962)
      ..cubicTo(w * .72367, h * .11742, w * .75223, h * .05844, w * .74426, 0)
      ..cubicTo(w * .68249, h * .00216, w * .60809, h * .03355, w * .56359,
          h * .07575)
      ..cubicTo(w * .52373, h * .11309, w * .48919, h * .17315, w * .49849,
          h * .23051)
      ..cubicTo(w * .56691, h * .23484, w * .63732, h * .20183, w * .68049,
          h * .15962)
      ..close();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class AppleSignInAvailable {
  AppleSignInAvailable(this.isAvailable);
  final bool isAvailable;

  static Future<AppleSignInAvailable> check() async {
    return AppleSignInAvailable(await AppleSignIn.isAvailable());
  }
}
