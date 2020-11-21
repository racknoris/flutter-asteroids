import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_asteroids/shared/player.dart';

class Loc {
  double x;
  double y;
  Loc(this.x, this.y);
}

class GameView extends StatefulWidget {
  static const String routeName = "game";

  @override
  _GameViewState createState() => _GameViewState();
}

class _GameViewState extends State<GameView> {
  FocusNode _focusNode;
  bool _requestedFocus;
  Loc _playerLoc;
  double _speed;

  @override
  void initState() {
    super.initState();
    _requestedFocus = false;
    _focusNode = FocusNode(
        descendantsAreFocusable: true,
        onKey: (FocusNode node, RawKeyEvent event) {
          // print("keytap. node: $node, event: $event");
          return true;
        });

    _playerLoc = Loc(0, 0);
    _speed = 10;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RawKeyboardListener(
        onKey: (RawKeyEvent event) {
          print("[RawKeyboardListener] event: $event");

          if (event is RawKeyDownEvent) {
            if (event.logicalKey == LogicalKeyboardKey.keyA) {
              _playerLoc.x -= _speed;
            }
            if (event.logicalKey == LogicalKeyboardKey.keyD) {
              _playerLoc.x += _speed;
            }
            if (event.logicalKey == LogicalKeyboardKey.keyW) {
              _playerLoc.y -= _speed;
            }
            if (event.logicalKey == LogicalKeyboardKey.keyS) {
              _playerLoc.y += _speed;
            }
          }
          setState(() {});
        },
        focusNode: _focusNode,
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            if (!_requestedFocus) {
              _requestedFocus = true;
              FocusScope.of(context).requestFocus(_focusNode);
            }
            return Container(
              color: Colors.grey.shade300,
              // alignment: Alignment.center,
              width: constraints.maxWidth,
              height: constraints.maxHeight,
              child: Stack(
                children: [
                  Positioned(
                    top: _playerLoc.y,
                    left: _playerLoc.x,
                    child: Player(),
                  ),
                ],
              ),
            );
          },
        ),
        //  Center(
        //   child: Player(),
        // ),
      ),
    );
  }
}
