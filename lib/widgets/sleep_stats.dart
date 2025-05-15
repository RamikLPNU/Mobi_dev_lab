import 'package:flutter/material.dart';

class SleepStats extends StatelessWidget {
  const SleepStats({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('Sleep Quality', style: TextStyle(fontSize: 24)),
        const SizedBox(height: 20),
        Container(
          width: 200,
          height: 200,
          color: Colors.deepPurple.shade100,
          child: const Center(child: Text('Graph Placeholder')),
        ),
        const SizedBox(height: 20),
        const Text('You slept 7h 45m'),
      ],
    );
  }
}
