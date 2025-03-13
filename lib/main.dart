import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: GridScreen(),
    );
  }
}

class GridScreen extends StatefulWidget {
  @override
  _GridScreenState createState() => _GridScreenState();
}

class _GridScreenState extends State<GridScreen> {
  final int rows = 50;
  final int cols = 100;
  List<List<bool>> grid = List.generate(50, (i) => List.generate(100, (j) => false));
  final TextEditingController _controller = TextEditingController();
  String errorMessage = '';

  void toggleCell(String input) {
    setState(() {
      errorMessage = '';
      List<String> parts = input.trim().split(' ');
      for (String part in parts) {
        int? value = int.tryParse(part);
        if (value == null || value > 9999) {
          errorMessage = 'Введіть числа від 0 до 4999';
          return;
        }
        String strValue = value.toString();
        int splitIndex = (strValue.length / 2).ceil();
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
      appBar: AppBar(title: Text('Grid Toggle App')),
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: cols,
              ),
              itemBuilder: (context, index) {
                int x = index ~/ cols;
                int y = index % cols;
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
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextField(
                  controller: _controller,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Введіть число',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () => toggleCell(_controller.text),
                  child: Text('Змінити колір'),
                ),
                if (errorMessage.isNotEmpty)
                  Text(errorMessage, style: TextStyle(color: Colors.red)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}