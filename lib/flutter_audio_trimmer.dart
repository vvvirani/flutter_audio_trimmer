import 'dart:io';

import 'package:flutter_audio_trimmer/src/audio_file_type.dart';
import 'package:flutter_audio_trimmer/src/audio_trim_time.dart';

import 'flutter_audio_trimmer_platform_interface.dart';

export 'src/audio_file_type.dart';
export 'src/audio_trim_exception.dart';
export 'src/audio_trim_time.dart';

class FlutterAudioTrimmer {
  const FlutterAudioTrimmer._();

  static final FlutterAudioTrimmerPlatform _platform =
      FlutterAudioTrimmerPlatform.instance;

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
