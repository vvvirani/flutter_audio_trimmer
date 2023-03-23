class AudioTrimmerException implements Exception {
  final String code;
  final String message;
  final dynamic details;

  AudioTrimmerException({required this.code, required this.message, this.details});

  @override
  String toString() {
    return 'AudioTrimmerException($code, $message, $details)';
  }
}
