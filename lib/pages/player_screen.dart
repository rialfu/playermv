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
  ValueNotifier<bool> valueNotifier = ValueNotifier(false);
  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
      // DeviceOrientation.portraitUp,
      // DeviceOrientation.landscapeLeft,
    ]);
    loadVideo();
  }

  @override
  void dispose() {
    cc?.dispose();
    vp?.dispose();
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
    }
  }

  @override
  Widget build(BuildContext context) {
    // print("orientation");
    // WidgetsBinding.instance!.addPostFrameCallback((timeStamp) => rerenderCheck);
    return OrientationBuilder(
        // stream: null,
        builder: (context, orientation) {
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
                // return Stack(
                //   alignment: Alignment.center,
                //   children: [
                //     Container(
                //       padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                //       decoration: BoxDecoration(
                //         border: Border.all(width: 5, color: Colors.black54),
                //       ),
                //       child: Row(),
                //     )
                //   ],
                // );
              }()),
            ),
          ),
        ),
      );
    });
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
  bool active = false;
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
    timer?.cancel();
    if (widget.vn?.value ?? false == true) {
      timer = Timer(const Duration(seconds: 3), () => widget.vn?.value = false);
    }
    setState(() {
      active = widget.vn?.value ?? false;
    });
  }

  void playPause() {
    // widget.vp.
    if (widget.cc.isPlaying) {
      widget.cc.pause();
      widget.vp.pause();
    } else {
      widget.vp.play();
      widget.cc.play();
    }
  }

  @override
  Widget build(BuildContext context) {
    // print(active);
    // print("aktif");
    var width = MediaQuery.of(context).size.width;
    var padding = MediaQuery.of(context).padding;
    var height =
        MediaQuery.of(context).size.height - padding.top - padding.bottom;
    return WidgetCustom.createContainerCustom(
      context,
      height,
      active,
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
                    String text = duration.inSeconds > 3600
                        ? '$hours:$minutes'
                        : '$minutes:$seconds';
                    return ConstrainedBox(
                      constraints: BoxConstraints(minWidth: width * 0.1),
                      child: Text(
                        text,
                        // '$hours:$minutes:$seconds',
                      ),
                    );
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
                        },
                        onTapUp: (details, change) {
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
                      !widget.cc.isFullScreen
                          ? widget.cc.enterFullScreen()
                          : widget.cc.exitFullScreen();
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
