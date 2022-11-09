import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_joystick/flutter_joystick.dart';

class MyTwoPlayerController extends StatefulWidget {
  final String text;
  const MyTwoPlayerController(this.text);

  @override
  State<MyTwoPlayerController> createState() => _MyTwoPlayerControllerState();
}

class _MyTwoPlayerControllerState extends State<MyTwoPlayerController> {
  var ref = FirebaseDatabase.instance.ref();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setDefaultValuesOfPlayer1();
    setDefaultValuesOfPlayer2();
  }

  @override
  Widget build(BuildContext context) {
    Timer? timer2;
    JoystickMode joystickMode = JoystickMode.horizontalAndVertical;

    return Scaffold(
      body: Column(
        children: [
          widget.text == "P1"
              ? Expanded(
                  child: JoystickArea(
                    // onStickDragStart: (){
                    //
                    // },
                    onStickDragEnd: () {
                      setValueXOfPlayer1(0);
                      setValueYOfPlayer1(0);
                      setDefaultValuesOfPlayer1();
                      print("__________________________run");
                      timer2?.cancel();
                    },
                    mode: joystickMode,
                    // initialJoystickAlignment: const Alignment(0, 0.8),
                    listener: (details) {
                      if (details.x < 0) {
                        print("object moves left");
                        print("${details.x}" "c");
                        timer2 = Timer.periodic(
                            const Duration(milliseconds: 30), (timer) {
                          //code to run on every 5 seconds
                          // _onScreenKeyEvent('left');
                          //set x node  -> -1
                          setValueXOfPlayer1(details.x);
                          print("move left");
                          timer2?.cancel();
                        });
                      } else if (details.x > 0) {
                        timer2 = Timer.periodic(
                            const Duration(milliseconds: 30), (timer) {
                          //code to run on every 5 seconds
                          // _onScreenKeyEvent('right');
                          print("move right");
                          setValueXOfPlayer1(details.x);
                          timer2?.cancel();
                        });
                        print("object moves right");
                        print("right ${details.x}");
                        print(details.x.runtimeType);
                      } else if (details.y < 0) {
                        timer2 = Timer.periodic(
                            const Duration(milliseconds: 30), (timer) {
                          //code to run on every 5 seconds
                          // _onScreenKeyEvent('up');
                          print("move up");
                          setValueYOfPlayer1(details.y);
                          timer2?.cancel();
                        });
                        print("object moves up");
                        print("${details.y}" "a");
                      } else if (details.y > 0) {
                        timer2 = Timer.periodic(
                            const Duration(milliseconds: 30), (timer) {
                          //code to run on every 5 seconds
                          // _onScreenKeyEvent('down');
                          print("move down");
                          setValueYOfPlayer1(details.y);
                          timer2?.cancel();
                        });
                        print("object moves down");
                        print("${details.y}" "b");
                      } else if (details.x == 0.0 && details.y == 0.0) {
                        // setValueXOfPlayer1(0);
                        // setValueYOfPlayer1(0);
                        setDefaultValuesOfPlayer1();
                        // _timer2?.cancel();
                        print("time closed !!!!!!!!!!!!!!!!!!!!!!");
                        print(details.x);
                        print(details.y);
                      }
                      // print(details.x);
                      // print(details.y);
                    },
                  ),
                )
              : const Text(""),
          widget.text == "P2"
              ? Expanded(
                  child: JoystickArea(
                    // onStickDragStart: (){
                    //
                    // },
                    onStickDragEnd: () {
                      setValueXOfPlayer2(0);
                      setValueYOfPlayer2(0);
                      setDefaultValuesOfPlayer2();
                      print("__________________________run");
                      timer2?.cancel();
                    },
                    mode: joystickMode,
                    // initialJoystickAlignment: const Alignment(0, 0.8),
                    listener: (details) {
                      if (details.x < 0) {
                        print("object moves left");
                        print("${details.x}" "c");
                        timer2 = Timer.periodic(
                            const Duration(milliseconds: 30), (timer) {
                          //code to run on every 5 seconds
                          // _onScreenKeyEvent('left');
                          //set x node  -> -1
                          setValueXOfPlayer2(details.x);
                          print("move left");
                          timer2?.cancel();
                        });
                      } else if (details.x > 0) {
                        timer2 = Timer.periodic(
                            const Duration(milliseconds: 30), (timer) {
                          //code to run on every 5 seconds
                          // _onScreenKeyEvent('right');
                          print("move right");
                          setValueXOfPlayer2(details.x);
                          timer2?.cancel();
                        });
                        print("object moves right");
                        print("right ${details.x}");
                        print(details.x.runtimeType);
                      } else if (details.y < 0) {
                        timer2 = Timer.periodic(
                            const Duration(milliseconds: 30), (timer) {
                          //code to run on every 5 seconds
                          // _onScreenKeyEvent('up');
                          print("move up");
                          setValueYOfPlayer2(details.y);
                          timer2?.cancel();
                        });
                        print("object moves up");
                        print("${details.y}" "a");
                      } else if (details.y > 0) {
                        timer2 = Timer.periodic(
                            const Duration(milliseconds: 30), (timer) {
                          //code to run on every 5 seconds
                          // _onScreenKeyEvent('down');
                          print("move down");
                          setValueYOfPlayer2(details.y);
                          timer2?.cancel();
                        });
                        print("object moves down");
                        print("${details.y}" "b");
                      } else if (details.x == 0.0 && details.y == 0.0) {
                        // setValueXOfPlayer2(0);
                        // setValueYOfPlayer2(0);

                        setDefaultValuesOfPlayer2();
                        // _timer2?.cancel();
                        print("time closed !!!!!!!!!!!!!!!!!!!!!!");
                        print(details.x);
                        print(details.y);
                      }
                      // print(details.x);
                      // print(details.y);
                    },
                  ),
                )
              : const Text(""),
          const SizedBox(
            height: 100,
          )
        ],
      ),
    );
  }

  void setValueXOfPlayer1(double x1) async {
    await ref.child("123/P1").update({"x": x1.toString()});
  }

  void setValueYOfPlayer1(double y1) async {
    await ref.child("123/P1").update({"y": y1.toString()});
  }

  void setDefaultValuesOfPlayer1() async {
    await ref.child("123/P1").set({"x": "0", "y": "0"});
  }

  void setValueXOfPlayer2(double x1) async {
    await ref.child("123/P2").update({"x": x1.toString()});
  }

  void setValueYOfPlayer2(double y1) async {
    await ref.child("123/P2").update({"y": y1.toString()});
  }

  void setDefaultValuesOfPlayer2() async {
    await ref.child("123/P2").set({"x": "0", "y": "0"});
  }
}
