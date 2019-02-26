import 'dart:math';

import 'package:flutter/material.dart';
import 'package:simon_2/util/simon_colors.dart';

class GameScreen extends StatefulWidget {
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  List game = new List<int>();
  List check = new List<int>();
  int _score = 0;
  bool _locked = false;
  Color _green = SimonColors.green;
  Color _red = SimonColors.red;
  Color _yellow = SimonColors.yellow;
  Color _blue = SimonColors.blue;

  void _startGame() {
    // Start game by first Simon move.
    _simonPlay();
  }

  void _simonPlay() {
    // Simon makes a new move.
    var rnd = new Random();
    var number = 1 + rnd.nextInt(4);
    game.add(number);
    check.clear();
    check.addAll(game);

    // Animate game movements so far.
    _animateGame();
  }

  void _userPlay(int number) {
    // Verify user movement.
    if (check.first == number) {
      check.removeAt(0);
      if (check.isEmpty) {
        // User has completed all the movements. It's Simon's turn.
        setState(() {
          _score++;
          _simonPlay();
        });
      }
    } else {
      // Game over.
      setState(() {
        _locked = true;
        _green = SimonColors.greenDisabled;
        _red = SimonColors.redDisabled;
        _yellow = SimonColors.yellowDisabled;
        _blue = SimonColors.blueDisabled;
      });
    }
  }

  void _animateGame() async {
    // Lock screen to prevent user interaction.
    setState(() {
      _locked = true;
      _green = SimonColors.greenDisabled;
      _red = SimonColors.redDisabled;
      _yellow = SimonColors.yellowDisabled;
      _blue = SimonColors.blueDisabled;
    });

    await _simonWait();

    for (int n in game) {
      switch (n) {
        case 1:
          setState(() {
            _green = SimonColors.green;
          });
          break;
        case 2:
          setState(() {
            _red = SimonColors.red;
          });
          break;
        case 3:
          setState(() {
            _yellow = SimonColors.yellow;
          });
          break;
        case 4:
          setState(() {
            _blue = SimonColors.blue;
          });
          break;
      }

      await _simonWait();

      setState(() {
        _green = SimonColors.greenDisabled;
        _red = SimonColors.redDisabled;
        _yellow = SimonColors.yellowDisabled;
        _blue = SimonColors.blueDisabled;
      });

      await _simonWait();
    }

    setState(() {
      _locked = false;
      _green = SimonColors.green;
      _red = SimonColors.red;
      _yellow = SimonColors.yellow;
      _blue = SimonColors.blue;
    });
  }

  Future _simonWait() async {
    await Future.delayed(Duration(milliseconds: 500));
  }

  @override
  void initState() {
    // Start a new game.
    _startGame();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: AbsorbPointer(
        absorbing: _locked,
        child: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.topLeft,
              child: FractionallySizedBox(
                widthFactor: 0.5,
                heightFactor: 0.5,
                child: Padding(
                  padding:
                      EdgeInsets.only(left: 8, top: 8, right: 4, bottom: 4),
                  child: RaisedButton(
                    color: _green,
                    onPressed: () {
                      _userPlay(1);
                    },
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: FractionallySizedBox(
                widthFactor: 0.5,
                heightFactor: 0.5,
                child: Padding(
                  padding:
                      EdgeInsets.only(left: 4, top: 8, right: 8, bottom: 4),
                  child: RaisedButton(
                    color: _red,
                    onPressed: () {
                      _userPlay(2);
                    },
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: FractionallySizedBox(
                widthFactor: 0.5,
                heightFactor: 0.5,
                child: Padding(
                  padding:
                      EdgeInsets.only(left: 8, top: 4, right: 4, bottom: 8),
                  child: RaisedButton(
                    color: _yellow,
                    onPressed: () {
                      _userPlay(3);
                    },
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: FractionallySizedBox(
                widthFactor: 0.5,
                heightFactor: 0.5,
                child: Padding(
                  padding:
                      EdgeInsets.only(left: 4, top: 4, right: 8, bottom: 8),
                  child: RaisedButton(
                    color: _blue,
                    onPressed: () {
                      _userPlay(4);
                    },
                  ),
                ),
              ),
            ),
            Center(
              child: Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: SimonColors.translucent),
                  child: Padding(
                    padding: EdgeInsets.all(12),
                    child: Text(
                      _score.toString(),
                      style: TextStyle(fontSize: 40, color: Colors.white),
                    ),
                  )),
            )
          ],
        ),
      ),
    );
  }
}
