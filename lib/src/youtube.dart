import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class Youtube extends StatefulWidget {
  Youtube({super.key});

  @override
  State<Youtube> createState() => _YoutubeState();
}

class _YoutubeState extends State<Youtube> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/video/video.mp4')
      ..initialize().then((_) {
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    _controller.play();

    return Scaffold(
        appBar:
            AppBar(backgroundColor: Colors.red, title: const Text('YouTube')),
        body: Column(children: [
          _controller.value.isInitialized
              ? AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                )
              : Container(),
          Container(
              margin: const EdgeInsets.all(7),
              child: const Text(
                  'Rick Astley - Never Gonna Give You Up (Official Music Video)',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ))),
          Container(
              margin: const EdgeInsets.all(7),
              child: const Text('1,3 млрд просмотров · 13 лет назад',
                  style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ))),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            ElevatedButton(
              onPressed: () {},
              child: Row(children: [
                const Icon(Icons.thumb_up),
                Container(
                    margin: const EdgeInsets.only(left: 7),
                    child: const Text('13 млн',
                        style: TextStyle(fontWeight: FontWeight.bold)))
              ]),
            ),
            Container(
                margin: const EdgeInsets.only(left: 10),
                child: ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                    onPressed: () {},
                    child: const Icon(Icons.thumb_down))),
            Container(
                margin: const EdgeInsets.only(left: 10),
                child: ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                    onPressed: () {},
                    child: const Icon(Icons.share)))
          ])
        ]));
  }
}
