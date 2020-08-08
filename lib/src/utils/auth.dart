import 'package:enchiladasapp/src/utils/dialogs.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Auth {
  Auth._internal();

  static Auth get instance => Auth._internal();

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  /* String name;
  String email;
  String imageUrl; */

  Future<FirebaseUser> get user async {
    //metodo asyncrono que devuelve los datos de firebase
    return (await _firebaseAuth.currentUser());
  }

  //Auth von Google
  Future<FirebaseUser> signInWithGoogle(BuildContext context) async {
    ProgressDialog progressDialog = ProgressDialog(context);
    try {
      progressDialog.show();

      final GoogleSignInAccount googleSignInAccount =
          await _googleSignIn.signIn(); 
              final GoogleSignInAuthentication googleSignInAuthentication =await googleSignInAccount.authentication;

            final AuthCredential credential = GoogleAuthProvider.getCredential(
              accessToken: googleSignInAuthentication.accessToken,
              idToken: googleSignInAuthentication.idToken,
            );
            final FirebaseUser user =
                (await _firebaseAuth.signInWithCredential(credential)).user;
                //print(user.providerData[1].email);
                 // print(user.providerData[0].email);
            //assert(user.email != null);
            //assert(user.displayName != null);
            //assert(!user.isAnonymous);
            //assert(await user.getIdToken() != null);

            final FirebaseUser currentUser = await _firebaseAuth.currentUser();
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

  Future<FirebaseUser> facebook(BuildContext context) async {
    ProgressDialog progressDialog = new ProgressDialog(context);
    try {
      progressDialog.show();
      final LoginResult result = await FacebookAuth.instance.login();

      if (result.status == 200) {
        print('Facebook Login OK');

        final userData = await FacebookAuth.instance.getUserData();
        print(userData);

        final AuthCredential credential = FacebookAuthProvider.getCredential(
            accessToken: result.accessToken.token);

        final FirebaseUser user =
            (await _firebaseAuth.signInWithCredential(credential)).user;
            /* print(user.providerData[1].email);
            print(user.providerData[0].email); */
        //assert(user.email != null);
        /* assert(user.displayName != null);
        assert(!user.isAnonymous);
        assert(await user.getIdToken() != null); */

        final FirebaseUser currentUser = await _firebaseAuth.currentUser();
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

  Future<void> logOut(BuildContext context) async {

    final data = (await user).providerData;
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
