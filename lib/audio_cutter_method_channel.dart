import 'dart:io';

import 'package:audio_cutter/src/audio_file_type.dart';
import 'package:audio_cutter/src/audio_trim_time.dart';
import 'package:audio_cutter/src/audio_trim_exception.dart';
import 'package:flutter/services.dart';

import 'audio_cutter_platform_interface.dart';

class MethodChannelAudioCutter extends AudioCutterPlatform {
  final MethodChannel _methodChannel =
      const MethodChannel('vvvirani/audio_cutter');

  @override
  Future<File?> trim({
    required File inputFile,
    required Directory outputDirectory,
    required String fileName,
    required AudioTrimTime time,
    required AudioFileType fileType,
  }) async {
    try {
      String? resultPath = await _methodChannel.invokeMethod<String?>(
        'trim',
        <String, dynamic>{
          'input_path': inputFile.path,
          'output_path': '${outputDirectory.path}/$fileName.${fileType.name}',
          'start_time': time.start.inSeconds.toDouble(),
          'end_time': time.end.inSeconds.toDouble(),
          'file_type': fileType.name,
        },
      );
      return resultPath != null ? File(resultPath) : null;
    } on PlatformException catch (e) {
      throw AudioTrimException(
        code: e.code,
        message: e.message ?? '',
        details: e.details,
      );
    } catch (e) {
      throw AudioTrimException(code: 'unknown_error', message: e.toString());
    }
  }
}
