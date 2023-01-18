import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sprout/main.dart';

Future<UserCredential?> signIn() async {
  // Trigger the authentication flow
  GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

  // Obtain the auth details from the request
  final GoogleSignInAuthentication? googleAuth =
      await googleUser?.authentication;

  // Create a new credential
  final credential = GoogleAuthProvider.credential(
    accessToken: googleAuth?.accessToken,
    idToken: googleAuth?.idToken,
  );

  return await FirebaseAuth.instance.signInWithCredential(credential);
}

Future<void> signOut() async {
  await GoogleSignIn().signOut();
  await FirebaseAuth.instance.signOut();
}

bool loggedIn() {
  return FirebaseAuth.instance.currentUser?.uid != null;
}

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context, [bool mounted = true]) {
    return Center(
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.only(
                    left: 20, right: 20, top: 10, bottom: 10),
                textStyle: const TextStyle(fontSize: 50)),
            onPressed: () async {
              await signIn();
              if (!mounted) return;
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return const Home();
              }));
            },
            child: const Text("Login")));
  }
}
