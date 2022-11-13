import 'dart:async';
import 'package:flutter/material.dart';
import 'package:device_apps/device_apps.dart';
import 'settings_page.dart';
import 'size.dart';
import 'config.dart';

var appsList = AppsList();
var _streamController = StreamController();

var _updateApps = StreamController();

class AppsList extends StatefulWidget {
  List<Application> apps = [];

  AppsList({super.key});

  Future<void> init({bool force = false}) async {
    if (apps.isEmpty || force) {
      apps = await DeviceApps.getInstalledApplications(
          includeAppIcons: true,
          includeSystemApps: true,
          onlyAppsWithLaunchIntent: true);
      _streamController.sink.add(true);
    }
  }

  Future<void> uninstall(String packageName) async {
    Future<void> unpinApp() async {
      var app = await DeviceApps.getApp(packageName);
      if (app != null) {
        if (config.isAppPinned(app)) {
          config.unpinApp = app;
        }
      }
    }

    var app = await DeviceApps.getApp(packageName);
    if (app != null) {
      apps.add(app);
      unpinApp();
      _streamController.sink.add(true);
      _updateApps.sink.add('uninstalled');
    }
  }

  void install(String packageName) {
    for (var i = 0; i < apps.length; i++) {
      if (apps[i].packageName == packageName) {
        apps.removeAt(i);
        _streamController.sink.add(true);
        _updateApps.sink.add('installed');
        break;
      }
    }
  }

  @override
  State<AppsList> createState() => _AppsListState(apps);
}

var _listening = false;

class _AppsListState extends State<AppsList> {
  List<Application> apps;

  _AppsListState(this.apps);

  @override
  Widget build(BuildContext context) {
    return apps.isEmpty
        ? Center(
            child: CircularProgressIndicator(
                color: config.getColor(config.accentColor)))
        : GridView.count(
            crossAxisCount: 2,
            children: List.generate(apps.length, (index) {
              return AppCard(apps[index]);
            }));
  }

  @override
  void initState() {
    super.initState();
    if (!_listening) {
      _streamController.stream.listen((data) {
        if (data) {
          setState(() {
            apps = appsList.apps;
          });
        }
      });
      _listening = true;
    }
  }
}

class AppCard extends StatefulWidget {
  Application app;

  AppCard(this.app, {super.key});

  @override
  State<AppCard> createState() => _AppCardState(app);
}

class _AppCardState extends State<AppCard> {
  Application app;
  bool _open = false;

  _AppCardState(this.app);

  @override
  Widget build(BuildContext context) {
    var k = getProportionalyFactor(context);

    return Container(
        margin: const EdgeInsets.all(15),
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: config.getColor(config.backgroundColor2)),
            onPressed: () {
              if (!_open) {
                Navigator.pop(context);
                if (app.packageName == 'vv_os.leraxxx.ru') {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SettingsPage()));
                } else {
                  app.openApp();
                }
                // context.watch<Query>().query = null;
              }
            },
            onLongPress: () {
              setState(() {
                _open = !_open;
              });
            },
            child: Container(
                margin: EdgeInsets.symmetric(
                    vertical: _open ? 0 : 15, horizontal: 10),
                child: !_open
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                            Image.memory((app as ApplicationWithIcon).icon,
                                width: k / 2 - 100),
                            Text(app.appName,
                                style: TextStyle(
                                    color: config.getColor(config.fontColor))),
                          ])
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        config.getColor(config.accentColor),
                                    shadowColor: const Color(0x00000000)),
                                onPressed: () {
                                  config.pinApp = app;
                                  _open = false;
                                  // context.watch<Query>().query = null;
                                },
                                child: Container(
                                    margin: const EdgeInsets.all(5),
                                    child:
                                        const Icon(Icons.bookmark_outlined))),
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        config.getColor(config.accentColor),
                                    shadowColor: const Color(0x00000000)),
                                onPressed: () {
                                  app.openSettingsScreen();
                                  // context.watch<Query>().query = null;
                                  Navigator.pop(context);
                                },
                                child: Container(
                                    margin: const EdgeInsets.all(5),
                                    child: const Icon(Icons.settings))),
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        config.getColor(config.accentColor),
                                    shadowColor: const Color(0x00000000)),
                                onPressed: () {
                                  app.uninstallApp();
                                },
                                child: Container(
                                    margin: const EdgeInsets.all(5),
                                    child: const Icon(Icons.delete)))
                          ]))));
  }
}
