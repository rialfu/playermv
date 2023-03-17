import 'dart:convert';
import 'dart:io';

import 'package:mime/mime.dart';
import 'package:playermv/Data/custom_exception.dart';
import 'package:playermv/Data/video_data.dart';
// import 'package:collection/collection.dart';

abstract class VideoRepo {
  Future<List<VideoPathFolder>> getVideoList();
  Future<List<VideoPathFolder>?> getPathFromStorage();
  Future<void> saveToFile(List<VideoPathFolder> data);
}

class VideoServices implements VideoRepo {
  //
  final String pathAndroid = '/storage/emulated/0';
  @override
  Future<List<VideoPathFolder>> getVideoList() async {
    return await openDir(pathAndroid);
  }

  Future<List<VideoPathFolder>> openDir(String path) async {
    Directory dir = Directory(path);
    List<VideoPathFolder> listPath = [];
    List<VideoData> listVideo = [];
    // bool containsVideo = false;
    if (!dir.existsSync()) return [];

    List<FileSystemEntity> list = dir.listSync();
    for (final element in list) {
      if (element is File && element.path.endsWith('nomedia')) {
        return [];
      }
    }
    for (final element in list) {
      if (element.path == '/storage/emulated/0/Android') continue;
      if (element is File) {
        String? mime = lookupMimeType(element.path);
        if (mime?.startsWith('video') ?? false) {
          listVideo.add(
            VideoData(
              element.path.split('/').last,
              element.path,
              null,
            ),
          );
        }
      } else if (element is Directory) {
        listPath.addAll(await openDir(element.path));
      }
    }
    if (listVideo.isNotEmpty) {
      String nameFolder = path.split('/').last;
      nameFolder = nameFolder == '0' ? 'Main' : nameFolder;
      listPath.add(VideoPathFolder(nameFolder, path, listVideo));
    }
    return listPath;
  }

  @override
  Future<void> saveToFile(List<VideoPathFolder> dataList) async {
    String data = jsonEncode(dataList);
    print(data);
    // File file = File("/storage/emulated/0/playermv/listPath");
    // RandomAccessFile raf = file.openSync(mode: FileMode.writeOnly);
    // raf.writeByteSync(value)
  }

  @override
  Future<List<VideoPathFolder>?> getPathFromStorage() async {
    // Directory dir = Directory(path);
    File listPathFile = File("/storage/emulated/0/playermv/listPath");
    if (listPathFile.existsSync()) {
      String strJSON = listPathFile.readAsStringSync();
      strJSON = jsonEncode(strJSON);
      List<Map<String, dynamic>> dataMapList = json.decode(strJSON);
      try {
        List<VideoPathFolder>.from(
            dataMapList.map((e) => VideoPathFolder.fromJSON(e)));
      } on CustomException catch (err) {
        print(err.toString());
        // listPathFile.deleteSync();
      }
    }
    return null;
  }
}
