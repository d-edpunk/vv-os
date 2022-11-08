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
                    image: AssetImage('assets/wallpaper_vv.jpg'),
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
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                            PanelButton(
                              icon: Icons.settings,
                              onPressed: () {},
                            ),
                            const PanelSeparator(),
                            //const PanelSeparator(),
                            PanelButton(
                              icon: Icons.search,
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const MenuPage()));
                              },
                            ),
                          ]))),
                ])));
  }
}

class PanelSeparator extends StatelessWidget {
  const PanelSeparator({super.key});

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    var k = width < height ? width : height;

    return Container(
        width: k * 0.06,
        height: k * 0.02,
        margin: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
        ));
  }
}

class PanelButton extends StatefulWidget {
  IconData icon;
  void Function() onPressed;
  double iconSize;

  PanelButton(
      {required this.icon,
      required this.onPressed,
      this.iconSize = 0.1,
      super.key});

  @override
  State<PanelButton> createState() =>
      _PanelButtonState(icon: icon, onPressed: onPressed, iconSize: iconSize);
}

class _PanelButtonState extends State<PanelButton> {
  IconData icon;
  void Function() onPressed;
  double iconSize;

  _PanelButtonState(
      {required this.icon, required this.onPressed, this.iconSize = 0.1});

  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    var k = width < height ? width : height;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2.5),
      child: FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: onPressed,
        child: Icon(icon, size: k * iconSize),
      ),
    );
  }
}
