import 'dart:io';

import 'package:flutter_audio_trimmer/flutter_audio_trimmer.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_audio_trimmer_method_channel.dart';

abstract class FlutterAudioTrimmerPlatform extends PlatformInterface {
  /// Constructs a FlutterAudioTrimmerPlatform.
  FlutterAudioTrimmerPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterAudioTrimmerPlatform _instance =
      MethodChannelFlutterAudioTrimmer();

  /// The default instance of [FlutterAudioTrimmerPlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterAudioTrimmer].
  static FlutterAudioTrimmerPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterAudioTrimmerPlatform] when
  /// they register themselves.
  static set instance(FlutterAudioTrimmerPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<File> trim({
    required File inputFile,
    required Directory outputDirectory,
    required String fileName,
    required AudioFileType fileType,
    required AudioTrimTime time,
  });
}
