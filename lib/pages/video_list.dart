import 'package:flutter/material.dart';
import 'dart:io';
import 'package:playermv/Data/video_data.dart';
import 'package:playermv/Tools/directory_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:playermv/pages/player_screen.dart';

class VideoList extends StatefulWidget {
  final String path;
  const VideoList({super.key, required this.path});

  @override
  State<VideoList> createState() => _VideoListState();
}

class _VideoListState extends State<VideoList> {
  List<VideoData> data = [];
  Future<void> loadVideo() async {
    try {
      RootIsolateToken token = RootIsolateToken.instance!;
      List<VideoData> dataVideo = await compute(
          DirectoryService.loadVideo, IsolateData(token, widget.path));
      // print(data.length);
      setState(() {
        data = dataVideo;
      });
    } catch (e) {
      // print(e.toString());
    }
    //
  }

  @override
  void initState() {
    super.initState();

    loadVideo();
  }

  double setHeightItem(BuildContext context) {
    var padding = MediaQuery.of(context).viewPadding;
    var heightScreen = MediaQuery.of(context).size.height;
    double height = (heightScreen - padding.top - padding.bottom) / 10;
    return height;
  }

  @override
  Widget build(BuildContext context) {
    double heightItem = setHeightItem(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.path.split('/').last),
      ),
      body: ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => PlayerScreen(path: data[index].path),
              ),
            ),
            child: Container(
              padding: EdgeInsets.fromLTRB(
                MediaQuery.of(context).size.width * 0.05,
                10,
                MediaQuery.of(context).size.width * 0.05,
                10,
              ),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    width: (index == data.length - 1) ? 0 : 1,
                    color: Colors.grey,
                  ),
                ),
              ),
              constraints: const BoxConstraints(minHeight: 60),
              height: heightItem,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  data[index].thumbnail != null
                      ? Container(
                          margin: const EdgeInsets.only(right: 8.0),
                          width: (heightItem - 20) * 1.6,
                          height: heightItem - 20,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: FileImage(
                                File(data[index].thumbnail ?? ''),
                              ),
                            ),
                          ),
                        )
                      : SizedBox(
                          width: (heightItem - 20) * 1.6,
                          height: heightItem,
                        ),
                  Flexible(
                    child: Text(
                      data[index].name.split('.').first,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
