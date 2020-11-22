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
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Common.PLAYER_1,
      ),
      width: Common.PLAYER_SIZE,
      height: Common.PLAYER_SIZE,
      child: Align(
        alignment: Alignment.centerRight,
        child: Container(
          width: Common.PLAYER_SIZE / 2,
          height: Common.PLAYER_SIZE * 0.2,
          color: Colors.black26,
        ),
      ),
    );
  }
}
