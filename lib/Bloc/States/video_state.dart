import 'package:equatable/equatable.dart';
import 'package:playermv/Data/video_data.dart';

abstract class VideosState extends Equatable {
  @override
  List<Object> get props => [];
}

class VideosInitState extends VideosState {}

class VideosLoading extends VideosState {}

class VideosLoaded extends VideosState {
  final List<VideoPathFolder> videos;
  VideosLoaded({required this.videos});

  @override
  List<Object> get props => [videos];
}

class VideosLoadingExtend extends VideosState {
  final List<VideoPathFolder> videos;
  VideosLoadingExtend({required this.videos});

  @override
  List<Object> get props => [videos];
}

class VideosListError extends VideosState {
  final Object error;
  VideosListError({required this.error});
}
