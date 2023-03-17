import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:playermv/Bloc/Services/video_service.dart';
import 'package:playermv/Bloc/States/video_state.dart';
import 'package:playermv/Data/video_data.dart';

enum VideoEvents {
  fetchVideo,
  fetchPath,
  reset,
}

class VideoBloc extends Bloc<VideoEvents, VideosState> {
  final VideoRepo videoRepo;
  List<VideoPathFolder> video = [];
  List<String> listPathContainsVideo = [];
  VideoBloc({required this.videoRepo}) : super(VideosInitState());

  Stream<VideosState> mapEventToState(VideoEvents event) async* {
    switch (event) {
      case VideoEvents.fetchVideo:
        yield VideosInitState();
        yield VideosLoading();
        try {} catch (e) {
          yield VideosListError(error: 'some error');
        }
        break;

      case VideoEvents.reset:
        video.clear();
        break;
      case VideoEvents.fetchPath:
        yield VideosInitState();
        yield VideosLoading();
        try {
          List<VideoPathFolder> datas = [];
          var pathList = await videoRepo.getPathFromStorage();
          if (pathList != null) {
            datas.addAll(pathList);
            yield VideosLoadingExtend(videos: datas);
          }

          var newData = await videoRepo.getVideoList();
          int i = 0;
          int j = 0;
          VideoPathFolder? element1;
          VideoPathFolder? element2;
          int maxNewData = newData.length;
          for (i; i < maxNewData; i++) {
            element1 = newData[i];
            element2 = null;
            for (final data in datas) {
              if (element1.path == data.path) {
                element2 = data;
                break;
              }
            }
            if (element2 == null) continue;
            for (j = 0; j < element1.data.length; j++) {
              for (final data in element2.data) {
                if (element1.data[j].path == data.path) {
                  newData[i].data[j].updateThumbnail(data.thumbnail);
                  break;
                }
              }
            }
          }
          yield VideosLoaded(videos: newData);
        } catch (err) {
          yield VideosListError(error: 's');
        }

        break;
    }
  }
  // Stream<VideosState> mapEventToState
}
