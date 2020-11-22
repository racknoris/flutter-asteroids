import 'package:flutter/material.dart';
import 'package:flutter_asteroids/shared/common.dart';
import 'package:flutter_asteroids/views/game.view.dart';

class ShotModel {
  Loc loc;
  double angle;
  bool done = false;

  ShotModel(this.loc, this.angle);
}

class Shot extends StatefulWidget {
  @override
  _ShotState createState() => _ShotState();
}

class _ShotState extends State<Shot> {
  @override
  Widget build(BuildContext context) {
    return Align(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.purple.shade300,
          shape: BoxShape.circle,
        ),
        width: Common.SHOT_SIZE,
        height: Common.SHOT_SIZE,
      ),
    );
  }
}
