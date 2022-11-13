import 'package:flutter/material.dart';
import 'package:device_apps/device_apps.dart';
import 'package:provider/provider.dart';
import 'apps_list.dart';
import 'config.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  // Query data = Query();

  @override
  Widget build(BuildContext context) {
    _waitForChanges();
    appsList.init();
    return /*ChangeNotifierProvider<Query>(
      create: (context) => data,
      child:*/
        Scaffold(
            /*appBar: AppBar(
          backgroundColor: config.getColor(config.backgroundColor2),
          title: TextField(
            onChanged: (input) {
              data.query = input;
            },
          )
        ),*/
            body: Container(
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/wallpaper.jpg'),
                        fit: BoxFit.cover)),
                child: Container(
                    decoration: BoxDecoration(
                        color: config.getColor(config.panelColor)),
                    child: appsList))) /*)*/;
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

/*class Query with ChangeNotifier {
  String? _query;

  String? get query => _query;
  set query(String? input) {
    _query = input;
    notifyListeners();
  }
}*/
