import 'package:flutter/material.dart';
import 'menu_page.dart';
import 'size.dart';
import '../main.dart' show prefs;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    var k = getProportionalyFactor(context);

    return Scaffold(
        body: Container(
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/wallpaper.jpg'),
                    fit: BoxFit.cover)),
            child: PageView(children: [Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              Container(
                  color: Color(prefs?.getInt('panelColor') ?? 0xCC000000),
                  width: k * 0.2,
                  height: getHeight(context))
            ]), const MenuPage()])));
  }
}
