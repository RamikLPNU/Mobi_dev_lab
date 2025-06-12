import 'package:flutter/material.dart';

class DeviceConnectionSection extends StatelessWidget {
  final bool isDeviceConnected;
  final String currentState;
  final VoidCallback onConnect;

  const DeviceConnectionSection({
    required this.isDeviceConnected,
    required this.currentState,
    required this.onConnect,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ElevatedButton(onPressed: onConnect, child: const Text
          ('Підключити годинник'),
        ),
        const SizedBox(height: 8),
        Text(
          isDeviceConnected ? 'Годинник підключено' : 'Годинник не підключено',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text('Статус: $currentState', style: const TextStyle(fontSize: 18)),
        const SizedBox(height: 20),
      ],
    );
  }
}
