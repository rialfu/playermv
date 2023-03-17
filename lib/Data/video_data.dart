import 'package:playermv/Data/custom_exception.dart';

class VideoData {
  final String path;
  final String name;
  String? thumbnail;
  VideoData(this.name, this.path, this.thumbnail);
  void updateThumbnail(String? thumbnail) {
    this.thumbnail = thumbnail;
  }
}

class VideoThumbnailCache {
  final String path;
  final String nameFile;
  final String nameThumbnail;
  VideoThumbnailCache(this.nameFile, this.path, this.nameThumbnail);
}

class VideoPathFolder {
  final String path;
  final String name;
  final List<VideoData> data;
  VideoPathFolder(this.name, this.path, this.data);
  factory VideoPathFolder.fromJSON(Map<String, dynamic> data) {
    if (!data.containsKey('path') ||
        !data.containsKey('name') ||
        !data.containsKey('video')) {
      throw CustomException('json not format suitable');
    }
    return VideoPathFolder("", "", []);
  }
}
