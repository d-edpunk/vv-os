import 'package:flutter/material.dart';
import 'package:device_apps/device_apps.dart';
import 'size.dart';
import '../main.dart' show prefs;

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  @override
  Widget build(BuildContext context) {
    var k = getProportionalyFactor(context);

    return Scaffold(
        body: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/wallpaper.jpg'), fit: BoxFit.cover),
            ),
            child: Container(
                decoration: BoxDecoration(
                    color:
                        Color(prefs?.getInt('panelColor') ?? 0xCC000000)),
                child: Column(children: [
                  Container(
                      margin: const EdgeInsets.fromLTRB(10, 45, 10, 10),
                      height: k * 0.125,
                      decoration: BoxDecoration(color: Color(prefs?.getInt('backgroundColor') ?? 0xFF000000)),
                      child: TextField(
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.search, color: Color(prefs?.getInt('accentColor') ?? 0xFF1AD06F)),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), 
                            borderSide: const BorderSide(width: 0)),
                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(30), 
                            borderSide: const BorderSide(width: 0)),
                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(30), 
                            borderSide: const BorderSide(width: 0)),
                          fillColor: Color(prefs?.getInt('backgroundColor2') ?? 0xFF222222),
                          filled: true,
                        ),
                        cursorColor: Color(prefs?.getInt('accentColor') ?? 0xFF1AD06F),
                        style: TextStyle(
                          fontSize: 15,
                          color: Color(prefs?.getInt('fontColor') ?? 0xFFFFFFFF)
                        ),
                        onSubmitted: (input) {
                          setState(() {
                            query = input;
                          });
                        },
                      )),
                    AppScreen(0)
                ]))));
  }
}

class MenuWithSearchBar extends StatefulWidget {
  List<Application>? apps;

  MenuWithSearchBar(this.apps, {super.key});

  @override
  State<MenuWithSearchBar> createState() => _MenuWithSearchBarState(apps);
}

String? query;

class _MenuWithSearchBarState extends State<MenuWithSearchBar> {
  List<Application>? apps;

  _MenuWithSearchBarState(this.apps);

  @override
  Widget build(BuildContext context) {
    return ListView(
        children: List.generate(apps?.length ?? 0, (index) {
      if (apps![index]
          .appName
          .toLowerCase()
          .contains(query?.toLowerCase() ?? '')) {
        return AppCard(apps![index]);
      } else {
        return const SizedBox();
      }
    }));
  }
}

class AppCard extends StatefulWidget {
  final Application app;

  const AppCard(this.app, {super.key});

  @override
  State<AppCard> createState() => _AppCardState(app);
}

class _AppCardState extends State<AppCard> {
  final Application app;
  bool _open = false;

  _AppCardState(this.app);

  @override
  Widget build(BuildContext context) {
    var k = getProportionalyFactor(context);

    return Container(
        margin: const EdgeInsets.all(10),
        child: Column(children: [
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor:
                      Color(prefs?.getInt('backgroundColor2') ?? 0xFF222222),
                  shadowColor: const Color(0x00000000)),
              onPressed: (() {
                if (!_open) {
                  if (prefs?.getBool('openMenuByButton') ?? true) {
                    Navigator.pop(context);
                  }
                  query = null;
                  app.openApp();
                }
              }),
              onLongPress: (() {
                setState(() {
                  _open = !_open;
                });
              }),
              child: Row(children: [
                Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: Image.memory((app as ApplicationWithIcon).icon,
                        height: k * 0.17)),
                Container(
                    margin: const EdgeInsets.only(left: 10),
                    child: _open
                        ? Row(children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(
                                      prefs?.getInt('accentColor') ??
                                          0xFF1AD06F)),
                              onPressed: () {
                                _open = false;
                                if (prefs?.getBool('openMenuByButton') ??
                                    true) {
                                  Navigator.pop(context);
                                }
                              },
                              child: Icon(Icons.push_pin,
                                  color: Color(prefs?.getInt('fontColor') ??
                                      0xFFFFFFFF)),
                            ),
                            Container(
                                margin: const EdgeInsets.only(left: 10),
                                child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Color(
                                            prefs?.getInt('accentColor') ??
                                                0xFF1AD06F)),
                                    onPressed: () {
                                      _open = false;
                                      if (prefs?.getBool('openMenuByButton') ??
                                          true) {
                                        Navigator.pop(context);
                                      }
                                      app.openSettingsScreen();
                                    },
                                    child: Icon(Icons.settings,
                                        color: Color(
                                            prefs?.getInt('fontColor') ??
                                                0xFFFFFFFF)))),
                            Container(
                                margin: const EdgeInsets.only(left: 10),
                                child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Color(
                                            prefs?.getInt('accentColor') ??
                                                0xFF1AD06F)),
                                    onPressed: () {
                                      _open = false;
                                      if (prefs?.getBool('openMenuByButton') ??
                                          true) {
                                        Navigator.pop(context);
                                      }
                                      app.uninstallApp();
                                    },
                                    child: Icon(Icons.delete,
                                        color: Color(
                                            prefs?.getInt('fontColor') ??
                                                0xFFFFFFFF))))
                          ])
                        : Text(app.appName,
                            style: TextStyle(
                                color: Color(
                                    prefs?.getInt('fontColor') ?? 0xFFFFFFFF),
                                fontSize: 15.5)))
              ]))
        ]));
  }
}

class AppScreen extends StatefulWidget {
  int start;
  AppScreen(this.start, {super.key});

  @override
  State<AppScreen> createState() => _AppScreenState(start);
}

class _AppScreenState extends State<AppScreen> {
  int start;

  _AppScreenState(this.start);

  @override
  Widget build(BuildContext context) {
    var k = getProportionalyFactor(context);

    return Container(
      width: getWidth(context),
      height: getHeight(context) - k * 0.125 - 55,
      child: FutureBuilder(
        future: DeviceApps.getInstalledApplications(includeAppIcons: true, includeSystemApps: true, onlyAppsWithLaunchIntent: true),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            var apps = snapshot.data;

            return ListView(children: List.generate(apps?.length ?? 0, (index) => AppCard(apps![index])));
          } else {
            return Center(child: CircularProgressIndicator(color: Color(prefs?.getInt('accentColor') ?? 0xFF1AD06F)));
          }
        }
      )
    );
  }
}
