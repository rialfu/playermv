import 'package:equatable/equatable.dart';
import 'package:playermv/Data/video_data.dart';

enum VideoStatus { initial, success, failure }

class VideoState extends Equatable {
  const VideoState({
    this.status = VideoStatus.initial,
    this.videos = const <VideoData>[],
    this.listPath = const <String>[],
    this.canAccessStorage = false,
    this.choosePath = "",
  });

  final VideoStatus status;
  final List<VideoData> videos;
  final List<String> listPath;
  final bool canAccessStorage;
  final String choosePath;
  VideoState copyWith({
    VideoStatus? status,
    List<VideoData>? videos,
    List<String>? listPath,
    bool? canAccessStorage,
    String? choosePath,
  }) {
    return VideoState(
      status: status ?? this.status,
      videos: videos ?? this.videos,
      canAccessStorage: canAccessStorage ?? this.canAccessStorage,
      listPath: listPath ?? this.listPath,
      choosePath: choosePath ?? this.choosePath,
    );
  }

  @override
  String toString() {
    return '''VideoState { status: $status, posts: ${videos.length} }''';
  }

  @override
  List<Object> get props => [status, videos, canAccessStorage];
}
