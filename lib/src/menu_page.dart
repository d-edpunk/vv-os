import 'package:flutter/material.dart';
import 'package:device_apps/device_apps.dart';
import '../main.dart' show prefs;
import 'apps_list.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  @override
  Widget build(BuildContext context) {
    _waitForChanges();
    appsList.init();
    return Scaffold(
        body: Container(
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/wallpaper.jpg'),
                    fit: BoxFit.cover)),
            child: Container(
                decoration: BoxDecoration(
                    color: Color(prefs?.getInt('panelColor') ?? 0xCC000000)),
                child: appsList)));
  }

  Future<void> _waitForChanges() async {
    var changes = DeviceApps.listenToAppsChanges();
    changes.listen((event) async {
      if (event is ApplicationEventUninstalled) {
        appsList.uninstall(event.packageName);
      } else if (event is ApplicationEventInstalled) {
        appsList.install(event.packageName);
      }
    });
  }
}
