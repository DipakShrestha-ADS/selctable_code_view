<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages).
-->

# Selectable Code view

A widget to view code with the respective syntax highlighter and feature to zoom in & out, select the code, copy & share it.

## Features
-Display your code using syntax highlighter and code formatter for the following languages:
    -**C**
    -**C++**
    -**Dart/Flutter**
    -**Java**
    -**Javascript**
    -**Kotlin**
    -**Swift**
    -**YAML**
-Zoom in and out the code for better viewing experiencing.
-Can Copy the whole code
-Selection enabled
-Copy or share the selected code
-Different themes available
    -**standard**
    -**dracula**
    -**ayuDark**
    -**ayuLight**
    -**gravityLight**
    -**gravityDark**
    -**monokaiSublime**
    -**obsidian**
    -**oceanSunset**
    -**vscodeDark**
    -**vscodeLight**

## Getting started

Add Selectable Code View to your pubspec.yaml file:

```yaml
dependencies:
  selectable_code_view:
```

Import selectable code view in files that it will be used:

```dart
  import 'package:selectable_code_view/selectable_code_view.dart';
```
```dart
Widget build(BuildContext context) {
  return MaterialApp(
    home: Scaffold(
      appBar: AppBar(
        title: const Text(
          'Selectable Code View',
        ),
      ),
      body: Center(
        child: SelectableCodeView(
          code: code, // Code text
          language: Language.DART, // Language
          languageTheme: LanguageTheme.vscodeDark(), // Theme
          fontSize: 12.0, // Font size
          withZoom: true, // Enable/Disable zoom icon controls
          withLinesCount: true, // Enable/Disable line number
          expanded: false, // Enable/Disable container expansion
        ),
      ),
    ),
  );
}
```
##Result
![alt text](https://github.com/DipakShrestha-ADS/selctable_code_view/blob/dev/screenshots/main.png)
![alt text](https://github.com/DipakShrestha-ADS/selctable_code_view/blob/dev/screenshots/with_copy_share.png)
![alt text](https://github.com/DipakShrestha-ADS/selctable_code_view/blob/dev/screenshots/share.png)

## Additional information
Want to contribute to the project? We will be proud to highlight you as one of our collaborators.

Any contribution is welcome!

##If you have any queries, email me to dipak.shrestha@eemc.edu.np
