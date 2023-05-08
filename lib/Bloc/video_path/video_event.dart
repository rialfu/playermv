import 'package:equatable/equatable.dart';

abstract class VideoEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class VideoLoad extends VideoEvent {}

class ChoosePath extends VideoEvent {
  final String path;
  ChoosePath(this.path);
}
