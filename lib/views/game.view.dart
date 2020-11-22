import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_asteroids/shared/common.dart';
import 'package:flutter_asteroids/shared/player.dart';
import 'package:flutter_asteroids/shared/shot.dart';

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
  double _playerRotation;
  double _playerSpeed;
  double _playerRotationSpeed = pi * 0.05;
  double _shotsSpeed;
  DateTime _lastShotTime;

  Map<LogicalKeyboardKey, bool> _keysDown;
  List<ShotModel> _shotModels;

  Size _screenSize;

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

    _playerRotation = 0;
    _playerSpeed = 5;
    _shotsSpeed = 5.5;
    _shotModels = [];
    _lastShotTime = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    _screenSize = MediaQuery.of(context).size;

    if (_playerLoc == null) {
      _initPlayerTransform();
    }

    return Scaffold(
      body: RawKeyboardListener(
        onKey: (RawKeyEvent event) {
          // print("[RawKeyboardListener] event: $event");

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

            _updateShots();

            WidgetsBinding.instance.addPostFrameCallback((_) {
              setState(() {});
            });

            List<Widget> children = [];

            children.add(
              Positioned(
                top: _playerLoc.y,
                left: _playerLoc.x,
                child: Transform.rotate(
                  angle: _playerRotation,
                  child: Player(),
                ),
              ),
            );

            List<Widget> shots = _shotModels
                .map(
                  (ShotModel shotModel) => Positioned(
                    left: shotModel.loc.x,
                    top: shotModel.loc.y,
                    child: Shot(),
                  ),
                )
                .toList();

            children.addAll(shots);

            return Container(
              color: Colors.grey.shade300,
              // alignment: Alignment.center,
              width: constraints.maxWidth,
              height: constraints.maxHeight,
              child: Stack(
                children: children,
              ),
            );
          },
        ),
      ),
    );
  }

  void _initPlayerTransform() {
    _playerLoc = Loc(_screenSize.width / 2, _screenSize.height / 2);
    _playerRotation = 0;
  }

  void _handleKeys() {
    if (_keysDown[LogicalKeyboardKey.keyR] == true) {
      _initPlayerTransform();
    }

    if (_keysDown[LogicalKeyboardKey.keyZ] == true) {
      _playerLoc.x -= _playerSpeed;
    }
    if (_keysDown[LogicalKeyboardKey.keyC] == true) {
      _playerLoc.x += _playerSpeed;
    }
    if (_keysDown[LogicalKeyboardKey.keyS] == true) {
      _playerLoc.y -= _playerSpeed;
    }
    if (_keysDown[LogicalKeyboardKey.keyX] == true) {
      _playerLoc.y += _playerSpeed;
    }

    if (_keysDown[LogicalKeyboardKey.arrowLeft] == true) {
      _playerRotation -= _playerRotationSpeed;
    }
    if (_keysDown[LogicalKeyboardKey.arrowRight] == true) {
      _playerRotation += _playerRotationSpeed;
    }

    if (_keysDown[LogicalKeyboardKey.space] == true) {
      if (DateTime.now().millisecondsSinceEpoch -
              _lastShotTime.millisecondsSinceEpoch >
          300) {
        _lastShotTime = DateTime.now();
        _createShot();
      }
    }

    // apply bounderies:
    if (_playerLoc.x < 0) _playerLoc.x = 0;
    if (_playerLoc.y < 0) _playerLoc.y = 0;
    if (_playerLoc.x > _screenSize.width - Common.PLAYER_SIZE)
      _playerLoc.x = _screenSize.width - Common.PLAYER_SIZE;
    if (_playerLoc.y > _screenSize.height - Common.PLAYER_SIZE)
      _playerLoc.y = _screenSize.height - Common.PLAYER_SIZE;
  }

  void _createShot() {
    _shotModels.add(ShotModel(
        Loc(
            _playerLoc.x +
                Common.PLAYER_SIZE / 2 -
                Common.SHOT_SIZE / 2 +
                (Common.PLAYER_SIZE / 2) * cos(_playerRotation),
            _playerLoc.y +
                Common.PLAYER_SIZE / 2 -
                Common.SHOT_SIZE / 2 +
                (Common.PLAYER_SIZE / 2) * sin(_playerRotation)),
        _playerRotation));
  }

  void _updateShots() {
    for (ShotModel shotModel in _shotModels) {
      shotModel.loc.x += _shotsSpeed * cos(shotModel.angle);
      shotModel.loc.y += _shotsSpeed * sin(shotModel.angle);

      if (shotModel.loc.x < 0 ||
          shotModel.loc.x > _screenSize.width ||
          shotModel.loc.y < 0 ||
          shotModel.loc.y > _screenSize.height) {
        shotModel.done = true;
      }
    }

    _shotModels.removeWhere((ShotModel shotModel) => shotModel.done);
  }
}
