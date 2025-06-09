import 'package:flutter/material.dart';

class SleepInputButtons extends StatelessWidget {
  final VoidCallback onSleep;
  final VoidCallback onWake;

  const SleepInputButtons({
    required this.onSleep,
    required this.onWake,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(onPressed: onSleep, child: const Text('Ліг спати')),
        ElevatedButton(onPressed: onWake, child: const Text('Прокинувся')),
      ],
    );
  }
}
