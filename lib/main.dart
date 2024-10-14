import 'package:flutter/material.dart';

void main() => runApp(const MemoryGame());

class MemoryGame extends StatelessWidget {
  const MemoryGame({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: GameScreen(),
    );
  }
}

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final int gridSize = 4;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Memory Game'),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(8.0),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: gridSize,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: gridSize * gridSize,
        itemBuilder: (context, index) {
          return Container(
            color: Colors.blue,
          );
        },
      ),
    );
  }
}
