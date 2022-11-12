import 'package:flutter/material.dart';
import 'package:device_apps/device_apps.dart';
import 'menu_page.dart';
import 'size.dart';
import '../main.dart' show prefs;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/wallpaper.jpg'), fit: BoxFit.cover)),
      child: Row(
          mainAxisAlignment: (prefs?.getBool('panelPositionRight') ?? true)
              ? MainAxisAlignment.end
              : MainAxisAlignment.start,
          children: [
            Column(children: const [TimeWidget()]),
            const Panel()
          ]),
    ));
  }
}

class Panel extends StatefulWidget {
  const Panel({super.key});

  @override
  State<Panel> createState() => _PanelState();
}

class _PanelState extends State<Panel> {
  @override
  Widget build(BuildContext context) {
    var k = getProportionalyFactor(context);
    return Container(
        decoration: BoxDecoration(
          color: Color(prefs?.getInt('panelColor') ?? 0xCC000000),
        ),
        width: k * 0.2,
        height: getHeight(context),
        child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
          (prefs?.getBool('openMenuByButton') ?? true)
              ? PanelButton(
                  icon: Icons.menu,
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const MenuPage()));
                  })
              : SizedBox(height: k * 0.15 + 20),
          getPinnedApps(),
        ]));
  }

  Widget getPinnedApps() {
    var result = <Widget>[];
    Future<void> f(String packageName, int id) async {
      if (await DeviceApps.isAppInstalled(packageName)) {
        result.add(PanelButton(
          image: Image.memory(
              (DeviceApps.getApp(packageName) as ApplicationWithIcon).icon),
          onPressed: () {
            DeviceApps.openApp(packageName);
          },
          onLongPress: () {
            for (var i = id; i < (prefs?.getInt('pinnedAppsCount') ?? 0); i++) {
              prefs?.setString(
                  'pinnedApp$i', prefs?.getString('pinnedApp${i + 1}') ?? '');
            }

            var newCount = (prefs?.getInt('pinnedAppsCount') ?? 1) - 1;
            prefs?.remove('pinnedApp$newCount');
            prefs?.setInt('pinnedAppsCount', newCount);
          },
        ));
      }
    }

    for (var i = 1; i <= (prefs?.getInt('pinnedAppsCount') ?? 0); i++) {
      var packageName = prefs?.getString('pinnedApp$i');
      if (packageName != null) {
        f(packageName, i);
      }
    }
    return Column(children: result);
  }
}

class PanelButton extends StatefulWidget {
  final IconData? icon;
  final Image? image;
  final void Function() onPressed;
  final void Function()? onLongPress;

  const PanelButton(
      {required this.onPressed,
      this.icon,
      this.image,
      this.onLongPress,
      super.key});

  @override
  State<PanelButton> createState() => _PanelButtonState(
      icon: icon, image: image, onPressed: onPressed, onLongPress: onLongPress);
}

class _PanelButtonState extends State<PanelButton> {
  IconData? icon;
  Image? image;
  void Function() onPressed;
  void Function()? onLongPress;

  _PanelButtonState(
      {required this.onPressed, this.icon, this.image, this.onLongPress});

  @override
  Widget build(BuildContext context) {
    var k = getProportionalyFactor(context);

    return Container(
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        height: k * 0.15,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor:
                  Color(prefs?.getInt('backgroundColor2') ?? 0xFF222222)),
          onPressed: onPressed,
          onLongPress: onLongPress,
          child: image ??
              Icon(icon ?? Icons.error,
                  color: Color(prefs?.getInt('fontColor') ?? 0xFFFFFFFF)),
        ));
  }
}

class TimeWidget extends StatefulWidget {
  const TimeWidget({super.key});

  @override
  State<TimeWidget> createState() => _TimeWidgetState();
}

class _TimeWidgetState extends State<TimeWidget> {
  String time = '';
  String date = '';
  Stream? timer;
  DateTime _current = DateTime.now();

  _TimeWidgetState() {
    timer = Stream.periodic(const Duration(seconds: 1), (i) {
      _current = _current.add(const Duration(seconds: 1));
      return _current;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.symmetric(vertical: 40, horizontal: 30),
        child: Column(children: [
          Text(time,
              style: TextStyle(
                  color: Color(prefs?.getInt('fontColor') ?? 0xFFFFFFFF),
                  fontWeight: FontWeight.bold,
                  fontSize: 50)),
          Text(date,
              style: TextStyle(
                color: Color(prefs?.getInt('fontColor2') ?? 0xFFEEEEEE),
                fontWeight: FontWeight.bold,
                fontSize: 25,
              ))
        ]));
  }

  @override
  void initState() {
    super.initState();
    timer?.listen((event) {
      var now = DateTime.now();

      var hour = now.hour.toString();
      hour = hour.length == 1 ? '0$hour' : hour;

      var min = now.minute.toString();
      min = min.length == 1 ? '0$min' : min;

      String? sec;
      if (prefs?.getBool('showSeconds') ?? true) {
        sec = now.second.toString();
        sec = sec.length == 1 ? ':0$sec' : sec;
      }

      var day = now.day.toString();
      day = day.length == 1 ? '0$day' : day;
      var monthes = <String>[
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec'
      ];
      var month = monthes[now.month - 1];
      var year = now.year;
      setState(() {
        time = '$hour:$min${sec ?? ''}';
        date = '$day $month $year';
      });
    });
  }
}
