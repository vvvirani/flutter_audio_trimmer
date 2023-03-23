import 'dart:io';

import 'package:audio_cutter/audio_cutter_platform_interface.dart';
import 'package:audio_cutter/src/audio_file_type.dart';
import 'package:audio_cutter/src/audio_trim_time.dart';

export 'src/audio_trim_time.dart';
export 'src/audio_trim_exception.dart';
export 'src/audio_file_type.dart';

class AudioCutter {
  AudioCutter._();

  static final AudioCutterPlatform _platform = AudioCutterPlatform.instance;

  static Future<File?> trim({
    required File inputFile,
    required Directory outputDirectory,
    required String fileName,
    required AudioFileType fileType,
    required AudioTrimTime time,
  }) {
    return _platform.trim(
      inputFile: inputFile,
      outputDirectory: outputDirectory,
      fileName: fileName,
      fileType: fileType,
      time: time,
    );
  }
}
