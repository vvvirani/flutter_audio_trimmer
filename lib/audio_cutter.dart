import 'dart:io';

import 'package:audio_cutter/audio_cutter_platform_interface.dart';
import 'package:audio_cutter/src/audio_trim_time.dart';

export 'src/audio_trim_time.dart';
export 'src/audio_trim_exception.dart';

class AudioCutter {
  AudioCutter._();

  static final AudioCutterPlatform _platform = AudioCutterPlatform.instance;

  static Future<File?> trim({
    required File file,
    required String outputPath,
    required AudioTrimTime time,
  }) {
    return _platform.trim(file: file, outputPath: outputPath, time: time);
  }
}
