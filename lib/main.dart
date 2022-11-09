import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:maze_runner/firebase_options.dart';
import 'package:maze_runner/screens/join.dart';
import 'package:maze_runner/screens/two_player_contoller.dart';
import 'package:maze_runner/screens/two_player_maze.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Maze Generator',
      debugShowCheckedModeBanner: false,
      home: kIsWeb ? TwoPlayerMaze() : JoinScreen(),
    );
  }
}
