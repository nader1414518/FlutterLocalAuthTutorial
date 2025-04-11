import 'package:flutter/material.dart';
import 'package:flutter_local_auth_tutorial/controllers/auth_controller.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  Future<void> checkLogin() async {
    try {
      var isLoggedIn = await AuthController.checkLogin();

      if (isLoggedIn) {
        Navigator.of(context).pushReplacementNamed(
          "/home",
        );
      } else {
        Navigator.of(context).pushReplacementNamed(
          "/login",
        );
      }
    } catch (e) {
      print(e.toString());
      Navigator.of(context).pushReplacementNamed(
        "/login",
      );
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    checkLogin();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: Center(
          child: FlutterLogo(
            size: 50,
          ),
        ),
      ),
    );
  }
}
