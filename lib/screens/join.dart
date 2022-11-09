import 'package:flutter/material.dart';
import 'package:maze_runner/screens/two_player_contoller.dart';

class JoinScreen extends StatefulWidget {
  const JoinScreen({super.key});

  @override
  State<JoinScreen> createState() => _JoinScreenState();
}

class _JoinScreenState extends State<JoinScreen> {
  TextEditingController name_controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Column(
            children: [
              TextFormField(
                textInputAction: TextInputAction.done,
                controller: name_controller,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  label: const Text("Enter P1 or P2"),
                  labelStyle: const TextStyle(color: Colors.white),
                  fillColor: Colors.white,
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    borderSide: const BorderSide(
                      color: Colors.white,
                      width: 2.0,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    borderSide: const BorderSide(
                      color: Colors.white,
                      width: 2.0,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              MyTwoPlayerController(name_controller.text)),
                    );
                  },
                  child: const Text("JOIN")),
            ],
          ),
        ),
      ),
    );
  }
}
