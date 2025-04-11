import 'package:flutter/material.dart';
import 'package:flutter_local_auth_tutorial/screens/authentication/login_screen.dart';
import 'package:flutter_local_auth_tutorial/screens/generic/home_screen.dart';
import 'package:flutter_local_auth_tutorial/screens/generic/welcome_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    print(e.toString());
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Local Auth Demo',
      theme: ThemeData.dark(),
      initialRoute: "/",
      routes: {
        "/": (_) => const WelcomeScreen(),
        "/login": (_) => const LoginScreen(),
        "/home": (_) => const HomeScreen(),
      },
    );
  }
}
