import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
// import 'package:playermv/Bloc/DataGlobal/video_bloc.dart';
// import 'package:playermv/Bloc/DataGlobal/video_state.dart';
// import 'package:playermv/Bloc/States/video_state.dart';
// import 'package:playermv/Bloc/video_bloc.dart';
// import 'package:playermv/Data/video_data.dart';
import 'dart:io';

import 'package:playermv/Tools/directory_service.dart';
import 'package:playermv/pages/video_list.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool load = false;
  bool accessStorage = false;
  List<int> listWillDelete = [];
  List<String> listPath = [];
  int? choosePos;
  Future<void> loadDirectory() async {
    if (load) return;
    setState(() {
      load = true;
    });

    if (!accessStorage) {
      // ignore: avoid_print
      print("storage not granted");
      setState(() {
        load = false;
      });
      return;
    }
    try {
      // ignore: avoid_print
      print("start");

      List<String> listPathContainsVideo =
          await compute(DirectoryService.openDir, '/storage/emulated/0');
      // List<String> listPathContainsVideo = await openDir('/storage/emulated/0');
      setState(() {
        listPath = listPathContainsVideo;
      });
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
    setState(() {
      load = false;
    });

    // return null;
  }

  Future<void> askPermission() async {
    if (Platform.isAndroid) {
      PermissionStatus result = await Permission.storage.request();
      if (result.isDenied) {
        return;
      }
      result = await Permission.accessMediaLocation.request();
      if (result.isDenied) {
        return;
      }
      result = await Permission.manageExternalStorage.request();
      if (result.isDenied) {
        return;
      }
      // if (result.isDenied) {
      //   result = await Permission.manageExternalStorage.request();
      //   if (!result.isGranted) {
      //     return;
      //   }
      // }
    } else {
      return;
    }
    DirectoryService.createDirectory();
    setState(() {
      accessStorage = true;
    });
  }

  @override
  void initState() {
    super.initState();
    // SystemChrome
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    // SystemChrome.setPreferredOrientations([
    //   // DeviceOrientation.landscapeLeft,
    //   // DeviceOrientation.landscapeRight,
    //   DeviceOrientation.portraitUp,
    //   // DeviceOrientation.landscapeLeft,
    // ]);
    initialize();
  }

  Future<void> initialize() async {
    // await askPermission();
    // loadDirectory();
    // BlocProvider.of<VideoBloc>(context).add(VideoEvents.fetchVideos);
    // context.bloc<VideoBloc>().add(VideoEvents.fetchVideos);
    // context.read<VideoBloc>().add(VideoEvents.fetchVideos);
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    // double
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Container(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            width: MediaQuery.of(context).size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Player"),
                IconButton(
                    onPressed: () {
                      if (!accessStorage) {
                        return;
                      }
                      if (load) {
                        return;
                      }
                      loadDirectory();
                    },
                    icon: const Icon(Icons.autorenew_rounded,
                        color: Colors.white, size: 20))
              ],
            )),
      ),
      // body:
      // BlocBuilder<VideoBloc, VideosState>(
      //   builder: (context, state) {
      //     List<VideoPathFolder> videos = [];
      //     if (state is VideosLoadingExtend) {
      //       videos.addAll(state.videos);
      //     } else if (state is VideosLoaded) {
      //       videos.addAll(state.videos);
      //     }
      //     if (videos.isNotEmpty) {
      //       return ListView.builder(
      //         itemCount: videos.length,
      //         itemBuilder: (context, index) {
      //           return GestureDetector(
      //             child: Container(
      //               decoration: BoxDecoration(
      //                 color:
      //                     choosePos == index ? Colors.grey[200] : Colors.white,
      //                 border: Border(
      //                   bottom: BorderSide(
      //                     width: (index == listPath.length - 1) ? 0 : 1,
      //                     color: Colors.grey,
      //                   ),
      //                 ),
      //               ),
      //               padding:
      //                   EdgeInsets.fromLTRB(width * 0.05, 0, width * 0.05, 0),
      //               height: MediaQuery.of(context).size.height / 10,
      //               child: Column(
      //                 mainAxisAlignment: MainAxisAlignment.center,
      //                 crossAxisAlignment: CrossAxisAlignment.start,
      //                 children: [
      //                   Text(listPath[index].split('/').last),
      //                 ],
      //               ),
      //             ),
      //           );
      //         },
      //       );
      //     }
      //     String message = "Data Loading";
      //     if (state is VideosListError) {
      //       message = "Gagal memproses data";
      //     }
      //     return Center(
      //       child: Text(message),
      //     );
      //   },
      // ),
      body: ListView.builder(
        itemCount: listPath.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              print("ontap");
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => VideoList(path: listPath[index])));
            },
            onLongPress: () {
              print("testlong");
              setState(() {
                choosePos = index;
              });
            },
            onPanDown: (details) {
              print('panDown');
            },
            onPanEnd: (details) {
              print('panend');
            },
            onPanCancel: () {
              print('panCancel');
            },
            onLongPressCancel: () {
              print("LongPressCancel");
              setState(() {
                choosePos = null;
              });
            },
            onTapDown: (details) {
              print('ontapdown');
              setState(() {
                choosePos = index;
              });
            },
            onTapCancel: () {
              print('ontapcancel');
              setState(() {
                choosePos = null;
              });
            },
            onTapUp: (details) {
              print('ontapup');
              setState(() {
                choosePos = null;
              });
            },
            child: Container(
              constraints: const BoxConstraints(
                minHeight: 60,
              ),
              decoration: BoxDecoration(
                color: choosePos == index ? Colors.grey[200] : Colors.white,
                border: Border(
                  bottom: BorderSide(
                    width: (index == listPath.length - 1) ? 0 : 1,
                    color: Colors.grey,
                  ),
                ),
              ),
              padding: EdgeInsets.fromLTRB(
                  MediaQuery.of(context).size.width * 0.05,
                  0,
                  MediaQuery.of(context).size.width * 0.05,
                  0),
              height: MediaQuery.of(context).size.height / 10,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(listPath[index].split('/').last),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
