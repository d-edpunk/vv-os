import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'src/home_page.dart';
import 'src/menu_page.dart';

void main() {
  _initPrefs();
  runApp(MaterialApp(
      home: (prefs?.getBool('openMenuByButton') ?? true)
          ? const HomePage()
          : PageView(children: const [HomePage(), MenuPage()])));
}

SharedPreferences? prefs;
Future<void> _initPrefs() async {
  prefs = await SharedPreferences.getInstance();
}
