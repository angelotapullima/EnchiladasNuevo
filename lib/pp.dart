

import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';/* 
import 'package:sign_in_with_apple/sign_in_with_apple.dart'; */

class Peru extends StatefulWidget {
  @override _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<Peru> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign up with Apple ID'),
      ),
      body: Center(
        /* child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Platform.isIOS ? Padding(
              padding: const EdgeInsets.all(18.0),
              child: SignInWithAppleButton(
                onPressed: () async {
                  final appleIdCredential = await SignInWithApple.getAppleIDCredential(
                    scopes: [
                      AppleIDAuthorizationScopes.email,
                      AppleIDAuthorizationScopes.fullName,
                    ],
                  );
                  final oAuthProvider = OAuthProvider(providerId: 'apple.com');
                  final credential = oAuthProvider.getCredential(
                    idToken: appleIdCredential.identityToken,
                    accessToken: appleIdCredential.authorizationCode,
                  );
                  await FirebaseAuth.instance.signInWithCredential(credential);
                  print(credential);
                },
              ),
            ) : Text('It is android.'),

            //youtubePromotion()
          ],
        ), */
      ),
    );
  }
}