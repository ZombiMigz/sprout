import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:sprout/auth.dart';
import 'package:sprout/firestore.dart';
import 'package:sprout/plants.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint((FirebaseAuth.instance.currentUser?.uid == null).toString());
    return MaterialApp(
        title: 'Sprout',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: (FirebaseAuth.instance.currentUser?.uid == null)
            ? const Login()
            : const Home());
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _index = 0;

  void _onItemTapped(int index, [bool mounted = true]) async {
    if (index == 2) {
      await signOut();
      if (!mounted) return;
      Navigator.pop(context);
      return;
    }
    setState(() {
      _index = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: Plants(_index == 1)),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.home,
                  color: _index == 0 ? Colors.blue : Colors.black),
              label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite,
                  color: _index == 1 ? Colors.red : Colors.black),
              label: 'Favorites'),
          const BottomNavigationBarItem(
              icon: Icon(Icons.exit_to_app, color: Colors.black),
              label: 'Sign Out')
        ],
        currentIndex: _index,
        onTap: _onItemTapped,
      ),
    );
  }
}
