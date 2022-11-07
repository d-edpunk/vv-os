import 'dart:math';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class Call extends StatefulWidget {
  String name;
  String? avatar;

  Call({required this.name, this.avatar, super.key});

  @override
  State<Call> createState() => _CallState(name, avatar);
}

class _CallState extends State<Call> {
  String name;
  String? avatar;

  List<AudioPlayer> players = [];

  _CallState(this.name, this.avatar);

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    playAudio(context);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            color: Colors.green,
            padding: const EdgeInsets.fromLTRB(0, 35, 0, 10),
            child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      )),
                ]),
          ),
          Flexible(
              child: Container(
                  width: width < height ? width : height,
                  margin: const EdgeInsets.all(30),
                  child: Image.asset(avatar ?? 'assets/images/default.png',
                      fit: BoxFit.cover))),
          ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () {
                for (var el in players) {
                  el.stop();
                }
                Navigator.pop(context);
              },
              child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: const Icon(Icons.call_end)))
        ],
      ),
    );
  }

  Future<void> playAudio(BuildContext context) async {
    for (var i = 0; i < 3; i++) {
      players.add(AudioPlayer());
    }
    await players[0].setAsset('assets/audio/0.mp3');
    await players[1].setAsset('assets/audio/${Random().nextInt(3) + 1}.mp3');
    await players[2].setAsset('assets/audio/-1.mp3');
    for (var el in players) {
      await el.play();
    }
    Navigator.pop(context);
  }
}
