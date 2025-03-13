import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: GridScreen(),
    );
  }
}

class GridScreen extends StatefulWidget {
  const GridScreen({super.key});
  @override
  GridScreenState createState() => GridScreenState();
}

class GridScreenState extends State<GridScreen> {
  final int rows = 50;
  final int cols = 100;
  List<List<bool>> grid = List.generate(
    50,
    (i) => List.generate(100, (j) => false),
  );
  final TextEditingController _controller = TextEditingController();
  String errorMessage = '';

  void toggleCell(String input) {
    setState(() {
      errorMessage = '';
      final List<String> parts = input.trim().split('0');
      for (String part in parts) {
        final int? value = int.tryParse(part);
        if (value == null || value > 9999) {
          errorMessage = 'Введіть числа від 0 до 4999';
          return;
        }
        final String strValue = value.toString();
        final int splitIndex = (strValue.length / 2).ceil();
        int x, y;
        if (strValue.length == 1) {
          y = 0;
          x = value;
        } else {
          x = int.parse(strValue.substring(0, splitIndex));
          y = int.parse(strValue.substring(splitIndex));
        }

        if (x >= rows || y >= cols) {
          errorMessage = 'Координати виходять за межі rows=$x, cols=$y';
          return;
        }
        grid[x][y] = !grid[x][y];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Grid Toggle App')),
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: cols,
              ),
              itemBuilder: (context, index) {
                final int x = index ~/ cols;
                final int y = index % cols;
                return Container(
                  decoration: BoxDecoration(
                    color: grid[x][y] ? Colors.black : Colors.white,
                    border: Border.all(color: Colors.grey, width: 0.5),
                  ),
                );
              },
              itemCount: rows * cols,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                TextField(
                  controller: _controller,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Введіть число',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () => toggleCell(_controller.text),
                  child: const Text('Змінити колір'),
                ),
                if (errorMessage.isNotEmpty)
                  Text(errorMessage, style: const TextStyle(color: Colors.red)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
