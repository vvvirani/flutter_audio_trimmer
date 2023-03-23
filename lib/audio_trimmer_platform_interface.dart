import 'dart:io';

import 'package:audio_trimmer/audio_trimmer_method_channel.dart';
import 'package:audio_trimmer/src/audio_file_type.dart';
import 'package:audio_trimmer/src/audio_trim_time.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

abstract class AudioTrimmerPlatform extends PlatformInterface {
  /// Constructs a AudioTrimmerPlatform.
  AudioTrimmerPlatform() : super(token: _token);

  static final Object _token = Object();

  static AudioTrimmerPlatform _instance = MethodChannelAudioTrimmer();

  /// The default instance of [AudioTrimmerPlatform] to use.
  ///
  /// Defaults to [MethodChannelAudioTrimmer].
  static AudioTrimmerPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [AudioTrimmerPlatform] when
  /// they register themselves.
  static set instance(AudioTrimmerPlatform instance) {
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
