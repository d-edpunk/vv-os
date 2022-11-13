import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'config.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: config.getColor(config.backgroundColor),
        appBar: AppBar(
            title: Text('Settings',
                style: TextStyle(color: config.getColor(config.fontColor))),
            backgroundColor: config.getColor(config.backgroundColor2)),
        body: Column(children: [
          ColorChanger('Accent Color',
              color: config.getColor(config.accentColor),
              onChangeColor: (color) {
            config.accentColor = [
              color.alpha,
              color.red,
              color.green,
              color.blue
            ];
            config.update();
          }),
          ColorChanger('Background Color',
              color: config.getColor(config.backgroundColor),
              onChangeColor: (color) {
            config.backgroundColor = [
              color.alpha,
              color.red,
              color.green,
              color.blue
            ];
            config.update();
          }),
          ColorChanger('Background Color 2',
              color: config.getColor(config.backgroundColor2),
              onChangeColor: (color) {
            config.backgroundColor2 = [
              color.alpha,
              color.red,
              color.green,
              color.blue
            ];
            config.update();
          }),
          ColorChanger('Font Color', color: config.getColor(config.fontColor),
              onChangeColor: (color) {
            config.fontColor = [
              color.alpha,
              color.red,
              color.green,
              color.blue
            ];
            config.update();
          }),
          ColorChanger('Panel Color', color: config.getColor(config.panelColor),
              onChangeColor: (color) {
            config.panelColor = [
              color.alpha,
              color.red,
              color.green,
              color.blue
            ];
            config.update();
          })
        ]));
  }
}

class ColorChanger extends StatefulWidget {
  final Color color;
  final String name;
  void Function(Color color) onChangeColor;

  ColorChanger(this.name,
      {required this.color, required this.onChangeColor, super.key});

  @override
  State<ColorChanger> createState() => _ColorChangerState(name,
      pickerColor: color, currentColor: color, onChangeColor: onChangeColor);
}

class _ColorChangerState extends State<ColorChanger> {
  Color pickerColor;
  Color currentColor;
  final String name;
  void Function(Color color) onChangeColor;

  _ColorChangerState(this.name,
      {required this.pickerColor,
      required this.currentColor,
      required this.onChangeColor});

  void changeColor(Color color) {
    setState(() => pickerColor = color);
    onChangeColor(color);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.all(10),
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: pickerColor),
            child: Text(name,
                style: TextStyle(color: config.getColor(config.fontColor))),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Pick a color!'),
                  content: SingleChildScrollView(
                    child: ColorPicker(
                      pickerColor: pickerColor,
                      onColorChanged: changeColor,
                    ),
                  ),
                  actions: <Widget>[
                    ElevatedButton(
                      child: const Text('Got it'),
                      onPressed: () {
                        setState(() => currentColor = pickerColor);
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              );
            }));
  }
}
