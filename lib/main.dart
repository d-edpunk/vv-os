import 'package:flutter/material.dart';
import 'src/home_page.dart';
import 'src/menu_page.dart';
import 'src/config.dart';

void main() {
  runApp(const MaterialApp(home: App()));
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return config.openMenuByButton
        ? const HomePage()
        : PageView(children: const [HomePage(), MenuPage()]);
  }
}
