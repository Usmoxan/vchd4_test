import 'package:flutter/material.dart';
import 'package:vchd4_test/quiz.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FilledButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    const Quiz(),
              ),
            );
          },
          child: const Text("BOSHLASH"),
        ),
      ),
    );
  }
}
