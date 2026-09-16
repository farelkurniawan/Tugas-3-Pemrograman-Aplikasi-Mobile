import 'package:flutter/material.dart';
class StopwatchScreen extends StatelessWidget {
  const StopwatchScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.black,
      body: Center(child: Text('Stopwatch', style: TextStyle(color: Colors.white, fontSize: 24))),
    );
  }
}