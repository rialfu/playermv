import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:playermv/Bloc/States/main_state.dart';

enum PathEvents { fetch, reset }

class PathDataBloc extends Bloc<PathEvents, MainState> {
  PathDataBloc() : super(MainInitState());
  Stream<MainState> mapEventToState(PathEvents event) async* {
    switch (event) {
      case PathEvents.fetch:
        // yield VideosLoading();
        try {
          // video.addAll(await videoRepo.getVideoList());
          // yield VideosLoaded(videos: video);
        } catch (e) {
          // VideosListError(error: 'some error');
        }
        break;
      case PathEvents.reset:
        // video.clear();
        break;
    }
  }
}
