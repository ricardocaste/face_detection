# face_detection
Flutter Face Detection with google_ml_kit

Google's ML Kit is a Flutter plugin to use Google's standalone ML Kit for Android and iOS.

# Google's ML Kit Flutter Plugin

[![Pub Version](https://img.shields.io/pub/v/google_ml_kit)](https://pub.dev/packages/google_ml_kit)

A Flutter plugin to use [Google's standalone ML Kit](https://developers.google.com/ml-kit) for Android and iOS.

## Features

### Vision

| Face Detection Feature                                                                                       | Android | iOS |
|-----------------------------------------------------------------------------------------------|---------|-----|
|[Face Detection](https://developers.google.com/ml-kit/vision/face-detection)                   | ✅      | ✅  |

## Requirements

### iOS

- Minimum iOS Deployment Target: 10.0
- Xcode 12 or newer
- Swift 5
- ML Kit only supports 64-bit architectures (x86_64 and arm64). Check this [list](https://developer.apple.com/support/required-device-capabilities/) to see if your device has the required device capabilities.

Since ML Kit does not support 32-bit architectures (i386 and armv7) ([Read mode](https://developers.google.com/ml-kit/migration/ios)), you need to exclude amrv7 architectures in Xcode in order to run `flutter build ios` or `flutter build ipa`.

Go to Project > Runner > Building Settings > Excluded Architectures > Any SDK > armv7

![](https://github.com/bharat-biradar/Google-Ml-Kit-plugin/blob/master/ima/build_settings_01.png)

Then your Podfile should look like this:

```
# add this line:
$iOSVersion = '10.0'

post_install do |installer|
  # add these lines:
  installer.pods_project.build_configurations.each do |config|
    config.build_settings["EXCLUDED_ARCHS[sdk=*]"] = "armv7"
    config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = $iOSVersion
  end
  
  installer.pods_project.targets.each do |target|
    flutter_additional_ios_build_settings(target)
    
    # add these lines:
    target.build_configurations.each do |config|
      if Gem::Version.new($iOSVersion) > Gem::Version.new(config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'])
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = $iOSVersion
      end
    end
    
  end
end
```

Notice that the minimum `IPHONEOS_DEPLOYMENT_TARGET` is 10.0, you can set it to something newer but not older.

### Android

- minSdkVersion: 21
- targetSdkVersion: 29

## Usage

Add this plugin as dependency in your pubspec.yaml.

- In your project-level build.gradle file, make sure to include Google's Maven repository in both your buildscript and allprojects sections(for all api's).
- All API's except `Image Labeling`, `Face Detection` and `Barcode Scanning` use bundled models, hence others should work out of the box.
- For API's using unbundled models, configure your application to download the model to your device automatically from play store by adding the following to your app's `AndroidManifest.xml`, if not configured the respective models will be downloaded when the API's are invoked for the first time. 

  ```xml
  <meta-data
          android:name="com.google.mlkit.vision.DEPENDENCIES"
          android:value="ica" />
      <!-- To use multiple models: android:value="ica,model2,model3" -->
  ```
  
  Use these options:
  
  - **ica** - `Image Labeling`
  - **ocr** - `Barcode Scanning`
  - **face** -`Face Detection`

## Migrating from ML Kit for Firebase

When Migrating from ML Kit for Firebase read [this guide](https://developers.google.com/ml-kit/migration). For Android details read [this](https://developers.google.com/ml-kit/migration/android). For iOS details read [this](https://developers.google.com/ml-kit/migration/ios).

## Known issues

### Android

To reduce the apk size read more about it in issue [#26](https://github.com/bharat-biradar/Google-Ml-Kit-plugin/issues/26). Also look at [this](https://developers.google.com/ml-kit/tips/reduce-app-size).

### iOS

If you are using this plugin in your app and any other plugin that requires Firebase, there is a known issues you will encounter a dependency error when running `pod install`. To read more about it go to issue [#27](https://github.com/bharat-biradar/Google-Ml-Kit-plugin/issues/27).
