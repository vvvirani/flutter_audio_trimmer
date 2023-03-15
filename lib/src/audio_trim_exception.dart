class AudioTrimException implements Exception {
  final String code;
  final String message;
  final dynamic details;

  AudioTrimException({required this.code, required this.message, this.details});

  @override
  String toString() {
    return 'AudioTrimException($code, $message, $details)';
  }
}
