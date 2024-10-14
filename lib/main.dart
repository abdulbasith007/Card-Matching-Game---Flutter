import 'package:flutter/material.dart';
import 'dart:math';

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

class CardModel {
  final String frontAsset;
  final String backAsset;
  bool isFaceUp;
  bool isMatched;

  CardModel({
    required this.frontAsset,
    this.backAsset = 'assets/profile.jpeg',
    this.isFaceUp = false,
    this.isMatched = false,
  });
}

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen>
    with SingleTickerProviderStateMixin {
  final int gridSize = 4;
  final List<CardModel> _cards = [];
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
  }

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
          return GestureDetector(
            onTap: () {},
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Transform(
                  transform: Matrix4.rotationY(_controller.value * pi),
                  alignment: Alignment.center,
                  child: Container(
                    color: Colors.blue,
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
