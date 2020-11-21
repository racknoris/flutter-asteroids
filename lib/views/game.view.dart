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

  Map<LogicalKeyboardKey, bool> _keysDown;

  @override
  void initState() {
    super.initState();
    _keysDown = {};
    _requestedFocus = false;
    _focusNode = FocusNode(
        descendantsAreFocusable: true,
        onKey: (FocusNode node, RawKeyEvent event) {
          // print("keytap. node: $node, event: $event");
          return true;
        });

    _playerLoc = Loc(0, 0);
    _speed = 7;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RawKeyboardListener(
        onKey: (RawKeyEvent event) {
          print("[RawKeyboardListener] event: $event");

          if (event is RawKeyDownEvent) {
            _keysDown[event.logicalKey] = true;
          }
          if (event is RawKeyUpEvent) {
            _keysDown[event.logicalKey] = false;
          }
        },
        focusNode: _focusNode,
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            if (!_requestedFocus) {
              _requestedFocus = true;
              FocusScope.of(context).requestFocus(_focusNode);
            }

            _handleKeys();

            WidgetsBinding.instance.addPostFrameCallback((_) {
              setState(() {});
            });

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
      ),
    );
  }

  void _handleKeys() {
    if (_keysDown[LogicalKeyboardKey.keyR] == true) {
      _playerLoc = Loc(0, 0);
    }

    if (_keysDown[LogicalKeyboardKey.keyA] == true) {
      _playerLoc.x -= _speed;
    }
    if (_keysDown[LogicalKeyboardKey.keyD] == true) {
      _playerLoc.x += _speed;
    }
    if (_keysDown[LogicalKeyboardKey.keyW] == true) {
      _playerLoc.y -= _speed;
    }
    if (_keysDown[LogicalKeyboardKey.keyS] == true) {
      _playerLoc.y += _speed;
    }
  }
}
