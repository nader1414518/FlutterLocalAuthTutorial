import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      child: Scaffold(
        body: Center(
          child: Text(
            "Home",
            style: TextStyle(fontSize: 24),
          ),
        ),
      ),
    );
  }
}
