# Audio Trimmer

Trimming an audio file means cutting a portion of the audio from the beginning or end of the file or removing some part from the middle.

## Dart API

The library offers several methods to handle audio trim related actions:

```dart
Future<File?> trim({
    required File inputFile,
    required Directory outputDirectory,
    required String fileName,
    required AudioFileType fileType,
    required AudioTrimTime time,
  }){...};
```

## Run the example app

- Navigate to the example folder `cd example`
- Install the dependencies
  - `flutter pub get`

## Contributing

You can help us make this project better, feel free to open an new issue or a pull request.
