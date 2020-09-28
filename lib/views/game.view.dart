import 'package:flutter/material.dart';

class GameView extends StatefulWidget {
  static const String routeName = "game";

  @override
  _GameViewState createState() => _GameViewState();
}

class _GameViewState extends State<GameView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Game view"),
      ),
    );
  }
}
