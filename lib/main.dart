import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'src/home_page.dart';

void main() {
  _initPrefs();
  runApp(const MaterialApp(home: HomePage()));
}

SharedPreferences? prefs;
Future<void> _initPrefs() async {
  prefs = await SharedPreferences.getInstance();
}
