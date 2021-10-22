import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:enchiladasapp/src/utils/dialogs.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Auth {
  Auth._internal();

  static Auth get instance => Auth._internal();

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  /* String name;
  String email;
  String imageUrl; */

  User get user {
    //metodo asyncrono que devuelve los datos de firebase
    return (_firebaseAuth.currentUser);
  }

  //Auth von Google
  Future<User> signInWithGoogle(BuildContext context) async {
    ProgressDialog progressDialog = ProgressDialog(context);
    try {
      progressDialog.show();

      final GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      final User user = (await _firebaseAuth.signInWithCredential(credential)).user;
      //print(user.providerData[1].email);
      // print(user.providerData[0].email);
      //assert(user.email != null);
      //assert(user.displayName != null);
      //assert(!user.isAnonymous);
      //assert(await user.getIdToken() != null);

      final User currentUser = _firebaseAuth.currentUser;
      assert(user.uid == currentUser.uid);

      print('firebase client ${user.displayName}');
      return user;

      //progressDialog.dismiss();

    } catch (e) {
      print(e);
      progressDialog.dismiss();
      return null;
    }
  }

  Future<User> facebook(BuildContext context) async {
    ProgressDialog progressDialog = new ProgressDialog(context);
    try {
      progressDialog.show();
      final LoginResult result = await FacebookAuth.instance.login();

      if (result.status == 200) {
        print('Facebook Login OK');

        final userData = await FacebookAuth.instance.getUserData();
        print(userData);

        final AuthCredential credential = FacebookAuthProvider.credential(result.accessToken.token);

        final User user = (await _firebaseAuth.signInWithCredential(credential)).user;
        /* print(user.providerData[1].email);
            print(user.providerData[0].email); */
        //assert(user.email != null);
        /* assert(user.displayName != null);
        assert(!user.isAnonymous);
        assert(await user.getIdToken() != null); */

        final User currentUser = _firebaseAuth.currentUser;
        print(currentUser.email);
        /* assert(user.uid == currentUser.uid); */

        print("Facebook username ${user.displayName}");
        //progressDialog.dismiss();

        return user;
      } else if (result.status == 403) {
        print('Facebook Login cancelled');
        progressDialog.dismiss();
        FacebookAuth.instance.logOut();
        return null;
      } else {
        print('Facebook Login failed');
        FacebookAuth.instance.logOut();
        progressDialog.dismiss();
        return null;
      }
    } catch (e) {
      print(e);
      progressDialog.dismiss();
      FacebookAuth.instance.logOut();
      return null;
    }
  }

  Future<User> signInWithApple(BuildContext context) async {
    ProgressDialog progressDialog = ProgressDialog(context);
    progressDialog.show();
    // 1. perform the sign-in request
    final AuthorizationResult result = await AppleSignIn.performRequests([
      AppleIdRequest(requestedScopes: [Scope.email, Scope.fullName])
    ]);
    // 2. check the result
    switch (result.status) {
      case AuthorizationStatus.authorized:
        print(result.credential.fullName.familyName);
        // Store user ID
        await FlutterSecureStorage().write(key: "userId", value: result.credential.user);

        final appleIdCredential = result.credential;
        final oAuthProvider = OAuthProvider('apple.com');
        final credential = oAuthProvider.credential(
          idToken: String.fromCharCodes(appleIdCredential.identityToken),
          accessToken: String.fromCharCodes(appleIdCredential.authorizationCode),
        );
        final authResult = await _firebaseAuth.signInWithCredential(credential);
        final firebaseUser = authResult.user;
        if (result.credential.fullName.familyName != null && result.credential.fullName.familyName != "") {
          //updateUser.displayName = '${appleIdCredential.fullName.givenName} ${appleIdCredential.fullName.familyName}';
          await _firebaseAuth.currentUser.updateDisplayName('${appleIdCredential.fullName.givenName} ${appleIdCredential.fullName.familyName}');

          final User f = _firebaseAuth.currentUser;
          return f;
        }

        progressDialog.dismiss();
        return firebaseUser;

      case AuthorizationStatus.error:
        print(result.error.toString());
        progressDialog.dismiss();
        throw PlatformException(
          code: 'ERROR_AUTHORIZATION_DENIED',
          message: result.error.toString(),
        );

      case AuthorizationStatus.cancelled:
        progressDialog.dismiss();
        throw PlatformException(
          code: 'ERROR_ABORTED_BY_USER',
          message: 'Sign in aborted by user',
        );
    }
    return null;
  }

  Future<void> logOut(BuildContext context) async {
    final data = (user).providerData;
    String providerId = "firebase";

    for (final provider in data) {
      if (provider.providerId != 'firebase') {
        providerId = provider.providerId;
        break;
      }
    }

    switch (providerId) {
      case "facebook.com":
        await _firebaseAuth.signOut();
        await FacebookAuth.instance.logOut();
        break;
      case "google.com":
        await _firebaseAuth.signOut();
        await _googleSignIn.signOut();
        break;
      case "password":
        break;
      case "phone":
        break;
    }

    await _firebaseAuth.signOut();

    Navigator.pushNamedAndRemoveUntil(context, 'splash', (_) => false);
  }
}
