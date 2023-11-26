import 'package:countrysidecart/screens/Auth/login.dart';
import 'package:countrysidecart/screens/Auth/signup_screen.dart';
import 'package:countrysidecart/screens/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'constants/shared_prefs.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool? isloggedin = false;
  @override
  void initState() {
    // getuserLoggedinStatus();
    super.initState();
  }

  getuserLoggedinStatus() async {
    SHP.getUserLoggedinStatusSP().then((value) {
      setState(() {
        isloggedin = value;
      });
    });

    if (isloggedin == null) {
      setState(() {
        isloggedin = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Countryside Cart',
        theme: ThemeData(
          brightness: Brightness.dark,
          primarySwatch: Colors.cyan,
        ),
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return LoginScreen();
            }

            return const Home();
          },
        ));
  }
}
