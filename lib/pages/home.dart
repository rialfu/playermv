import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:playermv/Bloc/video_path/video_bloc.dart';
import 'package:playermv/Bloc/video_path/video_event.dart';
import 'package:playermv/Bloc/video_path/video_state.dart';
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
  List<String> listWillDelete = [];
  // List<String> listPath = [];
  int? choosePos;

  Future<void> askPermission() async {}

  @override
  void initState() {
    super.initState();
    // SystemChrome
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    initialize();
  }

  Future<void> initialize() async {
    context.read<VideoBloc>().add(VideoLoad());
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    print(choosePos);
    // double
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Container(
          width: MediaQuery.of(context).size.width,
          child: choosePos == null
              ? Stack(
                  children: [
                    const Text("Player"),
                    Positioned(
                      top: 0.0,
                      right: 30.0,
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        onPressed: () {
                          context.read<VideoBloc>().add(VideoLoad());
                        },
                        icon: const Icon(
                          Icons.autorenew_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 0.0,
                      right: 0.0,
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        onPressed: () {
                          // context.read<VideoBloc>().add(VideoLoad());
                        },
                        icon: const Icon(
                          Icons.more_vert_rounded,
                          color: Colors.white,
                          size: 25,
                        ),
                      ),
                    )
                  ],
                )
              // Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //     children: [
              //       const Text("Player"),
              //       IconButton(
              //         onPressed: () {
              //           context.read<VideoBloc>().add(VideoLoad());
              //         },
              //         icon: const Icon(
              //           Icons.autorenew_rounded,
              //           color: Colors.white,
              //           size: 20,
              //         ),
              //       )
              //     ],
              //   )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: () {
                        setState(() {
                          choosePos = null;
                        });
                      },
                      icon: const Icon(Icons.arrow_back_rounded,
                          color: Colors.white, size: 20),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.delete,
                          color: Colors.white, size: 20),
                    )
                  ],
                ),
        ),
      ),
      body: BlocBuilder<VideoBloc, VideoState>(
        builder: (context, state) {
          print(state.listPath);
          if (state.status == VideoStatus.initial) {
            return const Center(
              child: Text("Please wait"),
            );
          } else if (state.status == VideoStatus.success) {
            return ListView.builder(
              itemCount: state.listPath.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    if (choosePos == null) {
                      context
                          .read<VideoBloc>()
                          .add(ChoosePath(state.listPath[index]));
                      return;
                    }
                    bool found = listWillDelete.contains(state.listPath[index]);
                    if (found) {
                      listWillDelete.removeWhere(
                          (element) => element == state.listPath[index]);
                      return;
                    }
                    setState(() {
                      listWillDelete = [
                        ...listWillDelete,
                        state.listPath[index]
                      ];
                    });

                    // Navigator.of(context).push(MaterialPageRoute(
                    //     builder: (context) =>
                    //         VideoList(path: listPath[index])));
                  },
                  onLongPress: () {
                    print("testlong");
                    setState(() {
                      choosePos = index;
                      listWillDelete = [
                        ...listWillDelete,
                        state.listPath[index]
                      ];
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
                    // setState(() {
                    //   choosePos = null;
                    // });
                  },
                  onTapDown: (details) {
                    print('ontapdown');
                    // setState(() {
                    //   choosePos = index;
                    // });
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
                      color:
                          choosePos == index ? Colors.grey[200] : Colors.white,
                      border: Border(
                        bottom: BorderSide(
                          width: (index == state.listPath.length - 1) ? 0 : 1,
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
                        Text(state.listPath[index].split('/').last),
                      ],
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(child: Text("gagal"));
          }
        },
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
      // body: ListView.builder(
      //   itemCount: listPath.length,
      //   itemBuilder: (context, index) {
      //     return GestureDetector(
      //       onTap: () {
      //         print("ontap");
      //         Navigator.of(context).push(MaterialPageRoute(
      //             builder: (context) => VideoList(path: listPath[index])));
      //       },
      //       onLongPress: () {
      //         print("testlong");
      //         setState(() {
      //           choosePos = index;
      //         });
      //       },
      //       onPanDown: (details) {
      //         print('panDown');
      //       },
      //       onPanEnd: (details) {
      //         print('panend');
      //       },
      //       onPanCancel: () {
      //         print('panCancel');
      //       },
      //       onLongPressCancel: () {
      //         print("LongPressCancel");
      //         setState(() {
      //           choosePos = null;
      //         });
      //       },
      //       onTapDown: (details) {
      //         print('ontapdown');
      //         setState(() {
      //           choosePos = index;
      //         });
      //       },
      //       onTapCancel: () {
      //         print('ontapcancel');
      //         setState(() {
      //           choosePos = null;
      //         });
      //       },
      //       onTapUp: (details) {
      //         print('ontapup');
      //         setState(() {
      //           choosePos = null;
      //         });
      //       },
      //       child: Container(
      //         constraints: const BoxConstraints(
      //           minHeight: 60,
      //         ),
      //         decoration: BoxDecoration(
      //           color: choosePos == index ? Colors.grey[200] : Colors.white,
      //           border: Border(
      //             bottom: BorderSide(
      //               width: (index == listPath.length - 1) ? 0 : 1,
      //               color: Colors.grey,
      //             ),
      //           ),
      //         ),
      //         padding: EdgeInsets.fromLTRB(
      //             MediaQuery.of(context).size.width * 0.05,
      //             0,
      //             MediaQuery.of(context).size.width * 0.05,
      //             0),
      //         height: MediaQuery.of(context).size.height / 10,
      //         child: Column(
      //           mainAxisAlignment: MainAxisAlignment.center,
      //           crossAxisAlignment: CrossAxisAlignment.start,
      //           children: [
      //             Text(listPath[index].split('/').last),
      //           ],
      //         ),
      //       ),
      //     );
      //   },
      // ),
    );
  }
}
