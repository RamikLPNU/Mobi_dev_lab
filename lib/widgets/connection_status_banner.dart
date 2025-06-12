import 'package:flutter/material.dart';

class ConnectionStatusBanner extends StatelessWidget {
  final bool isConnected;

  const ConnectionStatusBanner({required this.isConnected, super.key});

  @override
  Widget build(BuildContext context) {
    if (isConnected) return const SizedBox();

    return Container(
      width: double.infinity,
      color: Colors.red,
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 12),
      child: const Text(
        'Немає Інтернет-з’єднання',
        style: TextStyle(color: Colors.white),
        textAlign: TextAlign.center,
      ),
    );
  }
}
