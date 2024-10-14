import 'package:flutter/material.dart';
import 'dart:async';
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
    this.backAsset = 'assets/card.jpg',
    this.isFaceUp = false,
    this.isMatched = false,
  });

  resetCards() {
    isFaceUp = false;
    isMatched = false;
  }
}

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen>
    with SingleTickerProviderStateMixin {
  final int gridSize = 4;
  final List<CardModel> _cards = [];
  CardModel? _firstCard;
  CardModel? _secondCard;
  bool _isChecking = false;
  bool _isGameComplete = false;
  int _attempts = 0; // Counter for number of attempts
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _initializeCards();
  }

  void _initializeCards() {
    List<String> cardImages = [
      'assets/apple.jpg',
      'assets/banana.jpg',
      'assets/mango.jpg',
      'assets/orange.jpg',
    ];

    cardImages = [...cardImages, ...cardImages];
    cardImages.shuffle(Random());

    _cards.clear();
    for (String asset in cardImages) {
      _cards.add(CardModel(frontAsset: asset));
    }

    _resetGame();
  }

  void _resetGame() {
    setState(() {
      _firstCard = null;
      _secondCard = null;
      _isChecking = false;
      _isGameComplete = false;
      _attempts = 0; // Reset the counter

      for (int i = 0; i < _cards.length; i++) {
        _cards[i].resetCards();
      }

      _cards.shuffle(Random());
    });
  }

  void _onCardTap(int index) {
    if (_isChecking || _cards[index].isFaceUp || _cards[index].isMatched) {
      return;
    }

    setState(() {
      _cards[index].isFaceUp = true;
      if (_firstCard == null) {
        _firstCard = _cards[index];
      } else if (_secondCard == null) {
        _secondCard = _cards[index];
        _attempts++; 
        _checkMatch();
      }
    });
  }

  void _checkMatch() {
    _isChecking = true;
    if (_firstCard!.frontAsset == _secondCard!.frontAsset) {
      setState(() {
        _firstCard!.isMatched = true;
        _secondCard!.isMatched = true;
        _firstCard = null;
        _secondCard = null;
        _isChecking = false;

        if (_cards.every((card) => card.isMatched)) {
          _completeGame();
        }
      });
    } else {
      Future.delayed(const Duration(seconds: 1), () {
        setState(() {
          _firstCard!.isFaceUp = false;
          _secondCard!.isFaceUp = false;
          _firstCard = null;
          _secondCard = null;
          _isChecking = false;
        });
      });
    }
  }

  void _completeGame() {
    _isGameComplete = true;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Congratulations!"),
        content: Text("You completed the game in $_attempts attempts!"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _resetGame();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Memory Game - Flutter'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _resetGame,
          ),
        ],
        backgroundColor: Colors.red,
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Attempts: $_attempts',
                style: const TextStyle(fontSize: 20),
              ),
            ),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(8.0),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: gridSize,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: _cards.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () => _onCardTap(index),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 500),
                      transitionBuilder:
                          (Widget child, Animation<double> animation) {
                        return RotationYTransition(
                          turns: animation,
                          child: child,
                        );
                      },
                      child: SizedBox(
                        width: 80,
                        height: 80,
                        child: _cards[index].isFaceUp || _cards[index].isMatched
                            ? Image.asset(_cards[index].frontAsset,
                                key: ValueKey(_cards[index].frontAsset))
                            : Image.asset(_cards[index].backAsset,
                                key: const ValueKey('back')),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class RotationYTransition extends AnimatedWidget {
  const RotationYTransition({
    super.key,
    required Animation<double> turns,
    this.alignment = Alignment.center,
    this.child,
  }) : super(listenable: turns);

  final Widget? child;
  final Alignment alignment;

  Animation<double> get turns => listenable as Animation<double>;

  @override
  Widget build(BuildContext context) {
    final double angle = turns.value * pi;
    return Transform(
      transform: Matrix4.rotationY(angle),
      alignment: alignment,
      child: child,
    );
  }
}
