import 'package:flutter/material.dart';
import 'package:device_apps/device_apps.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    var k = width < height ? width : height;

    return Scaffold(
        backgroundColor: Colors.black,
        body: FutureBuilder(
            future: DeviceApps.getInstalledApplications(
                onlyAppsWithLaunchIntent: true,
                includeSystemApps: true,
                includeAppIcons: true),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                var apps = snapshot.data ?? [];
                var result = <AppString>[];
                for (var el in apps) {
                  result.add(AppString(el));
                }
                return ListView(children: result);
              }

              return const Center(child: CircularProgressIndicator());
            }));
  }
}

class AppString extends StatefulWidget {
  Application app;

  AppString(this.app, {super.key});

  @override
  State<AppString> createState() => _AppStringState(app);
}

class _AppStringState extends State<AppString> {
  Application app;

  _AppStringState(this.app);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.all(5),
        child: ElevatedButton(
            onPressed: () {
              app.openApp();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            child: Row(children: [
              //Image.memory(app.image),
              Text(app.appName,
                  style: const TextStyle(color: Colors.white, fontSize: 18))
            ])));
  }
}
