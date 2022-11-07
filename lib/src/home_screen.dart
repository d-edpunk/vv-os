import 'package:flutter/material.dart';
import 'calls.dart';
import 'youtube.dart';
//import 'telegram.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    var iconSize = width < height ? width / 5 : height / 5;

    return Scaffold(
        backgroundColor: Colors.black,
        body: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 15),
                      child: Image.asset('assets/images/logo.png'),
                    ),
                  ]),
              Row(children: [
                HomeScreenIcon(
                    child: FloatingActionButton(
                  backgroundColor: Colors.green,
                  child: const Icon(Icons.call),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Calls()),
                    );
                  },
                )),
                HomeScreenIcon(
                    child: FloatingActionButton(
                  backgroundColor: Colors.blue,
                  child: Icon(Icons.telegram_rounded, size: iconSize - 15),
                  onPressed: () {
                    /*Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Telegram()
                      )
                    );*/
                  },
                )),
                HomeScreenIcon(
                    child: FloatingActionButton(
                  backgroundColor: Colors.red,
                  child: const Icon(Icons.video_library),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Youtube()));
                  },
                )),
                HomeScreenIcon(
                    child: FloatingActionButton(
                  backgroundColor: const Color(0xFF222222),
                  child: const Icon(Icons.terminal),
                  onPressed: () {},
                )),
                HomeScreenIcon(
                    child: FloatingActionButton(
                  backgroundColor: Colors.grey,
                  child: const Icon(Icons.settings),
                  onPressed: () {},
                )),
              ]),
            ]));
  }
}

class HomeScreenIcon extends StatelessWidget {
  final Widget? child;

  const HomeScreenIcon({this.child, super.key});

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return SizedBox(
      width: width < height ? width / 5 : height / 5,
      height: width < height ? width / 5 : height / 5,
      child: Container(margin: const EdgeInsets.all(5), child: child),
    );
  }
}
