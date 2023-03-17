import 'dart:async';
import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:playermv/Custom/custom_slider.dart';
import 'package:playermv/Tools/widget_custom.dart';
// import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

class PlayerScreen extends StatefulWidget {
  final String path;
  const PlayerScreen({super.key, required this.path});

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  VideoPlayerController? vp;
  ChewieController? cc;
  ValueNotifier<bool> valueNotifier = ValueNotifier(true);
  Timer? timer;
  @override
  void initState() {
    super.initState();
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
    loadVideo();
    valueNotifier.addListener(listenerValueNotifier);
  }

  @override
  void dispose() {
    cc?.dispose();
    vp?.dispose();
    timer?.cancel();
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
    //     overlays: SystemUiOverlay.values);
    super.dispose();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      // DeviceOrientation.landscapeLeft,
    ]);
  }

  Future<void> loadVideo() async {
    File file = File(widget.path);
    if (file.existsSync()) {
      VideoPlayerController initializeVP = VideoPlayerController.file(file);
      await initializeVP.initialize();
      ChewieController initializeCC = ChewieController(
        videoPlayerController: initializeVP,
        autoPlay: true,
        showControls: false,
      );
      // initializeCC.enterFullScreen();
      setState(() {
        cc = initializeCC;
        vp = initializeVP;
      });
      // initializeCC.
      // SystemChrome
      // SystemChrome.setPreferredOrientations([
      //   DeviceOrientation.landscapeRight,
      //   DeviceOrientation.landscapeLeft,
      // ]);
    }
  }

  void listenerValueNotifier() {
    // timer?.cancel();
    // timer = null;
    // if (valueNotifier.value) {
    //   timer = Timer.periodic(const Duration(seconds: 3), (timer) {
    //     valueNotifier.value = false;
    //   });
    // }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: GestureDetector(
          onTap: () {
            valueNotifier.value = !valueNotifier.value;
          },
          child: Container(
            color: Colors.black,
            width: double.infinity,
            height: double.infinity,
            child: (() {
              if (vp != null && cc != null) {
                return Stack(
                  children: [
                    PlayerVideo(cc!),
                    Positioned(
                      left: 0,
                      bottom: 0,
                      child: ControllerComponent(vp!, cc!, vn: valueNotifier),
                    ),
                  ],
                );
                // return PlayerVideo(cc!);
              }
              return Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                    decoration: BoxDecoration(
                      border: Border.all(width: 5, color: Colors.black54),
                    ),
                    child: Row(),
                  )
                ],
              );
            }()),
          ),
        ),
      ),
    );
  }
}

class PlayerVideo extends StatelessWidget {
  final ChewieController controller;
  // final VideoPlayerController controller;
  const PlayerVideo(this.controller, {super.key});

  @override
  Widget build(BuildContext context) {
    // return VideoPlayer(controller);
    return Chewie(controller: controller);
  }
}

class ControllerComponent extends StatefulWidget {
  final VideoPlayerController vp;
  final ChewieController cc;
  final ValueNotifier<bool>? vn;
  const ControllerComponent(this.vp, this.cc, {super.key, this.vn});

  @override
  State<ControllerComponent> createState() => _ControllerComponentState();
}

class _ControllerComponentState extends State<ControllerComponent> {
  bool active = true;
  int max = 0;
  int now = 100;
  int nowMicro = 0;
  Timer? timer;
  @override
  void initState() {
    super.initState();
    widget.vp.addListener(listenerVideo);
    widget.vn?.addListener(listenerValueNotifier);
    setState(() {
      now = widget.vp.value.position.inSeconds;
      max = widget.vp.value.duration.inSeconds;
      active = widget.vn?.value ?? false;
      // nowMicro = widget.vp.value.position.inMicroseconds;
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    widget.vp.removeListener(listenerVideo);
    super.dispose();
  }

  void listenerVideo() {
    setState(() {
      now = widget.vp.value.position.inSeconds;
      // nowMicro = widget.vp.value.position.inMilliseconds;
    });
  }

  void listenerValueNotifier() {
    setState(() {
      active = widget.vn?.value ?? false;
    });
  }

  void playPause() {
    // widget.vp.
    if (widget.cc.isPlaying) {
      widget.cc.pause();
      widget.vp.pause();
      // widget.vp.removeListener(listenerVideo);
    } else {
      // widget.vp.seekTo(Duration(microseconds: nowMicro));
      widget.vp.play();
      widget.cc.play();
      // widget.vp.addListener(listenerVideo);
    }
  }

  @override
  Widget build(BuildContext context) {
    print('${widget.vn?.value}');
    // int n = now;
    var width = MediaQuery.of(context).size.width;
    var padding = MediaQuery.of(context).padding;
    var height =
        MediaQuery.of(context).size.height - padding.top - padding.bottom;
    return WidgetCustom.createContainerCustom(
      context,
      height,
      active,
      // active,
      maxHeight: 90,
      child: Wrap(
        children: [
          Column(
            children: [
              Row(
                children: [
                  (() {
                    Duration duration = Duration(seconds: now);
                    String hours = duration.inHours.toString().padLeft(0, '2');
                    String minutes = duration.inMinutes
                        .remainder(60)
                        .toString()
                        .padLeft(2, '0');
                    String seconds = duration.inSeconds
                        .remainder(60)
                        .toString()
                        .padLeft(2, '0');
                    return ConstrainedBox(
                        constraints: BoxConstraints(minWidth: width * 0.1),
                        child: Text('$hours:$minutes:$seconds'));
                  }()),
                  (() {
                    // return Slider(
                    //     value: now.toDouble(),
                    //     max: max.toDouble(),
                    //     onChanged: (change) {});
                    return Expanded(
                      flex: 1,
                      child: CustomSlider(
                        position: now,
                        max: max,
                        onTapDown: (details, change) {
                          widget.vn?.value = true;
                          widget.vp.removeListener(listenerVideo);
                          widget.vp.seekTo(Duration(seconds: change));
                          widget.vp.addListener(listenerVideo);
                        },
                        onPanDown: (details) {
                          widget.vn?.value = true;
                          widget.vp.removeListener(listenerVideo);
                        },
                        onPanUpdate: (details, change) {
                          widget.vn?.value = true;
                          // widget.vp.seekTo(Duration(seconds: change));
                        },
                        onPanEnd: (details, change) {
                          widget.vn?.value = true;
                          widget.vp.seekTo(Duration(seconds: change));
                          widget.vp.addListener(listenerVideo);
                        },
                      ),
                    );
                  }()),

                  SizedBox(
                    width: width * 0.1,
                  )
                  // Expanded(
                  //   flex: 2,
                  //   child: Container(),
                  // ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: playPause,
                    icon: Icon(
                      (widget.cc.isPlaying ? Icons.pause : Icons.play_arrow),
                      size: 28,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      print('full screen:${widget.cc.isFullScreen}');
                      // Orientation orientation =
                      //     MediaQuery.of(context).orientation;

                      // if(widget.cc.isFullScreen)
                      // orientation == Orientation.portrait
                      // ? SystemChrome.setPreferredOrientations([
                      //     DeviceOrientation.landscapeRight,
                      //     DeviceOrientation.landscapeLeft,
                      //   ])
                      // : SystemChrome.setPreferredOrientations([
                      //     DeviceOrientation.portraitUp,
                      //   ]);
                      !widget.cc.isFullScreen
                          ? widget.cc.enterFullScreen()
                          : widget.cc.exitFullScreen();
                      // Orientation orientation =
                      //     MediaQuery.of(context).orientation;
                      // orientation == Orientation.portrait
                      //     ? SystemChrome.setPreferredOrientations([
                      //         DeviceOrientation.landscapeRight,
                      //         DeviceOrientation.landscapeLeft,
                      //       ])
                      //     : SystemChrome.setPreferredOrientations([
                      //         DeviceOrientation.portraitUp,
                      //       ]);
                    },
                    icon: const Icon(Icons.fullscreen),
                  )
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}
