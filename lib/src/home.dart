import 'package:flutter/material.dart';
import 'menu.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    var k = width < height ? width : height;

    return Scaffold(
        body: Container(
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/wallpapers.jpg'),
                    fit: BoxFit.cover)),
            child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                      color: Colors.black,
                      width: k * 0.17,
                      height: height,
                      padding: EdgeInsets.all(k * 0.02),
                      child: Expanded(
                          child: Column(children: [
                        Container(
                            margin: EdgeInsets.only(top: k * 0.085),
                            child: FloatingActionButton(
                              backgroundColor: Colors.black,
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const MenuPage()));
                              },
                              child: Icon(Icons.search, size: k * 0.15),
                            ))
                      ]))),
                ])));
  }
}
