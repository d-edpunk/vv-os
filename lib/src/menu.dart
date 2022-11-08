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
    /*var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    var k = width < height ? width : height;*/

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
                var result = <AppCard>[];
                for (var el in apps) {
                  result.add(AppCard(el));
                }
                return GridView.count(crossAxisCount: 2, children: result);
              }

              return const Center(child: CircularProgressIndicator());
            }));
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
  bool open = false;

  _AppCardState(this.app);

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    var k = width < height ? width : height;

    return Container(
        margin: const EdgeInsets.fromLTRB(10, 15, 10, 0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: open ? Colors.grey : const Color(0x00000000)),
        child: Column(children: [
          !open
              ? Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: const Color(0xFF222222)),
                  margin: const EdgeInsets.only(bottom: 5),
                  padding: const EdgeInsets.all(5),
                  width: k * 0.5 - 20,
                  height: k * 0.5 - 20,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0x00000000),
                          shadowColor: const Color(0x00000000)),
                      onPressed: () {
                        app.openApp();
                      },
                      onLongPress: () {
                        setState(() {
                          open = true;
                        });
                      },
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                                margin: const EdgeInsets.all(10),
                                child: Image.memory(
                                    (app as ApplicationWithIcon).icon,
                                    width: k * 0.175)),
                            Container(
                                margin: const EdgeInsets.all(5),
                                child: Flexible(
                                    child: Text(app.appName,
                                        style: const TextStyle(
                                            color: Colors.white, fontSize: 15),
                                        textAlign: TextAlign.center)))
                          ])))
              : Container(
                  width: k * 0.5 - 20,
                  height: k * 0.5 - 20,
                  padding: const EdgeInsets.all(10),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0x00000000),
                                    shadowColor: const Color(0x00000000)),
                                onPressed: () {
                                  app.openSettingsScreen();
                                },
                                child: const Icon(Icons.settings),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0x00000000),
                                    shadowColor: const Color(0x00000000)),
                                onPressed: () {
                                  app.uninstallApp();
                                },
                                child: const Icon(Icons.delete),
                              ),
                            ]),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0x00000000),
                              shadowColor: const Color(0x00000000)),
                          onPressed: () {
                            setState(() {
                              open = false;
                            });
                          },
                          child: const Icon(Icons.close),
                        ),
                      ])),
        ]));
  }
}
