import 'dart:io';

import 'package:audio_trimmer/audio_trimmer_platform_interface.dart';
import 'package:audio_trimmer/src/audio_file_type.dart';
import 'package:audio_trimmer/src/audio_trim_time.dart';

export 'src/audio_file_type.dart';
export 'src/audio_trim_exception.dart';
export 'src/audio_trim_time.dart';

class AudioTrimmer {
  const AudioTrimmer._();

  static final AudioTrimmerPlatform _platform = AudioTrimmerPlatform.instance;

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
