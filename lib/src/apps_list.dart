import 'dart:async';
import 'package:flutter/material.dart';
import 'package:device_apps/device_apps.dart';
import '../main.dart' show prefs;
import 'size.dart';

var appsList = AppsList();
var _streamController = StreamController();

class AppsList extends StatefulWidget {
  List<Application> apps = [];

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
    var app = await DeviceApps.getApp(packageName);
    if (app != null) {
      apps.add(app);
      _streamController.sink.add(true);
    }
  }

  void install(String packageName) {
    for (var i = 0; i < apps.length; i++) {
      if (apps[i].packageName == packageName) {
        apps.removeAt(i);
        _streamController.sink.add(true);
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
                color: Color(prefs?.getInt('accentColor') ?? 0xFF1AD06F)))
        : GridView.count(
            crossAxisCount: 2,
            children:
                List.generate(apps.length, (index) => AppCard(apps[index])));
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

  AppCard(this.app);

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
                backgroundColor:
                    Color(prefs?.getInt('backgroundColor2') ?? 0xFF222222)),
            onPressed: () {
              if (!_open) {
                app.openApp();
                Navigator.pop(context);
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
                                    color: Color(prefs?.getInt('fontColor') ??
                                        0xFFFFFFFF)))
                          ])
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(
                                        prefs?.getInt('accentColor') ??
                                            0xFF1AD06F),
                                    shadowColor: const Color(0x00000000)),
                                onPressed: () {
                                  var count =
                                      prefs?.getInt('pinnedAppsCount') ?? 0;
                                  prefs?.setString(
                                      'pinnedApp${count + 1}', app.packageName);
                                  prefs?.setInt('pinnedAppsCount', count + 1);
                                  _open = false;
                                  Navigator.pop(context);
                                },
                                child: Container(
                                    margin: const EdgeInsets.all(5),
                                    child:
                                        const Icon(Icons.bookmark_outlined))),
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(
                                        prefs?.getInt('accentColor') ??
                                            0xFF1AD06F),
                                    shadowColor: const Color(0x00000000)),
                                onPressed: () {
                                  app.openSettingsScreen();
                                  Navigator.pop(context);
                                },
                                child: Container(
                                    margin: const EdgeInsets.all(5),
                                    child: const Icon(Icons.settings))),
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(
                                        prefs?.getInt('accentColor') ??
                                            0xFF1AD06F),
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
