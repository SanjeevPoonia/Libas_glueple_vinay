import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class Controls extends StatelessWidget {
  const Controls({Key? key, required this.controller,required this.iconSize})
      : super(key: key);

  static const List<Duration> _exampleCaptionOffsets = <Duration>[
    Duration(seconds: -10),
    Duration(seconds: -3),
    Duration(seconds: -1, milliseconds: -500),
    Duration(milliseconds: -250),
    Duration(milliseconds: 0),
    Duration(milliseconds: 250),
    Duration(seconds: 1, milliseconds: 500),
    Duration(seconds: 3),
    Duration(seconds: 10),
  ];
  static const List<double> _examplePlaybackRates = <double>[
    0.25,
    0.5,
    1.0,
    1.5,
    2.0,
    3.0,
    5.0,
    10.0,
  ];

  final VideoPlayerController controller;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 50),
          reverseDuration: const Duration(milliseconds: 200),
          child: controller.value.isPlaying
              ?  SizedBox.shrink(
            child: Container(
              color: Colors.black26,
              child: const Center(
                child: Icon(
                  Icons.pause,
                  color: Colors.white,
                  size: 100.0,
                  semanticLabel: 'Play',
                ),
              ),
            ),
          )
              : Container(
            color: Colors.black26,
            child:  Center(
              child: Icon(
                Icons.play_arrow,
                color: Colors.white,
                size:iconSize,
                semanticLabel: 'Play',
              ),
            ),
          ),
        ),
      /*  GestureDetector(
          onTap: () {
            //controller.value.isPlaying ? controller.pause() : controller.play();
          },
        ),*/

      ],
    );
  }
}