class AudioTrimTime {
  final Duration start;
  final Duration end;

  AudioTrimTime({required this.start, required this.end})
      : assert(start.inSeconds != 0 && end.inSeconds != 0);
}
