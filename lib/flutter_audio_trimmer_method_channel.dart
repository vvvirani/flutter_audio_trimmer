import 'dart:io';

import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter/return_code.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_audio_trimmer/flutter_audio_trimmer.dart';

import 'flutter_audio_trimmer_platform_interface.dart';

/// An implementation of [FlutterAudioTrimmerPlatform] that uses method channels.
class MethodChannelFlutterAudioTrimmer extends FlutterAudioTrimmerPlatform {
  final MethodChannel _methodChannel =
      const MethodChannel('vvvirani/flutter_audio_trimmer');

  @override
  Future<File> trim({
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
      String outputPath = '${outputDirectory.path}/$fileName.${fileType.name}';

      switch (defaultTargetPlatform) {
        case TargetPlatform.android:
          return _trimAudioForAndroid(
            inputPath: inputFile.path,
            time: time,
            outputPath: outputPath,
          );
        //
        case TargetPlatform.iOS:
          return _trimAudioForIos(
            inputPath: inputFile.path,
            time: time,
            outputPath: outputPath,
            fileType: fileType,
          );
        default:
          throw AudioTrimmerException(
            code: 'not_supported',
            message: '${defaultTargetPlatform.name} is not supported',
          );
      }
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

  Future<File> _trimAudioForAndroid({
    required String inputPath,
    required AudioTrimTime time,
    required String outputPath,
  }) {
    List<String> commandArguments = [
      '-i',
      inputPath,
      '-ss',
      time.start.inSeconds.toDouble().toString(),
      '-t',
      time.end.inSeconds.toDouble().toString(),
      '-c',
      'copy',
      outputPath
    ];
    return FFmpegKit.executeWithArguments(commandArguments)
        .then((session) async {
      ReturnCode? returnCode = await session.getReturnCode();

      if (ReturnCode.isSuccess(returnCode)) {
        return File(outputPath);
      } else {
        String? failStackTrace = await session.getFailStackTrace();
        throw AudioTrimmerException(
          code: 'failed',
          message: 'Error in processing. Try again',
          details: failStackTrace,
        );
      }
    });
  }

  Future<File> _trimAudioForIos({
    required String inputPath,
    required AudioTrimTime time,
    required String outputPath,
    required AudioFileType fileType,
  }) async {
    String? resultPath = await _methodChannel.invokeMethod<String?>(
      'trim',
      <String, dynamic>{
        'input_path': inputPath,
        'output_path': outputPath,
        'start_time': time.start.inSeconds.toDouble(),
        'end_time': time.end.inSeconds.toDouble(),
        'file_type': fileType.name,
      },
    );
    return File(resultPath!);
  }
}
