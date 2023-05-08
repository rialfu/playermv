import 'dart:io';

// import 'package:bloc/bloc.dart'
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:meta/meta.dart';
import 'package:mime/mime.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:playermv/Bloc/video_path/video_event.dart';
import 'package:playermv/Bloc/video_path/video_state.dart';

class VideoBloc extends Bloc<VideoEvent, VideoState> {
  static const mainPath = '/storage/emulated/0/';
  static const folderThumbnail = "${mainPath}playermv/thumbnail ";
  VideoBloc() : super(const VideoState()) {
    on<VideoLoad>(_onVideoLoad);
    on<ChoosePath>(_onChoosePath);
  }
  void _onChoosePath(ChoosePath event, Emitter<VideoState> emit) {
    emit(state.copyWith(choosePath: event.path));
    // print(event.path);
  }

  Future<void> _onVideoLoad(VideoLoad event, Emitter<VideoState> emit) async {
    emit(state.copyWith(status: VideoStatus.initial));
    try {
      if (state.status == VideoStatus.initial) {
        if (state.canAccessStorage == false) {
          bool resultPermission = await askPermission();
          if (resultPermission == false) {
            return emit(
              state.copyWith(status: VideoStatus.failure, videos: []),
            );
          }
        }
        List<String> listPath = await openDir(VideoBloc.mainPath);
        return emit(
          state.copyWith(
            status: VideoStatus.success,
            listPath: listPath,
          ),
        );
      }
      return emit(state.copyWith(status: VideoStatus.success, videos: []));
    } catch (_) {
      return emit(state.copyWith(status: VideoStatus.failure, videos: []));
    }
  }

  Future<bool> askPermission() async {
    if (Platform.isAndroid) {
      PermissionStatus result = await Permission.storage.request();
      if (result.isDenied) {
        return false;
      }
      result = await Permission.accessMediaLocation.request();
      if (result.isDenied) {
        return false;
      }
      result = await Permission.manageExternalStorage.request();
      if (result.isDenied) {
        return false;
      }
    } else {
      return true;
    }
    Directory thumbDir = Directory(VideoBloc.folderThumbnail);
    if (!thumbDir.existsSync()) {
      thumbDir.createSync(recursive: true);
    }
    return true;
  }

  static Future<List<String>> openDir(String path) async {
    Directory dir = Directory(path);
    List<String> listPath = [];
    bool containsVideo = false;
    if (!dir.existsSync()) return [];

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

  //  PostBloc({required this.httpClient}) : super(const PostState()) {
  //   on<PostFetched>(_onPostFetched);
  // }
  // Future<void> _onPostFetched(PostFetched event, Emitter<PostState> emit) async {
  //   if (state.hasReachedMax) return;
  //   try {
  //     if (state.status == PostStatus.initial) {
  //       final posts = await _fetchPosts();
  //       return emit(state.copyWith(
  //         status: PostStatus.success,
  //         posts: posts,
  //         hasReachedMax: false,
  //       ));
  //     }
  //     final posts = await _fetchPosts(state.posts.length);
  //     emit(posts.isEmpty
  //         ? state.copyWith(hasReachedMax: true)
  //         : state.copyWith(
  //             status: PostStatus.success,
  //             posts: List.of(state.posts)..addAll(posts),
  //             hasReachedMax: false,
  //           ));
  //   } catch (_) {
  //     emit(state.copyWith(status: PostStatus.failure));
  //   }
  // }
}
