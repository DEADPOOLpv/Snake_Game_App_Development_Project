import 'package:SnakeGame/email_check.dart';
import 'package:SnakeGame/googlelogin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/cupertino.dart';


class AuthService
{
  handleAuthState()
  {
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (BuildContext context, snapshot)
        {
          if (snapshot.hasData)
          {
            print('signed in');
            return EmailPage();
          }
          else
          {
            print(" not Signed in");
            return const LoginPage();
          }
        }
    );
  }

  signInWithGoogle() async
  {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn(
        scopes: <String>["email"]).signIn();

    //Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth = await googleUser!
        .authentication;

    //Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    //Once signed in, return the users credentials
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  //SignOut
  signOut()
  {
    FirebaseAuth.instance.signOut();
  }
}