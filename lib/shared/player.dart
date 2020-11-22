import 'package:flutter/material.dart';
import 'package:flutter_asteroids/shared/common.dart';

class Player extends StatefulWidget {
  @override
  _PlayerState createState() => _PlayerState();
}

class _PlayerState extends State<Player> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Common.PLAYER_1,
      width: Common.PLAYER_SIZE,
      height: Common.PLAYER_SIZE,
    );
  }
}