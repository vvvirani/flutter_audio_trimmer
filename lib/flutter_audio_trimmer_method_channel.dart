import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_audio_trimmer/flutter_audio_trimmer.dart';

import 'flutter_audio_trimmer_platform_interface.dart';

/// An implementation of [FlutterAudioTrimmerPlatform] that uses method channels.
class MethodChannelFlutterAudioTrimmer extends FlutterAudioTrimmerPlatform {
  final MethodChannel _methodChannel =
      const MethodChannel('vvvirani/flutter_audio_trimmer');

  @override
  Future<File?> trim({
    required File inputFile,
    required Directory outputDirectory,
    required String fileName,
    required AudioTrimTime time,
    required AudioFileType fileType,
  }) async {
    if (Platform.isIOS && fileType == AudioFileType.mp3) {
      throw AudioTrimmerException(
        code: 'unsupported_file_type',
        message: '.mp3 File type is not supported',
      );
    }
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
      throw AudioTrimmerException(
        code: e.code,
        message: e.message ?? '',
        details: e.details,
      );
    } catch (e) {
      throw AudioTrimmerException(code: 'unknown_error', message: e.toString());
    }
  }
}
