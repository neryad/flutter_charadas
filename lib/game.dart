import 'dart:math';

import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';

class Game extends StatefulWidget {
  const Game({super.key});

  @override
  State<Game> createState() => _GameState();
}

class _GameState extends State<Game> {
  List<String> words = [
    'Flutter',
    'Dart',
    'Javascript',
    'Hot Dog',
    'juego',
    'Pizza'
  ];

  String currentWord = '';
  double angle = 0;
  Color backGroundColor = Colors.white;
  int score = 0;
  bool canAnswer = true;

  @override
  void initState() {
    // TODO: implement initState

    selectRandomWord();
    startSensors();
  }

  void selectRandomWord() {
    setState(() {
      currentWord = words[Random().nextInt(words.length)];
      backGroundColor = Colors.white;
      angle = 0;
      canAnswer = true;
    });
  }

  void startSensors() {
    gyroscopeEventStream().listen((GyroscopeEvent event) {
      if (!canAnswer) {
        return;
      }

      if (event.y > 2.5) {
        setState(() {
          angle = 90;
          backGroundColor = Colors.green;
          canAnswer = false;
          score++;
        });
        Future.delayed(Duration(seconds: 1), () {
          selectRandomWord();
        });
      } else if (event.y < -2.5) {
        setState(() {
          angle = -90;
          backGroundColor = Colors.red;
          canAnswer = false;
        });
        Future.delayed(Duration(seconds: 1), () {
          selectRandomWord();
        });
      } else if (event.y >= -0.5 && event.y <= 0.5) {
        setState(() {
          angle = 0;
          backGroundColor = Colors.white;
          canAnswer = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backGroundColor,
      appBar: AppBar(
        title: Text('Charadas - score: $score'),
      ),
      body: Center(
        child: Row(
          children: [
            AnimatedContainer(
              color: backGroundColor,
              duration: Duration(seconds: 1),
              transform: Matrix4.rotationZ(angle * 3.1416 / 180),
              child: Text(
                currentWord,
                style: TextStyle(fontSize: 30),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
