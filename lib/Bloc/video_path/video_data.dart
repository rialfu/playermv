import 'package:equatable/equatable.dart';

class VideoData extends Equatable {
  const VideoData({required this.path, required this.name, this.thumbnail});

  final String path;
  final String name;
  final String? thumbnail;

  @override
  List<Object> get props => [path, name, thumbnail ?? ""];
}
