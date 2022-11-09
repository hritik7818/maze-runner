import 'dart:async';
import 'dart:math';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constants.dart';
import '../models/cell.dart';

class TwoPlayerMaze extends StatefulWidget {
  const TwoPlayerMaze({Key? key}) : super(key: key);

  @override
  State<TwoPlayerMaze> createState() => _TwoPlayerMazeState();
}

class _TwoPlayerMazeState extends State<TwoPlayerMaze> {
  var ref = FirebaseDatabase.instance.ref();

  late List<Cell> cells;
  late final Timer _timer;
  late int _currentStepOfPlayer1;
  late int _currentStepOfPlayer2;
  final row = height ~/ spacing;
  final cols = width ~/ spacing;
  final List<Cell> stack = [];
  bool _isCompleted = false;
  bool _isWin = false;

  @override
  void initState() {
    super.initState();
    ref.child("123/P1/x").onValue.listen((event) {
      if (event.snapshot.exists) {
        var value = event.snapshot.value.toString();

        // if joystick moves left
        if (double.parse(value) < 0) {
          _onScreenKeyEventOfPlayer1('left');
        }

        //if joystick moves right
        if (double.parse(value) > 0) {
          _onScreenKeyEventOfPlayer1('right');
        }
      }
    });
    ref.child("123/P1/y").onValue.listen((event) {
      if (event.snapshot.exists) {
        var value = event.snapshot.value.toString();

        // if joystick moves up
        if (double.parse(value) < 0) {
          _onScreenKeyEventOfPlayer1('up');
        }

        // if joystick moves down
        if (double.parse(value) > 0) {
          _onScreenKeyEventOfPlayer1('down');
        }
      }
    });
    ref.child("123/P2/x").onValue.listen((event) {
      if (event.snapshot.exists) {
        var value = event.snapshot.value.toString();

        // if joystick moves left
        if (double.parse(value) < 0) {
          _onScreenKeyEventOfPlayer2('left');
        }

        //if joystick moves right
        if (double.parse(value) > 0) {
          _onScreenKeyEventOfPlayer2('right');
        }
      }
    });
    ref.child("123/P2/y").onValue.listen((event) {
      if (event.snapshot.exists) {
        var value = event.snapshot.value.toString();

        // if joystick moves up
        if (double.parse(value) < 0) {
          _onScreenKeyEventOfPlayer2('up');
        }

        // if joystick moves down
        if (double.parse(value) > 0) {
          _onScreenKeyEventOfPlayer2('down');
        }
      }
    });
    reset();
  }

  List<Cell> getCells() {
    List<Cell> cells = [];
    for (int i = 0; i < row; i++) {
      for (int j = 0; j < cols; j++) {
        cells.add(Cell(j, i));
      }
    }
    return cells;
  }

  int? getIndex(int i, int j) {
    if (i < 0 || j < 0 || i > row - 1 || j > cols - 1) {
      return null;
    }
    return i + (j * (width ~/ spacing));
  }

  List<Cell> checkNeighbours(Cell cell) {
    List<Cell> neighbours = [];
    int? top = getIndex(cell.i, cell.j - 1);
    int? bottom = getIndex(cell.i, cell.j + 1);
    int? left = getIndex(cell.i - 1, cell.j);
    int? right = getIndex(cell.i + 1, cell.j);
    if (top != null && !cells[top].visited) {
      neighbours.add(cells[top]);
    }
    if (right != null && !cells[right].visited) {
      neighbours.add(cells[right]);
    }
    if (bottom != null && !cells[bottom].visited) {
      neighbours.add(cells[bottom]);
    } else if (left != null && !cells[left].visited) {
      neighbours.add(cells[left]);
    }
    return neighbours;
  }

  void reset() {
    stack.clear();
    _isCompleted = false;
    _isWin = false;
    cells = getCells();
    _currentStepOfPlayer1 = 0;
    _currentStepOfPlayer2 = 0;

    cells[_currentStepOfPlayer1].visited = true;
    cells[_currentStepOfPlayer2].visited = true;
    _timer = Timer.periodic(const Duration(milliseconds: 100), updateCell);
  }

  void updateCell(Timer timer) {
    for (int i = 0; i < 15; i++) {
      var neighbours = checkNeighbours(cells[_currentStepOfPlayer1]);
      if (neighbours.isEmpty) {
        if (stack.isNotEmpty) {
          var lastCell = stack.removeLast();
          // setState(() {
          _currentStepOfPlayer1 = getIndex(lastCell.i, lastCell.j)!;
          // });
        } else {
          _timer.cancel();
          // setState(() {
          _isCompleted = true;
          // });
        }
      } else {
        var random = Random().nextInt(neighbours.length);
        var next = neighbours[random];
        stack.add(cells[_currentStepOfPlayer1]);
        // setState(() {
        next.visited = true;
        removeWalls(cells[_currentStepOfPlayer1], next);
        // });
        _currentStepOfPlayer1 = getIndex(next.i, next.j)!;
      }
    }
    setState(() {});
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  removeWalls(Cell current, Cell next) {
    if (current.j - next.j == 1) {
      current.left = false;
      next.right = false;
    } else if (current.j - next.j == -1) {
      current.right = false;
      next.left = false;
    } else if (current.i - next.i == 1) {
      current.top = false;
      next.bottom = false;
    } else if (current.i - next.i == -1) {
      current.bottom = false;
      next.top = false;
    }
  }

  void _handleKeyEventOfPlayer1(RawKeyEvent event) {
    if (!_isCompleted || _isWin) {
      return;
    }
    setState(() {
      if (event.logicalKey == LogicalKeyboardKey.arrowUp &&
          !cells[_currentStepOfPlayer1].top) {
        _currentStepOfPlayer1 = getIndex(cells[_currentStepOfPlayer1].i - 1,
            cells[_currentStepOfPlayer1].j)!;
      } else if (event.logicalKey == LogicalKeyboardKey.arrowDown &&
          !cells[_currentStepOfPlayer1].bottom) {
        _currentStepOfPlayer1 = getIndex(cells[_currentStepOfPlayer1].i + 1,
            cells[_currentStepOfPlayer1].j)!;
      } else if (event.logicalKey == LogicalKeyboardKey.arrowLeft &&
          !cells[_currentStepOfPlayer1].left) {
        _currentStepOfPlayer1 = getIndex(cells[_currentStepOfPlayer1].i,
            cells[_currentStepOfPlayer1].j - 1)!;
      } else if (event.logicalKey == LogicalKeyboardKey.arrowRight &&
          !cells[_currentStepOfPlayer1].right) {
        _currentStepOfPlayer1 = getIndex(cells[_currentStepOfPlayer1].i,
            cells[_currentStepOfPlayer1].j + 1)!;
      }
    });
    if (_currentStepOfPlayer1 == getIndex(0, row - 1)) {
      setState(() {
        _isWin = true;
      });
    }
  }

  void _handleKeyEventOfPlayer2(RawKeyEvent event) {
    if (!_isCompleted || _isWin) {
      return;
    }
    setState(() {
      if (event.logicalKey == LogicalKeyboardKey.arrowUp &&
          !cells[_currentStepOfPlayer2].top) {
        _currentStepOfPlayer2 = getIndex(cells[_currentStepOfPlayer2].i - 1,
            cells[_currentStepOfPlayer2].j)!;
      } else if (event.logicalKey == LogicalKeyboardKey.arrowDown &&
          !cells[_currentStepOfPlayer2].bottom) {
        _currentStepOfPlayer2 = getIndex(cells[_currentStepOfPlayer2].i + 1,
            cells[_currentStepOfPlayer2].j)!;
      } else if (event.logicalKey == LogicalKeyboardKey.arrowLeft &&
          !cells[_currentStepOfPlayer2].left) {
        _currentStepOfPlayer2 = getIndex(cells[_currentStepOfPlayer2].i,
            cells[_currentStepOfPlayer2].j - 1)!;
      } else if (event.logicalKey == LogicalKeyboardKey.arrowRight &&
          !cells[_currentStepOfPlayer2].right) {
        _currentStepOfPlayer2 = getIndex(cells[_currentStepOfPlayer2].i,
            cells[_currentStepOfPlayer2].j + 1)!;
      }
    });
    if (_currentStepOfPlayer1 == getIndex(0, row - 1)) {
      setState(() {
        _isWin = true;
      });
    }
  }

  void _onScreenKeyEventOfPlayer1(String key) {
    if (!_isCompleted || _isWin) {
      return;
    }
    setState(() {
      if (key == 'up' && !cells[_currentStepOfPlayer1].top) {
        _currentStepOfPlayer1 = getIndex(cells[_currentStepOfPlayer1].i - 1,
            cells[_currentStepOfPlayer1].j)!;
      } else if (key == 'down' && !cells[_currentStepOfPlayer1].bottom) {
        _currentStepOfPlayer1 = getIndex(cells[_currentStepOfPlayer1].i + 1,
            cells[_currentStepOfPlayer1].j)!;
      } else if (key == 'left' && !cells[_currentStepOfPlayer1].left) {
        _currentStepOfPlayer1 = getIndex(cells[_currentStepOfPlayer1].i,
            cells[_currentStepOfPlayer1].j - 1)!;
      } else if (key == 'right' && !cells[_currentStepOfPlayer1].right) {
        _currentStepOfPlayer1 = getIndex(cells[_currentStepOfPlayer1].i,
            cells[_currentStepOfPlayer1].j + 1)!;
      }
    });
    if (_currentStepOfPlayer1 == getIndex(0, row - 1)) {
      setState(() {
        _isWin = true;
      });
    }
  }

  void _onScreenKeyEventOfPlayer2(String key) {
    if (!_isCompleted || _isWin) {
      return;
    }
    setState(() {
      if (key == 'up' && !cells[_currentStepOfPlayer2].top) {
        _currentStepOfPlayer2 = getIndex(cells[_currentStepOfPlayer2].i - 1,
            cells[_currentStepOfPlayer2].j)!;
      } else if (key == 'down' && !cells[_currentStepOfPlayer2].bottom) {
        _currentStepOfPlayer2 = getIndex(cells[_currentStepOfPlayer2].i + 1,
            cells[_currentStepOfPlayer2].j)!;
      } else if (key == 'left' && !cells[_currentStepOfPlayer2].left) {
        _currentStepOfPlayer2 = getIndex(cells[_currentStepOfPlayer2].i,
            cells[_currentStepOfPlayer2].j - 1)!;
      } else if (key == 'right' && !cells[_currentStepOfPlayer2].right) {
        _currentStepOfPlayer2 = getIndex(cells[_currentStepOfPlayer2].i,
            cells[_currentStepOfPlayer2].j + 1)!;
      }
    });
    if (_currentStepOfPlayer2 == getIndex(0, row - 1)) {
      setState(() {
        _isWin = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Center(
                child: FittedBox(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    color: Colors.red,
                    height: height,
                    width: width,
                    child: Stack(
                      children: List.generate(
                        cells.length,
                        (index) => Positioned(
                          top: cells[index].x,
                          left: cells[index].y,
                          child: Container(
                              height: spacing,
                              width: spacing,
                              decoration: BoxDecoration(
                                border: Border(
                                  right: cells[index].right
                                      ? const BorderSide(
                                          color: Colors.white, width: 1)
                                      : BorderSide.none,
                                  bottom: cells[index].bottom
                                      ? const BorderSide(
                                          color: Colors.white, width: 1)
                                      : BorderSide.none,
                                  left: cells[index].left
                                      ? const BorderSide(
                                          color: Colors.white, width: 1)
                                      : BorderSide.none,
                                  top: cells[index].top
                                      ? const BorderSide(
                                          color: Colors.white, width: 1)
                                      : BorderSide.none,
                                ),
                                // image: DecorationImage(image: AssetImage("assets/runner.png")),
                                color: (index == _currentStepOfPlayer1 &&
                                        _isCompleted)
                                    ? Colors.blue.withOpacity(0.7)
                                    : (index == _currentStepOfPlayer2 &&
                                            _isCompleted)
                                        ? Colors.orange
                                        : Colors.transparent,
                                // : cells[index].visited
                                //     ? Colors.purple.withOpacity(0.5)
                                // : Colors.transparent,
                              ),
                              padding: const EdgeInsets.all(2),
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: index == 0
                                    ? const Text(
                                        'Start',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 18),
                                      )
                                    : index == getIndex(0, row - 1)
                                        ? const Text(
                                            'End',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 18),
                                          )
                                        : null,
                              )),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Text(
                    _isWin
                        ? 'You Win !!'
                        : _isCompleted
                            ? 'Maze Generation Completed'
                            : 'Generating Maze...',
                    style: const TextStyle(color: Colors.white, fontSize: 22),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  _isWin
                      ? MaterialButton(
                          elevation: 0,
                          color: Colors.white,
                          onPressed: () {
                            setState(() {
                              reset();
                            });
                          },
                          child: const Text(
                            'Generate Another Maze',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                        )
                      : _isCompleted
                          ? const Text(
                              'Press arrow keys to play.',
                              style: TextStyle(color: Colors.white),
                            )
                          : const SizedBox(),
                ],
              ),
            )),
          ),
        ));
  }
}
