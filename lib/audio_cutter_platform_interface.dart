import 'dart:io';

import 'package:audio_cutter/src/audio_file_type.dart';
import 'package:audio_cutter/src/audio_trim_time.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'audio_cutter_method_channel.dart';

abstract class AudioCutterPlatform extends PlatformInterface {
  AudioCutterPlatform() : super(token: _token);

  static final Object _token = Object();

  static AudioCutterPlatform _instance = MethodChannelAudioCutter();

  static AudioCutterPlatform get instance => _instance;

  static set instance(AudioCutterPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<File?> trim({
    required File inputFile,
    required Directory outputDirectory,
    required String fileName,
    required AudioFileType fileType,
    required AudioTrimTime time,
  });
}
