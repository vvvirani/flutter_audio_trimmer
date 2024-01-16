#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint flutter_audio_trimmer.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'flutter_audio_trimmer'
  s.version          = '0.0.5'
  s.summary          = 'Trimming an audio file means cutting a portion of the audio from the beginning or end of the file or removing some part from the middle.'
  s.description      = <<-DESC
Trimming an audio file means cutting a portion of the audio from the beginning or end of the file or removing some part from the middle.
                       DESC
  s.homepage         = 'https://github.com/vvvirani/flutter_audio_trimmer'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Vishal Virani' => 'vvvirani@gmail.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '9.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end
