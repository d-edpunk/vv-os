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
    return Container(
      width: getWidth(context),
      height: getHeight(context),
      decoration: BoxDecoration(
        color: Color(prefs?.getInt('backgroundColor') ?? 0xCC000000)
      ),
      child: FutureBuilder(
        future: DeviceApps.getInstalledApplications(includeSystemApps: true, includeAppIcons: true, onlyAppsWithLaunchIntent: true),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return MenuWithSearchBar(snapshot.data);
          }

          return Center(child: CircularProgressIndicator(color: Color(prefs?.getInt('accentColor') ?? 0xFF1AD06F)));
        }
      )
    );
  }
}

class MenuWithSearchBar extends StatefulWidget {
  List<Application>? apps;

  MenuWithSearchBar(this.apps, {super.key});

  @override
  State<MenuWithSearchBar> createState() => _MenuWithSearchBarState(apps);
}

class _MenuWithSearchBarState extends State<MenuWithSearchBar> {
  List<Application>? apps;
  String? query;

  _MenuWithSearchBarState(this.apps);

  @override
  Widget build(BuildContext context) {

    return ListView(children: List.generate(apps?.length ?? 0, (index) {
      if (apps![index].appName.toLowerCase().contains(query?.toLowerCase() ?? '')) {
        return AppCard(apps![index]);
      } else {
        return const SizedBox();
      }
    })..insert(0, TextField(
      onSubmitted: (str) {
        setState(() {
          query = str;
        });
      },
    )));
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
          style: ElevatedButton.styleFrom(backgroundColor: Color(prefs?.getInt('backgroundColor2') ?? 0xFF222222), shadowColor: const Color(0x00000000)),
          onPressed: (() {
            if (!_open) {
              app.openApp();
            }
          }),
          onLongPress: (() {
            setState(() {_open = !_open;});
          }),
          child: Row(children: [
            Container(margin: const EdgeInsets.symmetric(vertical: 10), child: Image.memory((app as ApplicationWithIcon).icon, height: k * 0.17)),
            Container(margin: const EdgeInsets.only(left: 10), child: 
              _open 
              ? Row(children:[ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Color(prefs?.getInt('accentColor') ?? 0xFF1AD06F)),
                  onPressed: () {
                    _open = false;
                  },
                  child: Icon(Icons.push_pin, color: Color(prefs?.getInt('fontColor') ?? 0xFFFFFFFF)),
                ),
                Container(margin: const EdgeInsets.only(left: 10), child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Color(prefs?.getInt('accentColor') ?? 0xFF1AD06F)),
                  onPressed: () {
                    app.openSettingsScreen();
                    _open = false;
                  },
                  child: Icon(Icons.settings, color: Color(prefs?.getInt('fontColor') ?? 0xFFFFFFFF)))),
                Container(margin: const EdgeInsets.only(left: 10), child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Color(prefs?.getInt('accentColor') ?? 0xFF1AD06F)),
                  onPressed: () {
                    app.uninstallApp();
                    _open = false;
                  },
                  child: Icon(Icons.delete, color: Color(prefs?.getInt('fontColor') ?? 0xFFFFFFFF))))])
              : Text(
                app.appName,
                style: TextStyle(
                  color: Color(prefs?.getInt('fontColor') ?? 0xFFFFFFFF),
                  fontSize: 15.5
                ))
            )
          ])
        )
      ])
    );
  }
}
