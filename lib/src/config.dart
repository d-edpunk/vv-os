import 'package:flutter/material.dart';
import 'package:device_apps/device_apps.dart' show Application;
import 'dart:async';

class Config {
  StreamController appsPinning = StreamController();
  StreamController settings = StreamController();

  bool openMenuByButton = true;
  bool panelPositionRight = true;
  bool panelPositionBottom = true;

  bool showSeconds = true;

  List<int> accentColor = [255, 26, 208, 111];
  List<int> backgroundColor = [255, 0, 0, 0];
  List<int> backgroundColor2 = [255, 34, 34, 34];
  List<int> panelColor = [204, 0, 0, 0];
  List<int> fontColor = [255, 255, 255, 255];

  Set<Application> _pinnedApps = {};

  Set<Application> get pinnedApps => _pinnedApps;
  set pinApp(Application app) {
    _pinnedApps.add(app);
    appsPinning.sink.add('pinned');
  }

  set unpinApp(Application app) {
    _pinnedApps.remove(app);
    appsPinning.sink.add('unpinned');
  }

  bool isAppPinned(Application app) => _pinnedApps.contains(app);

  Color getColor(List<int> argb) =>
      Color.fromARGB(argb[0], argb[1], argb[2], argb[3]);

  void update() {
    settings.sink.add('updated');
  }
}

var config = Config();
