import 'dart:io';

import 'package:audio_cutter/src/audio_trim_time.dart';
import 'package:audio_cutter/src/audio_trim_exception.dart';
import 'package:flutter/services.dart';

import 'audio_cutter_platform_interface.dart';

class MethodChannelAudioCutter extends AudioCutterPlatform {
  final MethodChannel _methodChannel =
      const MethodChannel('vvvirani/audio_cutter');

  @override
  Future<File?> trim({
    required File file,
    required String outputPath,
    required AudioTrimTime time,
  }) async {
    try {
      String? resultPath = await _methodChannel.invokeMethod<String?>(
        'trim',
        <String, dynamic>{
          'file_path': file.path,
          'output_path': outputPath,
          'start_time': time.start.inSeconds.toDouble(),
          'end_time': time.end.inSeconds.toDouble(),
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
