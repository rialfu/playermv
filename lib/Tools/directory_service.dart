import 'package:mime/mime.dart';
import 'package:playermv/Data/video_data.dart';
import 'dart:io';
import 'package:flutter/services.dart';

import 'package:video_thumbnail/video_thumbnail.dart';

class IsolateData {
  final RootIsolateToken? token;
  final Object data;
  IsolateData(this.token, this.data);
}

class DirectoryService {
  static String folderThumbnail = '/storage/emulated/0/playermv/thumbnail';
  static Future<List<String>> openDir(String path) async {
    Directory dir = Directory(path);
    List<String> listPath = [];
    bool containsVideo = false;
    if (!await dir.exists()) return [];

    List<FileSystemEntity> list = dir.listSync();

    for (final element in list) {
      if (element.path == '/storage/emulated/0/Android') continue;
      if (element is File && containsVideo == false) {
        String? mime = lookupMimeType(element.path);
        if (mime?.startsWith('video') ?? false) containsVideo = true;
        continue;
      }
      if (element is Directory) listPath.addAll(await openDir(element.path));
    }

    if (containsVideo) listPath.add(path);
    return listPath;
  }

  static Future<List<VideoData>> loadVideo(IsolateData data) async {
    BackgroundIsolateBinaryMessenger.ensureInitialized(data.token!);
    // print("start1");
    if (data.data is! String) return [];
    // print("start2");
    String path = data.data as String;
    Directory dir = Directory(path);
    if (!dir.existsSync()) return [];
    // print("start3");
    List<FileSystemEntity> list = dir.listSync();

    // List<VideoData> listVideo = [];
    Directory thumbDir = Directory(DirectoryService.folderThumbnail);
    bool thumbDirExist = thumbDir.existsSync();
    var waitList = <Future<VideoData>>[];

    for (final element in list) {
      if (element is! File) continue;
      String? mime = lookupMimeType(element.path);
      if (mime?.startsWith('video') ?? false) {
        waitList.add(setThumbnailData(element.path, thumbDirExist));
        // try{
        //
        //   String? thumbnailPath = '';
        //   if(thumbDirExist){
        //     thumbnailPath = await VideoThumbnail.thumbnailFile(
        //       video: element.path,
        //       imageFormat: ImageFormat.JPEG,
        //       maxWidth: 25,
        //       quality: 25,
        //       thumbnailPath: '/storage/emulated/0/playermv/thumbnail'
        //     );
        //   }

        //   listVideo.add(VideoData(element.path.split('/').last, element.path, thumbnailPath));
        // }catch(e){
        //   print(e.toString());
        //   continue;
        // }
      }
    }
    // List<VideoData> d = await Future.wait<VideoData>(waitList);
    // print(d);
    return await Future.wait<VideoData>(waitList);
  }

  static Future<VideoData> setThumbnailData(String path, bool exists) async {
    String? thumbnailPath;
    try {
      if (exists) {
        thumbnailPath = await VideoThumbnail.thumbnailFile(
            video: path,
            imageFormat: ImageFormat.PNG,
            // maxWidth: 50,
            // maxHeight: 50,
            quality: 25,
            thumbnailPath: DirectoryService.folderThumbnail);
      }
    } catch (e) {
      return VideoData(path.split('/').last, path, thumbnailPath);
    }
    return VideoData(path.split('/').last, path, thumbnailPath);
  }

  static void createDirectory() {
    Directory thumbDir = Directory(DirectoryService.folderThumbnail);
    if (!thumbDir.existsSync()) {
      thumbDir.createSync(recursive: true);
    }
  }
}
