import 'package:flutter/material.dart';
import 'call.dart';

class Calls extends StatefulWidget {
  const Calls({super.key});

  @override
  State<Calls> createState() => _CallsState();
}

class _CallsState extends State<Calls> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Звонки'),
        backgroundColor: Colors.green,
      ),
      body: Column(children: [
        Contact(name: 'ВВ', avatar: 'assets/images/vv.jpg'),
        Contact(name: 'ВМ', avatar: 'assets/images/vm.jpg'),
        Contact(name: 'ЕС', avatar: 'assets/images/es.jpg'),
        Contact(name: 'НА'),
      ]),
    );
  }
}

class Contact extends StatefulWidget {
  String name;
  String? avatar;

  Contact({required this.name, this.avatar, super.key});

  @override
  State<Contact> createState() => _ContactState(name, avatar);
}

class _ContactState extends State<Contact> {
  String name;
  String? avatar;

  _ContactState(this.name, this.avatar);

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Container(
        margin: const EdgeInsets.all(5),
        child: Text(
          name,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      Container(
        margin: const EdgeInsets.all(5),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
          child: const Icon(Icons.call),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Call(name: name, avatar: avatar)));
          },
        ),
      ),
    ]);
  }
}
